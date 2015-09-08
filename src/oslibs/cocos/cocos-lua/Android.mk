LOCAL_PATH := $(call my-dir)

################## Build ProtoBuf ################
include $(CLEAR_VARS)

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../../cocos-src/cocos/2d \
                    $(LOCAL_PATH)/../../cocos-src/cocos/3d \
                    $(LOCAL_PATH)/../../cocos-src/cocos/network \
                    $(LOCAL_PATH)/../../cocos-src/cocos/editor-support/cocosbuilder \
                    $(LOCAL_PATH)/../../cocos-src/cocos/editor-support/cocostudio \
                    $(LOCAL_PATH)/../../cocos-src/cocos/editor-support/cocostudio/ActionTimeline \
                    $(LOCAL_PATH)/../../cocos-src/cocos/editor-support/spine \
                    $(LOCAL_PATH)/../../cocos-src/cocos/ui \
                    $(LOCAL_PATH)/../../cocos-src/cocos \

$(call import-module,scripting/lua-bindings/proj.android)
$(call import-module,tools/simulator/libsimulator/proj.android)