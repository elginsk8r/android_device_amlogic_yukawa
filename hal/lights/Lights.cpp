/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Lights.h"

#define LOG_TAG "Lights"

#include <linux/i2c-dev.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

namespace aidl {
namespace android {
namespace hardware {
namespace light {

static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

char const* const kRedLedFile = "/sys/class/leds/sei610:red:power/brightness";
char const* const kBlueLedFile = "/sys/class/leds/sei610:blue:bt/brightness";

std::array<LightAddress, 4> const mLightAddrs = {
    LightAddress{0x20, 0x21, 0x22}, LightAddress{0x23, 0x24, 0x25},
    LightAddress{0x26, 0x27, 0x28}, LightAddress{0x29, 0x2A, 0x2B}};

constexpr int kLaP0Enable = 0x12;
constexpr int kLaP1Enable = 0x13;
constexpr int kLaResetAddr = 0x7F;

char const* const kControllerPath = "/dev/i2c-0";
const int kControllerAddr = (0xB6 >> 1); /* 0x5B */

static int sysWriteInt(int fd, int value) {
    char buffer[16];
    size_t bytes;
    ssize_t amount;

    bytes = snprintf(buffer, sizeof(buffer), "%d\n", value);
    if (bytes >= sizeof(buffer)) return -EINVAL;
    amount = write(fd, buffer, bytes);
    return amount == -1 ? -errno : 0;
}

static int sysWriteRegs(int fd, uint8_t regaddr, uint8_t cmd) {
    uint8_t buf[2];
    buf[0] = regaddr;
    buf[1] = cmd;
    if (write(fd, buf, 2) != 2) return -1;
    return 0;
}

void Lights::addLight(LightType const type, int const ordinal) {
    HwLight light{};
    light.id = mLights.size();
    light.type = type;
    light.ordinal = ordinal;
    mLights.emplace_back(light);
}

int Lights::rgbToBrightness(int color) {
    int const r = ((color >> 16) & 0xFF) * 77 / 255;
    int const g = ((color >> 8) & 0xFF) * 150 / 255;
    int const b = (color & 0xFF) * 29 / 255;
    return (r << 16) | (g << 8) | b;
}

int Lights::writeLedArray(const char* path, LightAddress const& addr, int color) {
    int const fd = open(path, O_RDWR);
    if (fd < 0) {
        LOG(ERROR) << "Could not open array LED device: " << path;
        return fd;
    }
    if (ioctl(fd, I2C_SLAVE, kControllerAddr) < 0) {
        LOG(ERROR) << "Could not set slave address";
        close(fd);
        return -errno;
    }

    sysWriteRegs(fd, addr.red, ((color >> 16) & 0xFF));
    sysWriteRegs(fd, addr.green, ((color >> 8) & 0xFF));
    sysWriteRegs(fd, addr.blue, (color)&0xFF);

    sysWriteRegs(fd, kLaP0Enable, 0x00);
    sysWriteRegs(fd, kLaP1Enable, 0x00);

    close(fd);
    return 0;
}

void Lights::writeLed(const char* path, int color) {
    int fd = open(path, O_WRONLY);
    if (fd < 0) {
        LOG(ERROR) << "Could not open LED device: " << path;
        return;
    }
    sysWriteInt(fd, color);
    close(fd);
}

Lights::Lights() : BnLights() {
    pthread_mutex_init(&g_lock, NULL);

    addLight(LightType::BACKLIGHT, 0);
    addLight(LightType::KEYBOARD, 0);
    addLight(LightType::BUTTONS, 0);
    addLight(LightType::BATTERY, 0);
    addLight(LightType::NOTIFICATIONS, 0);
    addLight(LightType::ATTENTION, 0);
    addLight(LightType::BLUETOOTH, 0);
    addLight(LightType::WIFI, 0);

    for (int i = 0; i < 4; i++) {
        addLight(LightType::MICROPHONE, i);
    }

    writeLed(kRedLedFile, rgbToBrightness(0x00000000));
    writeLed(kBlueLedFile, rgbToBrightness(0xFFFFFFFF));
}

ndk::ScopedAStatus Lights::setLightState(int id, const HwLightState& state) {
    if (!(0 <= id && id < mLights.size())) {
        LOG(ERROR) << "Light id " << (int32_t)id << " does not exist.";
        return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    }

    int const color = rgbToBrightness(state.color);
    HwLight const& light = mLights[id];

    int ret = 0;

    switch (light.type) {
        case LightType::MICROPHONE:
            ret = writeLedArray(kControllerPath, mLightAddrs[light.ordinal], color);
            break;
        case LightType::BATTERY:
            writeLed(kRedLedFile, color);
            break;
        case LightType::BLUETOOTH:
            writeLed(kBlueLedFile, color);
            break;
        default:
            break;
    }

    if (ret == 0) {
        return ndk::ScopedAStatus::ok();
    } else {
        return ndk::ScopedAStatus::fromServiceSpecificError(ret);
    }
}

ndk::ScopedAStatus Lights::getLights(std::vector<HwLight>* lights) {
    for (auto i = mLights.begin(); i != mLights.end(); i++) {
        lights->push_back(*i);
    }
    return ndk::ScopedAStatus::ok();
}

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
