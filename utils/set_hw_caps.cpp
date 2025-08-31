#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>
#include <vector>

#include <stdlib.h>

#include <android-base/properties.h>
#include <android-base/strings.h>

using android::base::SetProperty;

const std::string kDtCompatiblePath = "/sys/firmware/devicetree/base/compatible";

struct DeviceInfo {
    bool internalSpeaker;
};

struct VendorInfo {
    std::string name;
    std::unordered_map<std::string, DeviceInfo> devices;
};

static const std::vector<VendorInfo> kSupportedMap = {
    {
        "seirobotics", {
            { "sei510", { true } },
            { "sei610", { true } },
        }
    },
};

std::vector<std::string> readDtCompatible(const std::string& filename) {
    std::vector<std::string> result;
    std::ifstream file(filename, std::ios::binary);

    if (!file) {
        std::cerr << "Could not open file: " << filename << std::endl;
        return result;
    }

    std::string buffer;
    char ch;
    while (file.get(ch)) {
        if (ch != '\0') {
            buffer += ch;
        } else {
            if (!buffer.empty()) {
                result.push_back(buffer);
                buffer.clear();
            }
        }
    }
    if (!buffer.empty()) {
        result.push_back(buffer);
    }

    return result;
}

const DeviceInfo* FindDeviceInfo(const std::vector<std::string>& compatibles) {
    for (const auto& compatible : compatibles) {
        auto pos = compatible.find(',');
        if (pos == std::string::npos) continue;

        std::string vendor = compatible.substr(0, pos);
        std::string codename = compatible.substr(pos + 1);

        for (const auto& v : kSupportedMap) {
            if (v.name == vendor) {
                auto it = v.devices.find(codename);
                if (it != v.devices.end()) {
                    return &it->second;
                }
            }
        }
    }
    return nullptr;
}

int main() {
    std::vector<std::string> compatibles = readDtCompatible(kDtCompatiblePath);
    if (compatibles.empty()) {
        std::cerr << "Failed to read " << kDtCompatiblePath << std::endl;
        return EXIT_FAILURE;
    }

    bool ret = true;
    const DeviceInfo* deviceInfo = FindDeviceInfo(compatibles);

    std::string internalSpeakerSupported = deviceInfo && deviceInfo->internalSpeaker ? "true" : "false";
    std::cout << "Device supports internal speaker: " << internalSpeakerSupported << std::endl;
    ret &= SetProperty("vendor.audio.hal.speaker.supported", internalSpeakerSupported);

    return ret ? EXIT_SUCCESS : EXIT_FAILURE;
}
