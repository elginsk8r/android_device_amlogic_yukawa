#
# Product-specific compile-time definitions.
#
BOARD_DTB_CFG := device/amlogic/yukawa/yukawa-dtb.cfg
BOARD_DTBO_CFG := device/amlogic/yukawa/yukawa-dtbo.cfg
BOARD_KERNEL_IMAGE_NAME := Image.lz4
BOARD_KERNEL_LZ4_COMPRESSION := true
BOARD_KERNEL_LZ4_COMP_FLAGS := -f -12 --favor-decSpeed
BOARD_KERNEL_SEPARATED_DTBO := true
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat device/amlogic/yukawa/modules.load))
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_DTB := \
    amlogic/meson-g12a-sei510.dtb \
    amlogic/meson-g12a-sei510-android.dtb \
    amlogic/meson-sm1-sei610.dtb \
    amlogic/meson-sm1-sei610-android.dtb \
    amlogic/meson-sm1-khadas-vim3l.dtb \
    amlogic/meson-sm1-khadas-vim3l-android.dtb \
    amlogic/meson-g12b-a311d-khadas-vim3.dtb \
    amlogic/meson-g12b-a311d-khadas-vim3-android.dtb \
    amlogic/meson-g12b-odroid-n2.dtb \
    amlogic/meson-g12b-odroid-n2-android.dtb
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa

# Reserved Space
ifneq ($(WITH_GMS),true)
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 368640000
endif
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 15360000
