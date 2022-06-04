#
# Product-specific compile-time definitions.
#

BOARD_KERNEL_IMAGE_NAME := Image.lz4
BOARD_KERNEL_SEPARATED_DTBO := true
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_EXCLUDE_HOST_HEADERS := true
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa

# Please keep this list fixed: add new files in the end of the list
BOARD_INCLUDED_DTB := \
    amlogic/meson-g12a-sei510.dtb \
    amlogic/meson-sm1-sei610.dtb \
    amlogic/meson-sm1-khadas-vim3l.dtb \
    amlogic/meson-g12b-a311d-khadas-vim3.dtb \
    amlogic/meson-g12b-odroid-n2.dtb

BOARD_INCLUDED_DTBO := \
    amlogic/meson-g12a-sei510-android.dtb \
    amlogic/meson-sm1-sei610-android.dtb \
    amlogic/meson-sm1-khadas-vim3l-android.dtb \
    amlogic/meson-g12b-a311d-khadas-vim3-android.dtb \
    amlogic/meson-g12b-odroid-n2-android.dtb
