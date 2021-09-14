ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE=5.4
endif

$(call inherit-product, device/amlogic/yukawa/device-common.mk)

ifeq ($(TARGET_VIM3), true)
PRODUCT_BRAND := Khadas
PRODUCT_MANUFACTURER := Khadas
PRODUCT_PROPERTY_OVERRIDES += ro.product.device=vim3
AUDIO_DEFAULT_OUTPUT := hdmi
GPU_TYPE := gondul_ion
else ifeq ($(TARGET_VIM3L), true)
PRODUCT_BRAND := Khadas
PRODUCT_MANUFACTURER := Khadas
PRODUCT_PROPERTY_OVERRIDES += ro.product.device=vim3l
AUDIO_DEFAULT_OUTPUT := hdmi
else ifeq ($(TARGET_ODROIDN2), true)
PRODUCT_BRAND := Hardkernel
PRODUCT_MANUFACTURER := Hardkernel
PRODUCT_PROPERTY_OVERRIDES += ro.product.device=odroidn2
AUDIO_DEFAULT_OUTPUT := hdmi
GPU_TYPE := gondul_ion
else
PRODUCT_BRAND := SEI
PRODUCT_PROPERTY_OVERRIDES += ro.product.device=sei610
endif
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
