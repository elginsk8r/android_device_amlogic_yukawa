#
# Product-specific compile-time definitions.
#

COMMON_PATH := device/amlogic/yukawa-common

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_64_BIT_APPS := true

# Bootloader
TARGET_NO_BOOTLOADER := true

# Kernel
TARGET_NO_KERNEL := false
BOARD_KERNEL_CMDLINE += no_console_suspend console=ttyAML0,115200 earlycon printk.devkmsg=on
BOARD_KERNEL_CMDLINE += init=/init firmware_class.path=/vendor/firmware
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
BOARD_KERNEL_OFFSET      := 0x1080000
BOARD_KERNEL_TAGS_OFFSET := 0x1000000
BOARD_MKBOOTIMG_ARGS     := --kernel_offset $(BOARD_KERNEL_OFFSET)

# APEX
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Audio
BOARD_USES_GENERIC_AUDIO := false
BOARD_USES_ALSA_AUDIO := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(COMMON_PATH)/bluetooth

# Display
TARGET_USES_HWC2 := true

# HIDL
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest.xml
ifeq ($(TARGET_USE_AB_SLOT), true)
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/hal/bootctrl/bootctrl.xml
endif

ifneq ($(TARGET_KERNEL_USE), 4.19)
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/manifest_kernel5.xml
endif
DEVICE_MATRIX_FILE := $(COMMON_PATH)/compatibility_matrix.xml

ifneq ($(TARGET_SENSOR_MEZZANINE),)
DEVICE_MANIFEST_FILE += $(COMMON_PATH)/sensorhal/manifest.xml
endif

# Platform
TARGET_BOARD_PLATFORM := yukawa

# OpenCL
BOARD_INSTALL_OPENCL := true

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888

# SELinux
BOARD_SEPOLICY_DIRS += \
        $(COMMON_PATH)/sepolicy

# Treble
PRODUCT_FULL_TREBLE_OVERRIDE := true
BOARD_VNDK_VERSION := current

# Verified Boot
ifeq ($(TARGET_AVB_ENABLE), true)
BOARD_AVB_ENABLE := true
else
BOARD_AVB_ENABLE := false
endif

# Vulkan
BOARD_INSTALL_VULKAN := true

# Wifi
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
