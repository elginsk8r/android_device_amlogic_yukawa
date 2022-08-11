#
# Product-specific compile-time definitions.
#

# Kernel
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa

# Kernel device tree
BOARD_KERNEL_SEPARATED_DTBO ?= true
BOARD_DTB_CFG := device/amlogic/yukawa/yukawa-dtb.cfg
ifeq ($(BOARD_KERNEL_SEPARATED_DTBO), true)
BOARD_DTBO_CFG := device/amlogic/yukawa/yukawa-dtbo.cfg
endif

# Kernel image
BOARD_KERNEL_IMAGE_NAME ?= Image.lz4
ifeq ($(BOARD_KERNEL_IMAGE_NAME), Image.lz4)
BOARD_KERNEL_LZ4_COMPRESSION := true
BOARD_KERNEL_LZ4_COMP_FLAGS := -f -12 --favor-decSpeed
endif

# Partitions
-include $(SRC_EVERVOLV_DIR)/build/target/board/BoardConfigReservedSize.mk
