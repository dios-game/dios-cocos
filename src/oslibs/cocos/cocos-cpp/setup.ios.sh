#! /bin/bash

# 加载环境配置
if [ -f ../config.sh ]; then
	config_file=../config.sh;
elif [ -f ../../config.sh ]; then
	config_file=../../config.sh;
elif [ -f ../../../config.sh ]; then
	config_file=../../../config.sh;
elif [ -f ../../../../config.sh ]; then
	config_file=../../../../config.sh;
elif [ -f ../../../../../config.sh ]; then
	config_file=../../../../../config.sh;
fi
bash ${config_file}

# 加载DIOS_DEPENDENCIES
DIOS_DEPENDENCIES=$(cat var_dios_dependencies.txt)

# 解压
COCOS2DX_VERSION_NAME="cocos2d-x"
COCOS2DX_FOLDER="cocos2d-x"
: ${IPHONEOS_SDK:=`xcodebuild -showsdks | egrep "iphoneos.*" -o`}
: ${IPHONESIMULATOR_SDK:=`xcodebuild -showsdks | egrep "iphonesimulator.*" -o`}

# if [ ! -d ${COCOS2DX_FOLDER} ]; then
# 	tar xvf ${COCOS2DX_VERSION_NAME}.zip;
# 	mv ${COCOS2DX_VERSION_NAME} ${COCOS2DX_FOLDER};
# fi

# 补丁
rm -rf ${COCOS2DX_FOLDER}/extensions/spine
cp -rf patch/* ${COCOS2DX_FOLDER}/


# 编译

# 安装静态库
mkdir -p ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphoneos/;
mkdir -p ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphoneos/;
mkdir -p ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphonesimulator/;
mkdir -p ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphonesimulator/;

# compile cocos2dx
cd cocos2d-x/cocos2dx/proj.ios
xcodebuild -target cocos2dx -configuration Debug -sdk ${IPHONEOS_SDK};
xcodebuild -target cocos2dx -configuration Release -sdk ${IPHONEOS_SDK};
xcodebuild -target cocos2dx -configuration Debug -sdk ${IPHONESIMULATOR_SDK};
xcodebuild -target cocos2dx -configuration Release -sdk ${IPHONESIMULATOR_SDK};
cp build/Debug-iphoneos/libcocos2dx.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphoneos/;
cp build/Release-iphoneos/libcocos2dx.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphoneos/;
cp build/Debug-iphonesimulator/libcocos2dx.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphonesimulator/;
cp build/Release-iphonesimulator/libcocos2dx.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphonesimulator/;
cd ../../../

# compile CocosDenshion
cd cocos2d-x/CocosDenshion/proj.ios
xcodebuild -target CocosDenshion -configuration Debug -sdk ${IPHONEOS_SDK};
xcodebuild -target CocosDenshion -configuration Release -sdk ${IPHONEOS_SDK};
xcodebuild -target CocosDenshion -configuration Debug -sdk ${IPHONESIMULATOR_SDK};
xcodebuild -target CocosDenshion -configuration Release -sdk ${IPHONESIMULATOR_SDK};
cp build/Debug-iphoneos/libCocosDenshion.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphoneos/;
cp build/Release-iphoneos/libCocosDenshion.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphoneos/;
cp build/Debug-iphonesimulator/libCocosDenshion.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphonesimulator/;
cp build/Release-iphonesimulator/libCocosDenshion.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphonesimulator/;
cd ../../../

# compile extensions
cd cocos2d-x/extensions/proj.ios
xcodebuild -target extensions -configuration Debug -sdk ${IPHONEOS_SDK};
xcodebuild -target extensions -configuration Release -sdk ${IPHONEOS_SDK};
xcodebuild -target extensions -configuration Debug -sdk ${IPHONESIMULATOR_SDK};
xcodebuild -target extensions -configuration Release -sdk ${IPHONESIMULATOR_SDK};
cp build/Debug-iphoneos/libextensions.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphoneos/;
cp build/Release-iphoneos/libextensions.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphoneos/;
cp build/Debug-iphonesimulator/libextensions.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphonesimulator/;
cp build/Release-iphonesimulator/libextensions.a ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphonesimulator/;
cd ../../../

cd cocos2d-x;

cp -rf cocos2dx/platform/third_party/ios/libraries/* ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphoneos/;
cp -rf cocos2dx/platform/third_party/ios/libraries/* ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphoneos/;
cp -rf cocos2dx/platform/third_party/ios/libraries/* ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/debug-iphonesimulator/;
cp -rf cocos2dx/platform/third_party/ios/libraries/* ${DIOS_DEPENDENCIES}/lib/ios/libcocos2dx/release-iphonesimulator/;

chmod 777 ${DIOS_DEPENDENCIES}/inc
mkdir -p ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
# 安装头文件
cp -rf cocos2dx/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/include/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/kazmath/include/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/platform/ios/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/platform/ios/Simulation/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/platform/third_party/ios/curl* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf cocos2dx/platform/third_party/ios/webp/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;

cp -rf CocosDenshion/include/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;

cp -rf external/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf external/chipmunk/include/chipmunk/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;

cp -rf extensions/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf extensions/CCBReader/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf extensions/GUI/CCControlExtension/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf extensions/GUI/CCScrollView/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf extensions/network/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cp -rf extensions/LocalStorage/* ${DIOS_DEPENDENCIES}/inc/libcocos2dx/;
cd ..;

