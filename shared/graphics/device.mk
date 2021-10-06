#
# Copyright (C) 2014 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifeq ($(TARGET_USE_PANFROST),true)
TARGET_USE_MALI_DRIVER := panfrost
endif

ifeq ($(TARGET_USE_MALI_DRIVER),)
TARGET_USE_MALI_DRIVER := mali
endif

ifneq ($(filter $(TARGET_USE_MALI_DRIVER),mali panfrost),)
include device/amlogic/yukawa/shared/graphics/$(TARGET_USE_MALI_DRIVER)/device.mk
endif
