#
# Copyright (C) 2013 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Hardware composer
BOARD_USES_DRM_HWCOMPOSER := true

# Mesa
ifeq ($(TARGET_BUILD_MESA),true)
BOARD_MESA3D_USES_MESON_BUILD := true
BOARD_MESA3D_GALLIUM_DRIVERS := panfrost
BOARD_MESA3D_VULKAN_DRIVERS := panfrost
endif

ifneq ($(wildcard hardware/mesa/VERSION),)

MESA_VERSION_STRING := $(shell cat hardware/mesa/VERSION)
MESA_VERSION_MAJOR := $(shell echo "$(MESA_VERSION_STRING)" | cut -d '.' -f 1)
MESA_VERSION_MINOR := $(shell echo "$(MESA_VERSION_STRING)" | cut -d '.' -f 2)
MESA_VERSION_PATCH_PRE := $(shell echo "$(MESA_VERSION_STRING)" | cut -d '.' -f 3)
MESA_VERSION_PATCH := $(shell echo "$(MESA_VERSION_PATCH_PRE)" | cut -d '-' -f 1)
MESA_VERSION_PRE_RELEASE := $(shell echo "$(MESA_VERSION_PATCH_PRE)" | cut -d '-' -f 2)

ifeq ($(shell expr $(MESA_VERSION_MAJOR) \>= 25), 1)
BOARD_MESA3D_MESON_ARGS := -Dmesa-clc=system
endif

ifneq ($(wildcard external/llvm-project/Android.bp),)
BUILD_BROKEN_PLUGIN_VALIDATION += \
    soong-llvm12 \
    soong-llvm17 \
    soong-llvm18 \
    soong-llvm19
endif

endif
