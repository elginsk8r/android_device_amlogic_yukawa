TARGET_KERNEL_USE := 6.1

TARGET_PREBUILT_KERNEL_PATH ?= device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)
ifneq ($(wildcard $(TARGET_PREBUILT_KERNEL_PATH)/Image.lz4),)
TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_KERNEL_PATH)/Image.lz4
endif

# Modules
ifneq ($(TARGET_PREBUILT_KERNEL),)
TARGET_PREBUILT_KERNEL_MODULES := $(wildcard $(TARGET_PREBUILT_KERNEL_PATH)/*.ko)
endif

ifneq ($(TARGET_PREBUILT_KERNEL_MODULES),)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_uart.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/axg.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/axg-audio.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/axg-aoclk.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-cpu-dyndiv.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-regmap.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-phase.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/gxbb-aoclk.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-dualdiv.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-pll.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/clk-mpll.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-eeclk.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/sclk-div.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/g12a-aoclk.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/g12a.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-aoclk.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/vid-pll-div.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/gxbb.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-a1.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-axg-pmx.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-g12a.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-axg.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-gxl.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson-gxbb.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pinctrl-meson8-pmx.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/reset-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/reset-meson-audio-arb.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/system_heap.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/cma_heap.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-ee-pwrc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pwm-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pwm-regulator.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-rng.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_sm.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-secure-pwrc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_wdt.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-clk-measure.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-gx-pwrc-vpu.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_gxbb_wdt.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-ir.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_saradc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dwc3-meson-g12a.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/rtc-meson-vrtc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pcs_xpcs.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/stmmac.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/stmmac-platform.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dwmac-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dwmac-meson8b.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pci-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/irq-meson-gpio.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/mdio-mux.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/mdio-mux-meson-g12a.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-gxl.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/spi-meson-spicc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/spi-meson-spifc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-gx-mmc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pwrseq_simple.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/pwrseq_emmc.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/i2c-meson.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson-axg-mipi-pcie-analog.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson-axg-pcie.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson-g12a-usb2.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson-g12a-usb3-pcie.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson-gxl-usb2.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/phy-meson8b-usb2.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-aiu.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-fifo.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-frddr.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-sound-card.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-spdifout.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-pdm.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-tdm-formatter.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-tdmout.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-spdifin.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-card-utils.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-codec-glue.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-tdm-interface.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-tdmin.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-gx-sound-card.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-t9015.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-axg-toddr.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-g12a-toacodec.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/snd-soc-meson-g12a-tohdmitx.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/ao-cec.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/ao-cec-g12a.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/mali_kbase.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/display-connector.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/drm_display_helper.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/drm_dma_helper.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dw-hdmi.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dw-hdmi-cec.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dw-hdmi-i2s-audio.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/dw-hdmi-ahb-audio.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-canvas.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson-drm.ko \
  $(TARGET_PREBUILT_KERNEL_PATH)/meson_dw_hdmi.ko

endif
