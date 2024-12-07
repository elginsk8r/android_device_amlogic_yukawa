# Inherit the full_base and device configurations
ifeq ($(TARGET_64BIT_ONLY), true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
else
  $(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
endif

ifndef TARGET_KERNEL_USE
TARGET_KERNEL_USE := 6.1
endif

ifeq ($(TARGET_VIM3), true)
TARGET_DEV_BOARD := vim3
else ifeq ($(TARGET_VIM3L), true)
TARGET_DEV_BOARD := vim3l
else ifeq ($(TARGET_DEV_BOARD),)
TARGET_DEV_BOARD := sei610
endif

ifneq ($(filter $(TARGET_DEV_BOARD),vim3),)
AUDIO_DEFAULT_OUTPUT := hdmi
else ifneq ($(filter $(TARGET_DEV_BOARD),vim3l),)
AUDIO_DEFAULT_OUTPUT := hdmi
endif

ifneq ($(filter $(TARGET_DEV_BOARD),vim3),)
TARGET_AML_SOC_MODEL := A311D
else ifneq ($(filter $(TARGET_DEV_BOARD),vim3l),)
TARGET_AML_SOC_MODEL := S905D3
else ifneq ($(filter $(TARGET_DEV_BOARD),sei610),)
TARGET_AML_SOC_MODEL := S905X3
else
TARGET_AML_SOC_MODEL := S905X2
endif

PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=Amlogic \
    ro.soc.model=$(TARGET_AML_SOC_MODEL)

$(call inherit-product, device/amlogic/yukawa/device.mk)

PRODUCT_PROPERTY_OVERRIDES += ro.product.device=$(TARGET_DEV_BOARD)

ifneq ($(filter $(TARGET_AML_SOC_MODEL),A311D),)
$(call soong_config_set,yukawa_mali,gpu_type,gondul_ion)
endif

BOARD_KERNEL_DTB := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)

ifeq ($(TARGET_PREBUILT_DTB),)
LOCAL_DTB := $(BOARD_KERNEL_DTB)
else
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
endif

# Feature permissions
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/permissions/yukawa.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yukawa.xml

# Speaker EQ
PRODUCT_COPY_FILES += \
    device/amlogic/yukawa/hal/audio/speaker_eq_sei610.fir:$(TARGET_COPY_OUT_VENDOR)/etc/speaker_eq_sei610.fir

# Hotword Mic Toggle Provider
ifneq ($(filter $(TARGET_DEV_BOARD),sei610),)
PRODUCT_PACKAGES += \
    YukawaHotwordMicToggleProvider
endif

PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

ifeq ($(TARGET_USE_TABLET_LAUNCHER), true)
PRODUCT_MODEL := Android Tablet on yukawa
else
PRODUCT_MODEL := ATV on yukawa
endif

PRODUCT_BRAND := Amlogic
PRODUCT_MANUFACTURER := Amlogic
PRODUCT_NAME := yukawa
PRODUCT_DEVICE := yukawa

MOD_DIR := device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)

#
# Put all the modules in the rootfs...
#
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(MOD_DIR)/*.ko)

ifneq ($(BOARD_VENDOR_KERNEL_MODULES),)

# serial
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/meson_uart.ko

# core clock providers
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/axg.ko \
  $(MOD_DIR)/axg-audio.ko \
  $(MOD_DIR)/axg-aoclk.ko \
  $(MOD_DIR)/clk-cpu-dyndiv.ko \
  $(MOD_DIR)/clk-regmap.ko \
  $(MOD_DIR)/clk-phase.ko \
  $(MOD_DIR)/gxbb-aoclk.ko \
  $(MOD_DIR)/clk-dualdiv.ko \
  $(MOD_DIR)/clk-pll.ko \
  $(MOD_DIR)/clk-mpll.ko \
  $(MOD_DIR)/meson-eeclk.ko \
  $(MOD_DIR)/sclk-div.ko \
  $(MOD_DIR)/g12a-aoclk.ko \
  $(MOD_DIR)/g12a.ko \
  $(MOD_DIR)/meson-aoclk.ko \
  $(MOD_DIR)/vid-pll-div.ko \
  $(MOD_DIR)/gxbb.ko

# pinctrl
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/pinctrl-meson-a1.ko \
  $(MOD_DIR)/pinctrl-meson-axg-pmx.ko \
  $(MOD_DIR)/pinctrl-meson-g12a.ko \
  $(MOD_DIR)/pinctrl-meson-axg.ko \
  $(MOD_DIR)/pinctrl-meson-gxl.ko \
  $(MOD_DIR)/pinctrl-meson.ko \
  $(MOD_DIR)/pinctrl-meson-gxbb.ko \
  $(MOD_DIR)/pinctrl-meson8-pmx.ko

# reset
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/reset-meson.ko \
  $(MOD_DIR)/reset-meson-audio-arb.ko

# misc.
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/system_heap.ko \
  $(MOD_DIR)/cma_heap.ko \
  $(MOD_DIR)/meson-ee-pwrc.ko \
  $(MOD_DIR)/pwm-meson.ko \
  $(MOD_DIR)/pwm-regulator.ko \
  $(MOD_DIR)/meson-rng.ko \
  $(MOD_DIR)/meson_sm.ko \
  $(MOD_DIR)/meson-secure-pwrc.ko \
  $(MOD_DIR)/meson_wdt.ko \
  $(MOD_DIR)/meson-clk-measure.ko \
  $(MOD_DIR)/meson-gx-pwrc-vpu.ko \
  $(MOD_DIR)/meson_gxbb_wdt.ko \
  $(MOD_DIR)/meson-ir.ko \
  $(MOD_DIR)/meson_saradc.ko \
  $(MOD_DIR)/dwc3-meson-g12a.ko \
  $(MOD_DIR)/rtc-meson-vrtc.ko \
  $(MOD_DIR)/pcs_xpcs.ko \
  $(MOD_DIR)/stmmac.ko \
  $(MOD_DIR)/stmmac-platform.ko \
  $(MOD_DIR)/dwmac-meson.ko \
  $(MOD_DIR)/dwmac-meson8b.ko \
  $(MOD_DIR)/pci-meson.ko \
  $(MOD_DIR)/irq-meson-gpio.ko \
  $(MOD_DIR)/mdio-mux.ko \
  $(MOD_DIR)/mdio-mux-meson-g12a.ko \
  $(MOD_DIR)/meson-gxl.ko \
  $(MOD_DIR)/spi-meson-spicc.ko \
  $(MOD_DIR)/spi-meson-spifc.ko

# SD/eMMC
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/meson-gx-mmc.ko \
  $(MOD_DIR)/pwrseq_simple.ko \
  $(MOD_DIR)/pwrseq_emmc.ko

# i2c
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/i2c-meson.ko

# Phy
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/phy-meson-axg-mipi-pcie-analog.ko \
  $(MOD_DIR)/phy-meson-axg-pcie.ko \
  $(MOD_DIR)/phy-meson-g12a-usb2.ko \
  $(MOD_DIR)/phy-meson-g12a-usb3-pcie.ko \
  $(MOD_DIR)/phy-meson-gxl-usb2.ko \
  $(MOD_DIR)/phy-meson8b-usb2.ko

# Audio
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/snd-soc-meson-aiu.ko \
  $(MOD_DIR)/snd-soc-meson-axg-fifo.ko \
  $(MOD_DIR)/snd-soc-meson-axg-frddr.ko \
  $(MOD_DIR)/snd-soc-meson-axg-sound-card.ko \
  $(MOD_DIR)/snd-soc-meson-axg-spdifout.ko \
  $(MOD_DIR)/snd-soc-meson-axg-pdm.ko \
  $(MOD_DIR)/snd-soc-meson-axg-tdm-formatter.ko \
  $(MOD_DIR)/snd-soc-meson-axg-tdmout.ko \
  $(MOD_DIR)/snd-soc-meson-axg-spdifin.ko \
  $(MOD_DIR)/snd-soc-meson-card-utils.ko \
  $(MOD_DIR)/snd-soc-meson-codec-glue.ko \
  $(MOD_DIR)/snd-soc-meson-axg-tdm-interface.ko \
  $(MOD_DIR)/snd-soc-meson-axg-tdmin.ko \
  $(MOD_DIR)/snd-soc-meson-gx-sound-card.ko \
  $(MOD_DIR)/snd-soc-meson-t9015.ko \
  $(MOD_DIR)/snd-soc-meson-axg-toddr.ko \
  $(MOD_DIR)/snd-soc-meson-g12a-toacodec.ko \
  $(MOD_DIR)/snd-soc-meson-g12a-tohdmitx.ko

# Video/GPU
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/ao-cec.ko \
  $(MOD_DIR)/ao-cec-g12a.ko \
  $(MOD_DIR)/mali_kbase.ko \
  $(MOD_DIR)/display-connector.ko \
  $(MOD_DIR)/drm_display_helper.ko \
  $(MOD_DIR)/drm_dma_helper.ko \
  $(MOD_DIR)/dw-hdmi.ko \
  $(MOD_DIR)/dw-hdmi-cec.ko \
  $(MOD_DIR)/dw-hdmi-i2s-audio.ko \
  $(MOD_DIR)/dw-hdmi-ahb-audio.ko \
  $(MOD_DIR)/meson-canvas.ko \
  $(MOD_DIR)/meson-drm.ko \
  $(MOD_DIR)/meson_dw_hdmi.ko

BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += $(BOARD_VENDOR_RAMDISK_KERNEL_MODULES)

endif
