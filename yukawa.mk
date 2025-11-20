# Inherit the full_base and device configurations
# Use 64-bit only since Mesa libraries are compiled for 64-bit only
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE := 6.12
endif

ifeq ($(TARGET_VIM3), true)
TARGET_DEV_BOARD := vim3
else ifeq ($(TARGET_VIM3L), true)
TARGET_DEV_BOARD := vim3l
else ifeq ($(TARGET_DEV_BOARD),)
TARGET_DEV_BOARD := vim3l
endif

$(call inherit-product, device/amlogic/yukawa/device.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=$(TARGET_DEV_BOARD)

BOARD_KERNEL_DTB := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)/dtbs

ifeq ($(TARGET_PREBUILT_DTB),)
LOCAL_DTB := $(BOARD_KERNEL_DTB)
else
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
endif

# Feature permissions
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/permissions/yukawa.xml:/system/etc/sysconfig/yukawa.xml


PRODUCT_SHIPPING_API_LEVEL := 36
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
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=$(PRODUCT_MANUFACTURER) \
    ro.soc.model=$(PRODUCT_DEVICE)
