#
# Product-specific compile-time definitions.
#

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    hardware/evervolv/interfaces/compatibility_matrices/compatibility_matrix.evervolv.xml \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml

# Kernel
BOARD_DTB_CFG := device/amlogic/yukawa/yukawa-dtb.cfg
BOARD_DTBO_CFG := device/amlogic/yukawa/yukawa-dtbo.cfg
BOARD_KERNEL_IMAGE_NAME := Image.lz4
BOARD_KERNEL_LZ4_COMPRESSION := true
BOARD_KERNEL_LZ4_COMP_FLAGS := -f -12 --favor-decSpeed
BOARD_KERNEL_SEPARATED_DTBO := true
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
