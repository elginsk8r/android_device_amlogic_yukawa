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
else ifeq ($(TARGET_USE_AB_SLOT), true)
BOOTLOADER_DEFCONFIG := $(BOOTLOADER_DEVICE)_android_ab_defconfig
endif
BOOTLOADER_DEFCONFIG ?= $(BOOTLOADER_DEVICE)_android_defconfig

# Firmware Image
AML_FIRMWARE_PATH := $(BUILD_TOP)/device/amlogic/yukawa/bootloader
ifeq ($(TARGET_DEV_BOARD), vim3)
AML_FIRMWARE := fip-collect-g12b-kvim3-khadas-vims-pie-20210111-211833
else ifeq ($(TARGET_DEV_BOARD), vim3l)
AML_FIRMWARE := fip-collect-g12a-kvim3l-khadas-vims-pie-20210111-211224
else ifeq ($(TARGET_DEV_BOARD), sei610)
AML_FIRMWARE := fip-collect-g12a-sm1_ac214_v1-amlogic-dev_9.2.1811_21-20191204-161855
else
AML_FIRMWARE ?= fip-collect-g12a-g12a_u200_v1-amlogic-dev_9.2.1811_21-20191203-113239
endif

# Prebuilt tools
BUILD_TOOLS_GCC_PREFIX := aarch64-buildroot-linux-gnu-
BUILD_TOOLS_FIP_GEN := generate-fip
BUILD_TOOLS_PATH_OVERRIDE := \
    $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)/bin \
    $(TARGET_KERNEL_CLANG_PATH)/bin \
    $(BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-gnu-9.3/bin \
    $(BUILD_TOP)/device/amlogic/yukawa/build/tools
BUILD_TOOLS_PATH_OVERRIDE := $(subst $(space),:,$(strip $(BUILD_TOOLS_PATH_OVERRIDE)))

# Task to build U-Boot bootloader
BOOTLOADER_OUT := $(TARGET_OUT_INTERMEDIATES)/BOOTLOADER_OBJ
BOOTLOADER_FIRMWARE_INFO := $(BOOTLOADER_OUT)/$(AML_FIRMWARE)/info.txt
BOOTLOADER_UNSIGNED := $(BOOTLOADER_OUT)/u-boot.bin
BOOTLOADER_BIN := $(PRODUCT_OUT)/u-boot.bin

define make-bootloader-target
  PATH=$(BUILD_TOOLS_PATH_OVERRIDE):$$PATH \
    $(KERNEL_MAKE_CMD) \
    -C $(TARGET_BOOTLOADER_SOURCE) \
    O=$(BUILD_TOP)/$(1) \
    HOSTCC=clang \
    CROSS_COMPILE=$(BUILD_TOOLS_GCC_PREFIX) $(2)
endef

define extract-bootloader-firmware
  $(GZIP) -dc $(AML_FIRMWARE_PATH)/fip_packages/$(1).tar.gz > $(2)/$(1).tar
  tar -xf $(2)/$(1).tar -C $(2)
  rm -rf $(2)/$(1).tar
endef

define sign-bootloader-target
  @mkdir -p $(3)/tmp
  PATH=$(BUILD_TOOLS_PATH_OVERRIDE):$$PATH \
    $(BUILD_TOOLS_FIP_GEN) $(2) $(3)/$(notdir $(1)) $(3)/tmp
  mv $(3)/tmp/$(notdir $(1)) $(1)
  rm -rf $(3)/tmp
endef

$(BOOTLOADER_OUT):
	@mkdir -p $(BOOTLOADER_OUT)

$(BOOTLOADER_UNSIGNED): $(BOOTLOADER_OUT)
	@echo "Building U-Boot Image for $(TARGET_DEV_BOARD)"
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(BOOTLOADER_DEFCONFIG))
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(notdir $@))

$(BOOTLOADER_FIRMWARE_INFO): $(GZIP) $(BOOTLOADER_OUT)
	@echo "Extracting firmware for $(TARGET_DEV_BOARD)"
	$(hide) $(call extract-bootloader-firmware,$(AML_FIRMWARE),$(BOOTLOADER_OUT))
	$(hide) touch $@

$(BOOTLOADER_BIN): $(BOOTLOADER_UNSIGNED) $(BOOTLOADER_FIRMWARE_INFO)
	@echo "Signing U-Boot Image for $(TARGET_DEV_BOARD)"
	$(hide) $(call sign-bootloader-target,$@,$(dir $(BOOTLOADER_FIRMWARE_INFO)),$(dir $(BOOTLOADER_UNSIGNED)))

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
