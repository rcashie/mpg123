LOCAL_PATH := $(call my-dir)
MY_SOURCE_PATH := $(LOCAL_PATH)/../../src/libmpg123

include $(CLEAR_VARS)

LOCAL_MODULE := _libmpg123

LOCAL_SRC_FILES := \
	$(MY_SOURCE_PATH)/compat.c \
	$(MY_SOURCE_PATH)/parse.c \
	$(MY_SOURCE_PATH)/frame.c \
	$(MY_SOURCE_PATH)/format.c \
	$(MY_SOURCE_PATH)/dct64.c \
	$(MY_SOURCE_PATH)/equalizer.c \
	$(MY_SOURCE_PATH)/id3.c \
	$(MY_SOURCE_PATH)/icy.c \
	$(MY_SOURCE_PATH)/icy2utf8.c \
	$(MY_SOURCE_PATH)/optimize.c \
	$(MY_SOURCE_PATH)/readers.c \
	$(MY_SOURCE_PATH)/tabinit.c \
	$(MY_SOURCE_PATH)/libmpg123.c \
	$(MY_SOURCE_PATH)/index.c \
	$(MY_SOURCE_PATH)/layer1.c \
	$(MY_SOURCE_PATH)/layer2.c \
	$(MY_SOURCE_PATH)/layer3.c \
	$(MY_SOURCE_PATH)/feature.c \
	$(MY_SOURCE_PATH)/synth.c \
	$(MY_SOURCE_PATH)/ntom.c \
	$(MY_SOURCE_PATH)/synth_8bit.c \
	$(MY_SOURCE_PATH)/stringbuf.c

LOCAL_C_INCLUDES := \
	$(MY_SOURCE_PATH) \
	$(LOCAL_PATH)

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)
LOCAL_CFLAGS += -DDYNAMIC_BUILD -fstack-protector
LOCAL_LDLIBS := -llog

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
	LOCAL_CFLAGS += -DOPT_MULTI -DOPT_NEON -DOPT_GENERIC -DREAL_IS_FLOAT -DASMALIGN_EXP
	LOCAL_SRC_FILES += \
		$(MY_SOURCE_PATH)/getcpuflags_arm.c \
		$(MY_SOURCE_PATH)/check_neon.S \
		$(MY_SOURCE_PATH)/dct36_neon.S \
		$(MY_SOURCE_PATH)/dct64_neon.S \
		$(MY_SOURCE_PATH)/synth_neon.S \
		$(MY_SOURCE_PATH)/synth_stereo_neon.S  
endif

ifeq ($(TARGET_ARCH_ABI), armeabi)
	LOCAL_CFLAGS += -DOPT_ARM -DREAL_IS_FIXED -DASMALIGN_EXP
	LOCAL_SRC_FILES += \
		$(MY_SOURCE_PATH)/synth_arm.S 
endif

ifeq ($(TARGET_ARCH_ABI), x86)
	LOCAL_CFLAGS += -DOPT_MULTI -DOPT_GENERIC -DOPT_MMX -DOPT_SSE -DREAL_IS_FLOAT -DASMALIGN_BYTE
	LOCAL_DISABLE_FATAL_LINKER_WARNINGS := true
	LOCAL_SRC_FILES += \
		$(MY_SOURCE_PATH)/getcpuflags.S \
		$(MY_SOURCE_PATH)/tabinit_mmx.S \
		$(MY_SOURCE_PATH)/synth_mmx.S \
		$(MY_SOURCE_PATH)/dct64_mmx.S \
		$(MY_SOURCE_PATH)/dct64_i386.c \
		$(MY_SOURCE_PATH)/synth_sse.S \
		$(MY_SOURCE_PATH)/dct64_sse.S \
		$(MY_SOURCE_PATH)/dct36_sse.S 
endif

include $(BUILD_SHARED_LIBRARY)