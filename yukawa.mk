# Inherit the full_base and device configurations
ifeq ($(TARGET_64BIT_ONLY), true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
else
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif

TARGET_DEV_BOARD ?= vim3l

ifneq ($(filter $(TARGET_DEV_BOARD),vim3),)
GPU_TYPE := gondul_ion
endif
GPU_TYPE ?= dvalin_ion
$(call soong_config_set,yukawa_mali,gpu_type,$(GPU_TYPE))

$(call inherit-product, device/amlogic/yukawa/device.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=$(TARGET_DEV_BOARD)

BOARD_KERNEL_DTB := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)

ifeq ($(TARGET_PREBUILT_DTB),)
LOCAL_DTB := $(BOARD_KERNEL_DTB)
else
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
endif

# Feature permissions
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/permissions/yukawa.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yukawa.xml

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
# Enforce the Product interface
PRODUCT_PRODUCT_VNDK_VERSION := current

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
PRODUCT_MODEL := Android Tablet on yukawa
else
PRODUCT_MODEL := ATV on yukawa
endif

PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := KHADAS
PRODUCT_NAME := yukawa
PRODUCT_DEVICE := yukawa

# Set SOC information
SOC_MANUFACTURER := Amlogic
ifneq ($(filter $(TARGET_DEV_BOARD),vim3),)
SOC_MODEL := A311D
endif
SOC_MODEL ?= S905D3

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(SOC_MANUFACTURER) \
    ro.soc.model=$(SOC_MODEL)
