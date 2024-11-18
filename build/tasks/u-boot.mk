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
BOOTLOADER_DEFCONFIG ?= $(BOOTLOADER_DEVICE)_android_defconfig

ifeq ($(filter $(TARGET_DEV_BOARD),sei510),)
ifeq ($(TARGET_USE_AB_SLOT), true)
BOOTLOADER_DEFCONFIG := $(patsubst defconfig,ab_defconfig,$(BOOTLOADER_DEFCONFIG))
endif
endif

# Firmware Image
ifeq ($(TARGET_DEV_BOARD), vim3)
AML_FIRMWARE := fip-collect-g12b-kvim3-khadas-vims-pie-20210111-211833
else ifeq ($(TARGET_DEV_BOARD), vim3l)
AML_FIRMWARE := fip-collect-g12a-kvim3l-khadas-vims-pie-20210111-211224
else ifeq ($(TARGET_DEV_BOARD), odroid-n2)
AML_FIRMWARE := fip-collect-g12b-odroidn2-odroidg12-v2015.01-20210906-162510
else ifeq ($(TARGET_DEV_BOARD), sei510)
AML_FIRMWARE := fip-collect-g12a-g12a_u200_v1-amlogic-dev_9.2.1811_21-20191203-113239
endif
AML_FIRMWARE ?= fip-collect-g12a-sm1_ac214_v1-amlogic-dev_9.2.1811_21-20191204-161855

# Tools
BUILD_TOOLS_BINS := $(BUILD_TOP)/prebuilts/build-tools/$(HOST_PREBUILT_TAG)/bin
BUILD_TOOLS_CLANG_PATH ?= $(BUILD_TOP)/prebuilts/clang/host/$(HOST_PREBUILT_TAG)/clang-r498229b
BUILD_TOOLS_GCC_PATH ?= $(BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-gnu-9.3/bin/aarch64-buildroot-linux-gnu-
BUILD_TOOLS_EXTRA := $(BUILD_TOP)/device/amlogic/yukawa/build/tools

# Task to build U-Boot bootloader
BOOTLOADER_OUT := $(TARGET_OUT_INTERMEDIATES)/BOOTLOADER_OBJ
BOOTLOADER_FIRMWARE := $(BOOTLOADER_OUT)/$(AML_FIRMWARE)
BOOTLOADER_BIN := $(PRODUCT_OUT)/u-boot.bin

define make-bootloader-target
  PATH=$(BUILD_TOOLS_EXTRA):$$PATH \
    $(KERNEL_MAKE_CMD) \
    -C $(TARGET_BOOTLOADER_SOURCE) \
    O=$(BUILD_TOP)/$(1) \
    HOSTCC=$(BUILD_TOOLS_CLANG_PATH)/bin/clang \
    YACC=$(BUILD_TOOLS_BINS)/bison \
    LEX=$(BUILD_TOOLS_BINS)/flex \
    M4=$(BUILD_TOOLS_BINS)/m4 \
    CROSS_COMPILE=$(BUILD_TOOLS_GCC_PATH) $(2)
endef

define extract-bootloader-firmware
  $(GZIP) -dc $(BUILD_TOP)/device/amlogic/yukawa/bootloader/fip_packages/$(1).tar.gz > $(2)/$(1).tar
  tar -xf $(2)/$(1).tar -C $(2)
  rm -rf $(2)/$(1).tar
endef

define sign-bootloader-target
  @mkdir -p $(3)/tmp
  $(BUILD_TOP)/device/amlogic/yukawa/bootloader/scripts/generate-bins-new.sh $(2) $(3)/$(notdir $(1)) $(3)/tmp
  mv $(3)/tmp/$(notdir $(1)) $(1)
  rm -rf $(3)/tmp
endef

$(BOOTLOADER_OUT):
	@mkdir -p $(BOOTLOADER_OUT)

$(BOOTLOADER_FIRMWARE): $(GZIP)
	@echo "Extracting firmware for $(TARGET_DEV_BOARD)"
	$(hide) $(call extract-bootloader-firmware,$(AML_FIRMWARE),$(BOOTLOADER_OUT))

$(BOOTLOADER_BIN): $(BOOTLOADER_OUT) $(BOOTLOADER_FIRMWARE)
	@echo "Building U-Boot Image for $(TARGET_DEV_BOARD)"
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(BOOTLOADER_DEFCONFIG))
	$(hide) $(call make-bootloader-target,$(BOOTLOADER_OUT),$(notdir $@))
	$(hide) $(call sign-bootloader-target,$@,$(BOOTLOADER_FIRMWARE),$(BOOTLOADER_OUT))

.PHONY: u-boot.bin
u-boot.bin: $(BOOTLOADER_BIN)

$(INSTALLED_BOOTLOADER_MODULE): $(BOOTLOADER_BIN)
	$(transform-prebuilt-to-target)

.PHONY: bootloader
bootloader: $(INSTALLED_BOOTLOADER_MODULE)

droidcore: bootloader
$(call dist-for-goals, dist_files, $(INSTALLED_BOOTLOADER_MODULE))

endif # TARGET_NO_BOOTLOADER

endif # TARGET_DEVICE
