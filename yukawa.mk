# Inherit the full_base and device configurations
ifeq ($(TARGET_64BIT_ONLY), true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
else
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif

TARGET_DEV_BOARD ?= sei610

ifneq ($(filter $(TARGET_DEV_BOARD),vim3),)
TARGET_AML_SOC_MODEL := A311D
else ifneq ($(filter $(TARGET_DEV_BOARD),vim3l),)
TARGET_AML_SOC_MODEL := S905D3
else ifneq ($(filter $(TARGET_DEV_BOARD),odroid-n2),)
TARGET_AML_SOC_MODEL := S922X
else ifneq ($(filter $(TARGET_DEV_BOARD),sei510),)
TARGET_AML_SOC_MODEL := S905X2
endif
TARGET_AML_SOC_MODEL ?= S905X3

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=Amlogic \
    ro.soc.model=$(TARGET_AML_SOC_MODEL)

ifneq ($(filter $(TARGET_DEV_BOARD),vim3 odroid-n2),)
$(call soong_config_set,yukawa_mali,gpu_type,gondul_ion)
endif

$(call inherit-product, $(LOCAL_PATH)/device.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=$(TARGET_DEV_BOARD)

TARGET_NO_KERNEL_OVERRIDE ?= true
ifneq ($(TARGET_NO_KERNEL_OVERRIDE), false)
$(call inherit-product, $(LOCAL_PATH)/device-kernel.mk)
endif

# Feature permissions
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/permissions/yukawa.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yukawa.xml

# Speaker EQ
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hal/audio/speaker_eq_sei610.fir:$(TARGET_COPY_OUT_VENDOR)/etc/speaker_eq_sei610.fir

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
PRODUCT_MODEL := Android Tablet on yukawa
else
PRODUCT_MODEL := ATV on yukawa
endif

PRODUCT_BRAND := Amlogic
PRODUCT_MANUFACTURER := Amlogic
PRODUCT_NAME := yukawa
PRODUCT_DEVICE := yukawa
