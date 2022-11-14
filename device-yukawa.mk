ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE := 5.10
endif

ifeq ($(TARGET_VIM3), true)
TARGET_DEV_BOARD := vim3
else ifeq ($(TARGET_VIM3L), true)
TARGET_DEV_BOARD := vim3l
else ifeq ($(TARGET_DEV_BOARD),)
TARGET_DEV_BOARD := sei610
endif

ifneq ($(filter $(TARGET_DEV_BOARD),vim3 vim3l),)
PRODUCT_BRAND := Khadas
PRODUCT_MANUFACTURER := Khadas
else
PRODUCT_BRAND := SEI
PRODUCT_MANUFACTURER := SEI
endif

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
PRODUCT_MODEL := AOSP on $(TARGET_DEV_BOARD)
else
PRODUCT_MODEL := ATV on $(TARGET_DEV_BOARD)
endif

ifneq ($(filter $(TARGET_DEV_BOARD), vim3),)
AUDIO_DEFAULT_OUTPUT := hdmi
GPU_TYPE := gondul_ion
else ifneq ($(filter $(TARGET_DEV_BOARD),vim3l),)
AUDIO_DEFAULT_OUTPUT := hdmi
endif

$(call inherit-product, device/amlogic/yukawa/device-common.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=$(TARGET_DEV_BOARD)
GPU_TYPE ?= dvalin_ion

BOARD_KERNEL_DTB := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)

ifeq ($(TARGET_PREBUILT_DTB),)
LOCAL_DTB := $(BOARD_KERNEL_DTB)
else
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
endif

# Feature permissions
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/permissions/yukawa.xml:/system/etc/sysconfig/yukawa.xml

# Speaker EQ
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/hal/audio/speaker_eq_sei610.fir:$(TARGET_COPY_OUT_VENDOR)/etc/speaker_eq_sei610.fir

# Hotword Mic Toggle Provider
ifneq ($(filter $(TARGET_DEV_BOARD),sei610),)
PRODUCT_PACKAGES += \
    YukawaHotwordMicToggleProvider
endif

# Product API
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
