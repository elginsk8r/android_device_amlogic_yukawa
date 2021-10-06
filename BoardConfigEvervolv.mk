#
# Product-specific compile-time definitions.
#

# Kernel
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa
KERNEL_VERSION := $(shell grep -s "^VERSION = " $(TARGET_KERNEL_SOURCE)/Makefile | awk '{ print $$3 }')
KERNEL_PATCHLEVEL := $(shell grep -s "^PATCHLEVEL = " $(TARGET_KERNEL_SOURCE)/Makefile | awk '{ print $$3 }')
TARGET_KERNEL_USE := $(KERNEL_VERSION).$(KERNEL_PATCHLEVEL)

# Kernel config
ifeq ($(TARGET_KERNEL_USE_GKI), true)
TARGET_KERNEL_CONFIG := gki_defconfig amlogic_gki.config
endif
TARGET_KERNEL_CONFIG ?= meson_defconfig

# Kernel device tree
BOARD_KERNEL_SEPARATED_DTBO ?= true
BOARD_DTB_CFG := device/amlogic/yukawa/yukawa-dtb.cfg
ifeq ($(BOARD_KERNEL_SEPARATED_DTBO), true)
BOARD_DTBO_CFG := device/amlogic/yukawa/yukawa-dtbo.cfg
endif

# Kernel image
BOARD_KERNEL_IMAGE_NAME ?= Image.lz4
ifeq ($(BOARD_KERNEL_IMAGE_NAME), Image.lz4)
BOARD_KERNEL_LZ4_COMPRESSION := true
BOARD_KERNEL_LZ4_COMP_FLAGS := -f -12 --favor-decSpeed
endif

# Kernel modules
ifeq ($(TARGET_KERNEL_USE_GKI), true)
BOARD_KERNEL_MODULES_LOAD := \
    device/amlogic/yukawa/modules.load-$(TARGET_KERNEL_USE) \
    device/amlogic/yukawa/modules.load.$(if $(TARGET_USE_PANFROST),panfrost,mali) \
    $(if $(TARGET_USES_NANOHUB_SENSORHAL),device/amlogic/yukawa/modules.load.nanohub,)
BOARD_KERNEL_MODULES_LOAD := $(strip $(shell cat $(BOARD_KERNEL_MODULES_LOAD)))
BOARD_RECOVERY_KERNEL_MODULES_LOAD := $(BOARD_KERNEL_MODULES_LOAD)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(BOARD_KERNEL_MODULES_LOAD)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(BOARD_VENDOR_KERNEL_MODULES_LOAD)
BOOT_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD)
RECOVERY_KERNEL_MODULES := $(BOARD_RECOVERY_KERNEL_MODULES_LOAD)
TARGET_KERNEL_EXT_MODULE_ROOT := kernel/google-modules
TARGET_KERNEL_EXT_MODULES := gpu
ifeq ($(TARGET_USES_NANOHUB_SENSORHAL), true)
TARGET_KERNEL_EXT_MODULES += nanohub
endif
endif

# Partitions
-include $(SRC_EVERVOLV_DIR)/build/target/board/BoardConfigReservedSize.mk
