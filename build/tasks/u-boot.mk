# Copyright (C) 2020 The LineageOS Project
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

ifneq ($(filter yukawa%, $(TARGET_DEVICE)),)

ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Device
ifneq ($(filter $(TARGET_DEV_BOARD),vim3 vim3l),)
  BOOTLOADER_DEVICE := khadas-$(TARGET_DEV_BOARD)
endif
BOOTLOADER_DEVICE ?= $(TARGET_DEV_BOARD)

# Defconfig
ifneq ($(filter $(TARGET_DEV_BOARD),sei510 sei610),)
    BOOTLOADER_DEFCONFIG := $(BOOTLOADER_DEVICE)_defconfig
endif
BOOTLOADER_DEFCONFIG ?= $(BOOTLOADER_DEVICE)_android_ab_defconfig

# Firmware
BOOTLOADER_FIRMWARE := $(BUILD_TOP)/external/amlogic-boot-fip/$(BOOTLOADER_DEVICE)

# GCC
GCC_PREBUILTS_PATH := $(BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64
ifneq ($(wildcard $(GCC_PREBUILTS_PATH)/aarch64-none-linux-gnu-10.3),)
    GCC_CROSS_COMPILER := aarch64-none-linux-gnu-
    GCC_VERSION := aarch64-none-linux-gnu-10.3
endif
GCC_CROSS_COMPILER ?= aarch64-buildroot-linux-gnu-
GCC_VERSION ?= aarch64-linux-gnu-9.3

# Tools
BUILD_TOOLS_BINS := $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)/bin
BUILD_TOOLS_CLANG_PATH ?= $(TARGET_KERNEL_CLANG_PATH)
BUILD_TOOLS_GCC_PATH ?= $(BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/$(GCC_VERSION)
BUILD_TOOLS_EXTRA := $(BUILD_TOP)/device/amlogic/yukawa/build/tools
BUILD_TOOLS_PATH := $(BUILD_TOOLS_BINS):$(BUILD_TOOLS_CLANG_PATH)/bin:$(BUILD_TOOLS_GCC_PATH)/bin:$(BUILD_TOOLS_EXTRA)

# Task to build U-Boot bootloader
BOOTLOADER_OUT := $(TARGET_OUT_INTERMEDIATES)/BOOTLOADER_OBJ
BOOTLOADER_CONFIG := $(BOOTLOADER_OUT)/.config
BOOTLOADER_BIN := $(PRODUCT_OUT)/u-boot.bin

BOOTLOADER_FLAGS := HOSTCC=clang
ifneq ($(TARGET_BOOTLOADER_NO_GCC),true)
BOOTLOADER_FLAGS += CROSS_COMPILE="$(CCACHE_EXEC) $(GCC_CROSS_COMPILER)"
else
BOOTLOADER_FLAGS += \
    CC="$(CCACHE_EXEC) clang -target aarch64-linux-gnu" \
    CROSS_COMPILE="$(GCC_CROSS_COMPILER)"
endif

$(warning GCC: $(GCC_VERSION))
$(warning LLVM: $(TARGET_KERNEL_CLANG_VERSION))
$(warning Compiler flags: $(strip $(BOOTLOADER_FLAGS)))

define make-bootloader-target
  PATH=$(BUILD_TOOLS_PATH):$$PATH \
    $(KERNEL_MAKE_CMD) \
    -C $(TARGET_BOOTLOADER_SOURCE) \
    $(strip $(BOOTLOADER_FLAGS)) \
    O=$(BUILD_TOP)/$(1) \
    $(2)
endef

define sign-bootloader-target
  @mkdir -p $(3)/tmp
  PATH=$(BUILD_TOOLS_PATH):$$PATH sign-aml-fip.sh $(2) $(3)/$(notdir $(1)) $(3)/tmp
  mv $(3)/tmp/$(notdir $(1)) $(1)
  rm -rf $(3)/tmp
endef

$(BOOTLOADER_OUT):
	@mkdir -p $(BOOTLOADER_OUT)

$(BOOTLOADER_CONFIG): $(BOOTLOADER_OUT)
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(BOOTLOADER_DEFCONFIG))

$(BOOTLOADER_BIN): $(BOOTLOADER_OUT) $(BOOTLOADER_CONFIG)
	$(call pretty,"Target u-boot image: $@")
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(notdir $@))
	$(hide) $(call sign-bootloader-target,$@,$(BOOTLOADER_FIRMWARE),$(BOOTLOADER_OUT))

include $(CLEAR_VARS)
LOCAL_MODULE := u-boot.bin
LOCAL_LICENSE_KINDS := legacy_restricted
LOCAL_LICENSE_CONDITIONS := restricted
LOCAL_ADDITIONAL_DEPENDENCIES := $(BOOTLOADER_BIN)
include $(BUILD_PHONY_PACKAGE)

droidcore: u-boot.bin
$(call dist-for-goals, dist_files, $(BOOTLOADER_BIN))

endif # TARGET_NO_BOOTLOADER

endif # TARGET_DEVICE
