#
# Product-specific compile-time definitions.
#
TARGET_NO_KERNEL_OVERRIDE := true

BOARD_KERNEL_IMAGE_NAME := Image.lz4
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa
