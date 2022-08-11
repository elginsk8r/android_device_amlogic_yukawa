#
# Product-specific compile-time definitions.
#

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := \
    hardware/evervolv/interfaces/compatibility_matrices/compatibility_matrix.evervolv.xml \
    hardware/lineage/interfaces/compatibility_matrices/compatibility_matrix.lineage.xml

# Kernel
BOARD_KERNEL_SEPARATED_DTBO ?= true
TARGET_KERNEL_CONFIG := meson_defconfig
TARGET_KERNEL_SOURCE := kernel/amlogic/yukawa
BOARD_KERNEL_IMAGE_NAME ?= Image.lz4

# Kernel compression
ifeq ($(BOARD_KERNEL_IMAGE_NAME), Image.lz4)
BOARD_KERNEL_LZ4_COMPRESSION := true
BOARD_KERNEL_LZ4_COMP_FLAGS := -f -12 --favor-decSpeed
endif

# Kernel device tree
AMLOGIC_DTB := \
    meson-g12a-sei510 \
    meson-sm1-sei610 \
    meson-sm1-khadas-vim3l \
    meson-g12b-a311d-khadas-vim3 \
    meson-g12b-odroid-n2 \
    meson-g12b-odroid-n2-plus
BOARD_DTB_CFG := device/amlogic/yukawa/yukawa-dtb.cfg
TARGET_KERNEL_DTB :=
$(foreach f,$(wildcard $(AMLOGIC_DTB)),\
       $(eval TARGET_KERNEL_DTB += amlogic/$(f).dtb))

# Kernel device tree overlay
ifeq ($(BOARD_KERNEL_SEPARATED_DTBO), true)
BOARD_DTBO_CFG := device/amlogic/yukawa/yukawa-dtbo.cfg
$(foreach f,$(wildcard $(AMLOGIC_DTB)),\
       $(eval TARGET_KERNEL_DTB += amlogic/$(f)-android.dtb))
endif

# Partitions
-include $(SRC_EVERVOLV_DIR)/build/target/board/BoardConfigReservedSize.mk
