#
# Product-specific compile-time definitions.
#
# The generic product target doesn't have any hardware-specific pieces.
# Primary Arch
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

# Secondary Arch
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_BOARD_PLATFORM := yukawa

# Vulkan
BOARD_INSTALL_VULKAN := true

# OpenCL
BOARD_INSTALL_OPENCL := true

# BT configs
BOARD_HAVE_BLUETOOTH := true

# generic wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_VNDK_VERSION := current

# AVB
ifeq ($(TARGET_AVB_ENABLE), true)
BOARD_AVB_ENABLE := true
else
BOARD_AVB_ENABLE := false
endif

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false

ifeq ($(TARGET_USE_AB_SLOT), true)
BOARD_USES_RECOVERY_AS_BOOT := true
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor \
    vbmeta
endif

BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_DTBOIMG_PARTITION_SIZE := 8388608 # 8 MiB
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := $(TARGET_RO_FILE_SYSTEM_TYPE)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := $(TARGET_RO_FILE_SYSTEM_TYPE)
TARGET_USERIMAGES_SPARSE_EROFS_DISABLED ?= true
ifneq ($(TARGET_USE_AB_SLOT), true)
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
endif
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_COPY_OUT_VENDOR := vendor

# Super partition
TARGET_USE_DYNAMIC_PARTITIONS := true
BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
BOARD_SUPER_PARTITION_GROUPS := db_dynamic_partitions
BOARD_DB_DYNAMIC_PARTITIONS_PARTITION_LIST := system vendor
ifeq ($(TARGET_USE_AB_SLOT), true)
BOARD_SUPER_PARTITION_SIZE := 4831838208
else
BOARD_SUPER_PARTITION_SIZE := 2415919104
endif
BOARD_DB_DYNAMIC_PARTITIONS_SIZE := 2411724800  # Reserve 4M for DAP metadata
BOARD_SUPER_PARTITION_METADATA_DEVICE := super
# BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true


# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
ifeq ($(TARGET_AVB_ENABLE), true)
ifeq ($(TARGET_USE_AB_SLOT), true)
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.yukawa.avb.ab
else
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.recovery.yukawa.avb
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
endif
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 2
else
ifeq ($(TARGET_USE_AB_SLOT), true)
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.yukawa
else
TARGET_RECOVERY_FSTAB := device/amlogic/yukawa/fstab.recovery.yukawa
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
endif
endif

BOARD_RAMDISK_USE_LZ4 := true
BOARD_KERNEL_OFFSET      := 0x1080000
BOARD_KERNEL_TAGS_OFFSET := 0x1000000
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_MKBOOTIMG_ARGS     := --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_BOOT_HEADER_VERSION := 2
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
ifeq ($(wildcard vendor/*/build/tasks/kernel.mk),)
include device/amlogic/yukawa/BoardConfigKernel.mk
endif

BOARD_KERNEL_CMDLINE += no_console_suspend console=ttyAML0,115200 earlycon
BOARD_KERNEL_CMDLINE += printk.devkmsg=on
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/ffe07000.mmc 
BOARD_KERNEL_CMDLINE += init=/init
BOARD_KERNEL_CMDLINE += firmware_class.path=/vendor/firmware
BOARD_KERNEL_CMDLINE += androidboot.hardware=yukawa
ifneq ($(TARGET_SELINUX_ENFORCE), true)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
endif
ifeq ($(TARGET_BUILTIN_EDID), true)
BOARD_KERNEL_CMDLINE += drm.edid_firmware=edid/1920x1080.bin
endif
ifneq ($(TARGET_SENSOR_MEZZANINE),)
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_$(TARGET_SENSOR_MEZZANINE)
endif
ifneq ($(TARGET_MEM_SIZE),)
BOARD_KERNEL_CMDLINE += mem=$(TARGET_MEM_SIZE)
endif

ifneq ($(TARGET_KERNEL_CFG),)
BOARD_KERNEL_CMDLINE += $(TARGET_KERNEL_CFG)
endif

USE_E2FSPROGS := true

BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true
TARGET_USES_MKE2FS := true
TARGET_USES_HWC2 := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/amlogic/yukawa/bluetooth

BOARD_SEPOLICY_DIRS += \
        device/amlogic/yukawa/sepolicy

DEVICE_MANIFEST_FILE += device/amlogic/yukawa/manifest.xml

ifneq ($(TARGET_KERNEL_USE), 4.19)
DEVICE_MANIFEST_FILE += device/amlogic/yukawa/manifest_kernel5.xml
endif
DEVICE_MATRIX_FILE := device/amlogic/yukawa/compatibility_matrix.xml

ifneq ($(TARGET_SENSOR_MEZZANINE),)
DEVICE_MANIFEST_FILE += device/amlogic/yukawa/sensorhal/manifest.xml
endif

# Generate an APEX image for experiment b/119800099.
DEXPREOPT_GENERATE_APEX_IMAGE := true

ifneq ($(filter ev_yukawa%, $(TARGET_PRODUCT)),)
include device/amlogic/yukawa/BoardConfigEvervolv.mk
endif
