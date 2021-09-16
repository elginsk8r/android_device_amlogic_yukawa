#
# Copyright (C) 2021 The Evervolv Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit device configuration
$(call inherit-product, device/amlogic/yukawa/yukawa32_sei510.mk)

PRODUCT_NAME := ev_yukawa32_sei510

$(call inherit-product, device/amlogic/yukawa/evervolv.mk)
