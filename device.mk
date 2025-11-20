PRODUCT_SOONG_NAMESPACES += device/amlogic/yukawa
PRODUCT_SOONG_NAMESPACES += hardware/amlogic/yukawa
# Disable debug binaries for an unbundled ART build.
# From //build/make/target/product/go_defaults_common.mk
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
# Strip the local variable table and the local variable type table to reduce
    # the size of the system image. This has no bearing on stack traces, but will
    # leave less information available via JDWP.
    # From //build/make/target/product/go_defaults_common.mk
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Check vendor package version
include device/amlogic/yukawa/vendor-package-ver.mk
ifneq (,$(wildcard $(YUKAWA_VENDOR_PATH)/bt-wifi-firmware))
  ifneq (,$(wildcard $(YUKAWA_VENDOR_PATH)/bt-wifi-firmware/$(EXPECTED_YUKAWA_VENDOR_VERSION)/version.mk))
    # Unfortunately inherit-product doesn't export build variables from the
    # called make file to the caller, so we have to include it directly here.
    include $(YUKAWA_VENDOR_PATH)/bt-wifi-firmware/$(EXPECTED_YUKAWA_VENDOR_VERSION)/version.mk
    ifneq ($(TARGET_YUKAWA_VENDOR_VERSION), $(EXPECTED_YUKAWA_VENDOR_VERSION))
      $(warning TARGET_YUKAWA_VENDOR_VERSION ($(TARGET_YUKAWA_VENDOR_VERSION)) does not match. Build may be invalid.)
      $(warning Please download and extract the new binaries by running the following script:)
      $(warning    ./device/amlogic/yukawa/fetch-vendor-package.sh )
    endif
  else
      $(warning TARGET_YUKAWA_VENDOR_VERSION undefined.)
      $(warning The vendor package version is incorrect. Please update the yukawa source tree.)
  endif
else
  $(warning Missing yukawa vendor package!)
  $(warning Please download and extract the vendor binaries by running the following script:)
  $(warning    ./device/amlogic/yukawa/fetch-vendor-package.sh )
endif

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)/yukawa-Image.lz4
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES +=  $(LOCAL_KERNEL):kernel

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Enable Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/android_t_baseline.mk)
PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# Use generic ramdisk (init_boot)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# pKVM
$(call inherit-product-if-exists, packages/modules/Virtualization/apex/product_packages.mk)

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Set Vendor SPL to match platform
VENDOR_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)
# Set boot SPL
BOOT_SECURITY_PATCH = $(PLATFORM_SECURITY_PATCH)

OVERRIDE_PRODUCT_COMPRESSED_APEX := false

DEVICE_PACKAGE_OVERLAYS := device/amlogic/yukawa/overlay
ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
# Setup tablet build
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
# Packages to invoke RC pairing
PRODUCT_CHARACTERISTICS := tablet
else
# Setup TV Build
USE_OEM_TV_APP := true
$(call inherit-product, device/google/atv/products/atv_base.mk)
PRODUCT_CHARACTERISTICS := tv
PRODUCT_IS_ATV := true
endif

# inherit binaries from the vendor package
$(call inherit-product-if-exists, $(YUKAWA_VENDOR_PATH)/bt-wifi-firmware/$(EXPECTED_YUKAWA_VENDOR_VERSION)/vendor.mk)
$(call inherit-product-if-exists, $(YUKAWA_VENDOR_PATH)/video_firmware/$(EXPECTED_YUKAWA_VENDOR_VERSION)/vendor.mk)
$(call inherit-product-if-exists, $(YUKAWA_VENDOR_PATH)/gpu/$(EXPECTED_YUKAWA_VENDOR_VERSION)/vendor.mk)
$(call inherit-product-if-exists, $(YUKAWA_VENDOR_PATH)/bootloader/$(EXPECTED_YUKAWA_VENDOR_VERSION)/vendor.mk)

# A/B support
PRODUCT_PACKAGES += \
    otapreopt_script \
    cppreopts.sh \
    update_engine \
    update_engine_sideload \
    update_verifier \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# The following modules are included in debuggable builds only.
PRODUCT_PACKAGES_DEBUG += \
    bootctl \
    update_engine_client \
    SystemUpdaterSample

# Userdata Checkpointing OTA GC
PRODUCT_PACKAGES += \
	checkpoint_gc

# Boot control
PRODUCT_PACKAGES += \
    com.android.hardware.boot \
    android.hardware.boot-service.default_recovery

# Dynamic partitions
PRODUCT_BUILD_SUPER_PARTITION := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_USE_DYNAMIC_PARTITION_SIZE := true

PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.1 \
	android.hardware.fastboot@1.1-impl-mock \
	fastbootd

#copy xml file to tell PackageManager that the system supports Verified Boot
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# fstab
PRODUCT_PACKAGES += \
	fstab.yukawa.mmc.avb \
	fstab.yukawa.mmc.avb.vendor_ramdisk

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.yukawa.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.yukawa.rc \
    $(LOCAL_PATH)/init.yukawa.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.yukawa.usb.rc \
    $(LOCAL_PATH)/init.recovery.hardware.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.yukawa.rc \
    $(LOCAL_PATH)/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
# Use Launcher3QuickStep
PRODUCT_PACKAGES += Launcher3QuickStep
else
# TV Specific Packages
PRODUCT_PACKAGES += \
    LiveTv \
    google-tv-pairing-protocol \
    LeanbackSampleApp \
    tv_input.default \
    com.android.media.tv.remoteprovider \
    InputDevices

# Fallback IME and Home apps
PRODUCT_PACKAGES += \
    LeanbackIME \
    TvSampleLeanbackLauncher

ifeq ($(TARGET_PRODUCT), yukawa_gms)
PRODUCT_PACKAGES += \
    TvProvision \
    TVLauncherNoGms \
    TVRecommendationsNoGms
endif
endif

# CAS AIDL HAL
PRODUCT_PACKAGES += \
    android.hardware.cas-service.example

# DRM Service
PRODUCT_PACKAGES += \
    android.hardware.drm-service.widevine \
    android.hardware.drm@latest-service.clearkey

# CEC on ATV only
ifeq ($(PRODUCT_IS_ATV), true)
PRODUCT_PACKAGES += \
    android.hardware.tv.cec@1.0-impl \
    android.hardware.tv.cec@1.0-service \
    hdmi_cec.yukawa

PRODUCT_PROPERTY_OVERRIDES += \
    ro.hdmi.cec_device_types=playback_device

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.hdmi.cec.xml:system/etc/permissions/android.hardware.hdmi.cec.xml
endif

# HDMI display
PRODUCT_PROPERTY_OVERRIDES += ro.hdmi.device_type=4 \
    persist.sys.hdmi.keep_awake=false

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/input/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl

# Thermal
PRODUCT_PACKAGES += \
	com.android.hardware.thermal.rs.generic.v3

# PowerHAL
PRODUCT_PACKAGES += com.android.hardware.power

# Health: Install default binderized implementation to vendor.
PRODUCT_PACKAGES += \
	com.google.cf.health \
	android.hardware.health-service.cuttlefish_recovery

# Health Storage
PRODUCT_PACKAGES += \
    com.google.cf.health.storage

#
# Authsecret AIDL HAL
#
PRODUCT_PACKAGES += \
    com.android.hardware.authsecret

# KeyMint.  Note that this is an insecure implementation that should not be
# used on a production device as it does not comply with [9.11/H-0-2] of the
# Android CDD ("Handheld device implementations MUST back up the keystore
# implementation with an isolated execution environment").
PRODUCT_PACKAGES += \
    com.android.hardware.keymint.rust_nonsecure
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml

# Gatekeeper.  Note that this is an insecure implementation that should not be
# used on a production device as it does not comply with [9.11/H-0-4] of the
# Android CDD ("Handheld device implementations MUST perform the lock screen
# authentication in the isolated execution environment ").
PRODUCT_PACKAGES += \
    com.android.hardware.gatekeeper.nonsecure

# USB
BOARD_VENDOR_SEPOLICY_DIRS += hardware/amlogic/yukawa/usb/aidl/sepolicy

PRODUCT_PACKAGES += \
    com.android.hardware.usb.generic

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_COPY_FILES +=  \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.cts.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.cts.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml


# Include Virtualization APEX
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)

# ro.frp.pst points to a partition that contains factory reset protection information.
PRODUCT_VENDOR_PROPERTIES += ro.frp.pst=/dev/block/by-name/frp

# graphics
$(call inherit-product, device/amlogic/yukawa/hal/graphics/device_vendor.mk)

# Connectivity
$(call inherit-product, device/amlogic/yukawa/hal/connectivity/device_vendor.mk)

# Sensor HAL
$(call inherit-product, device/amlogic/yukawa/hal/sensorhal/device_vendor.mk)

# Camera
$(call inherit-product, device/amlogic/yukawa/hal/camera/device_vendor.mk)

# Audio 
$(call inherit-product, device/amlogic/yukawa/hal/audio/device_vendor.mk)

# Media 
$(call inherit-product, device/amlogic/yukawa/hal/media/device_vendor.mk)
