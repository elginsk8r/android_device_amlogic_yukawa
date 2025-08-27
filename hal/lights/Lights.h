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

#pragma once

#include <aidl/android/hardware/light/BnLights.h>
#include <android-base/logging.h>
#include <array>
#include <vector>

namespace aidl {
namespace android {
namespace hardware {
namespace light {

struct LightAddress {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
};

class Lights : public BnLights {
  public:
    Lights();

    ndk::ScopedAStatus setLightState(int id, const HwLightState& state) override;
    ndk::ScopedAStatus getLights(std::vector<HwLight>* lights) override;

  private:
    std::vector<HwLight> mLights;

    void addLight(LightType const type, int const ordinal);
    int rgbToBrightness(int color);
    int writeLedArray(const char* path, LightAddress const& addr, int color);
    void writeLed(const char* path, int color);
};

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
