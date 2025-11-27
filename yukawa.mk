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

ifeq ($(TARGET_DEV_BOARD), vim3l)
# Set lowram options
PRODUCT_VENDOR_PROPERTIES += \
	dalvik.vm.heapstartsize=1m \
	dalvik.vm.heapgrowthlimit=128m \
	dalvik.vm.heapsize=256m \
	dalvik.vm.heaptargetutilization=0.90 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=2m \
	dalvik.vm.usejit=true \
	ro.lmk.medium=700 \
	ro.lmk.critical=800 \
	ro.lmk.critical_upgrade=true \
	ro.lmk.upgrade_pressure=40 \
	ro.lmk.downgrade_pressure=60 \
	ro.lmk.kill_heaviest_task=false \
	ro.lmk.use_minfree_levels=true \
	pm.dexopt.downgrade_after_inactive_days=10 \
	pm.dexopt.shared=quicken

PRODUCT_VENDOR_PROPERTIES += \
	ro.config.low_ram=true \
	ro.config.avoid_gfx_accel=true \
	config.disable_consumerir=true

# Additional memory optimizations
PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.force_highendgfx=false \
	ro.hwui.texture_cache_size=24 \
	ro.hwui.layer_cache_size=16 \
	ro.hwui.path_cache_size=4 \
	ro.hwui.texture_cache_flushrate=0.4 \
	ro.hwui.shape_cache_size=1 \
	ro.hwui.gradient_cache_size=0.5 \
	ro.hwui.drop_shadow_cache_size=2 \
	ro.config.max_starting_bg=4 \
	ro.vendor.qti.sys.fw.bservice_enable=false \
	ro.statsd.enable=false

# Disable non-essential services for low RAM
PRODUCT_PACKAGES += \
	RemoveApps

# Remove heavy non-essential packages
PRODUCT_PACKAGES_EXCLUDE := \
	LiveTv \
	TvSampleLeanbackLauncher \
	Music
endif

# Speed profile services and wifi-service to reduce RAM and storage.
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# flash script
PRODUCT_COPY_FILES += \
	device/amlogic/yukawa/flash.sh:$(TARGET_OUT)/flash.sh
