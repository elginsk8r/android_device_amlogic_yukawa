ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE=4.19
endif

BOARD_KERNEL_PATH := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)
ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := $(BOARD_KERNEL_PATH)/Image.lz4
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES +=  $(LOCAL_KERNEL):kernel

ifeq ($(TARGET_PREBUILT_DTB),)
LOCAL_DTB := $(BOARD_KERNEL_PATH)
else
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
endif

#
# Put all the modules in the rootfs...
#
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(BOARD_KERNEL_PATH)/*.ko)
ifneq ($(BOARD_VENDOR_KERNEL_MODULES),)

#
# ...and only a subset on the ramdisk.
#
# core clock providers
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(BOARD_KERNEL_PATH)/axg.ko \
  $(BOARD_KERNEL_PATH)/axg-audio.ko \
  $(BOARD_KERNEL_PATH)/axg-aoclk.ko \
  $(BOARD_KERNEL_PATH)/clk-cpu-dyndiv.ko \
  $(BOARD_KERNEL_PATH)/clk-regmap.ko \
  $(BOARD_KERNEL_PATH)/clk-phase.ko \
  $(BOARD_KERNEL_PATH)/gxbb-aoclk.ko \
  $(BOARD_KERNEL_PATH)/clk-dualdiv.ko \
  $(BOARD_KERNEL_PATH)/clk-pll.ko \
  $(BOARD_KERNEL_PATH)/clk-mpll.ko \
  $(BOARD_KERNEL_PATH)/meson-eeclk.ko \
  $(BOARD_KERNEL_PATH)/sclk-div.ko \
  $(BOARD_KERNEL_PATH)/g12a-aoclk.ko \
  $(BOARD_KERNEL_PATH)/g12a.ko \
  $(BOARD_KERNEL_PATH)/meson-aoclk.ko \
  $(BOARD_KERNEL_PATH)/vid-pll-div.ko \
  $(BOARD_KERNEL_PATH)/gxbb.ko

# pinctrl
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-a1.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-axg-pmx.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-g12a.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-axg.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-gxl.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-gxbb.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson8-pmx.ko

# reset
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(BOARD_KERNEL_PATH)/reset-meson.ko \
  $(BOARD_KERNEL_PATH)/reset-meson-audio-arb.ko

# misc.
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(BOARD_KERNEL_PATH)/meson-ee-pwrc.ko \
  $(BOARD_KERNEL_PATH)/pwm-meson.ko \
  $(BOARD_KERNEL_PATH)/pwm-regulator.ko

# SD/eMMC
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(BOARD_KERNEL_PATH)/meson-gx-mmc.ko \
  $(BOARD_KERNEL_PATH)/pwrseq_simple.ko \
  $(BOARD_KERNEL_PATH)/pwrseq_emmc.ko

#
# ...and only a subset of those to explicitly load, mainly to get
# SD/eMMC up so the main rootfs can be loaded
#
# NOTE: this list is G12/SM1 specific
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += \
  $(BOARD_KERNEL_PATH)/g12a_aoclk.ko \
  $(BOARD_KERNEL_PATH)/g12a.ko \
  $(BOARD_KERNEL_PATH)/meson-eeclk.ko \
  $(BOARD_KERNEL_PATH)/pinctrl-meson-g12a.ko \
  $(BOARD_KERNEL_PATH)/reset-meson.ko \
  $(BOARD_KERNEL_PATH)/pwm-meson.ko \
  $(BOARD_KERNEL_PATH)/pwrseq_simple.ko \
  $(BOARD_KERNEL_PATH)/pwrseq_emmc.ko \
  $(BOARD_KERNEL_PATH)/meson-gx-mmc.ko

#
# serial console (may be built-in, so check if present)
#
UART_MOD=$(BOARD_KERNEL_PATH)/meson_uart.ko
ifneq (,$(wildcard $(UART_MOD)))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(UART_MOD)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += $(UART_MOD)
endif

endif
