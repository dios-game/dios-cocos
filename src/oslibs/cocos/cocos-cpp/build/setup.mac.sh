#! /bin/bash

ocd=$(cd $(dirname $BASH_SOURCE); pwd)
cd ..
# ##### 提示：读取配置文件 #####
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
elif [ -f ../../../../../../config.sh ]; then
	config_file=../../../../../../config.sh;
elif [ -f ../../../../../../../config.sh ]; then
	config_file=../../../../../../../config.sh;
fi
source ${config_file}

# ##### 提示：变量配置 #####
cocos2dx_xcodeproj=${DIOS_COCOS_PATH}/build/cocos2d_libs.xcodeproj
DIOS_PREBUILT=$(cd $(dirname $BASH_SOURCE); pwd)/prebuilt
DIOS_PLATFORM=mac

# ##### 提示：打补丁 #####
# rmdir -p ${DIOS_COCOS_PATH}/extensions/spine
# cp -rf patch/* ${DIOS_COCOS_PATH}

# ##### 提示：编译 Cocos #####
cd ${DIOS_COCOS_PATH}

xcodebuild -project ${cocos2dx_xcodeproj} -target "libcocos2d Mac" -configuration Debug
xcodebuild -project ${cocos2dx_xcodeproj} -target "libcocos2d Mac" -configuration Release

# ##### 提示：安装 Cocos #####
mkdir -p ${DIOS_PREBUILT}/lib/${DIOS_PLATFORM}/debug
mkdir -p ${DIOS_PREBUILT}/lib/${DIOS_PLATFORM}/release
cp -rf build/build/Debug/"libcocos2d Mac.a" ${DIOS_PREBUILT}/lib/${DIOS_PLATFORM}/debug/libcocos2d.a
cp -rf build/build/Release/"libcocos2d Mac.a" ${DIOS_PREBUILT}/lib/${DIOS_PLATFORM}/release/libcocos2d.a

mkdir -p ${DIOS_PREBUILT}/inc/cocos
# cocos
cd cocos
find ./ -type f | grep -E "\.h$" | cpio -dump ${DIOS_PREBUILT}/inc/cocos/
find ./ -type f | grep -E "\.inl$" | cpio -dump ${DIOS_PREBUILT}/inc/cocos/
find ./ -type f -name "*.inl" -exec cp -rf {} ${DIOS_PREBUILT}/inc/cocos/ \;
cp -r editor-support/* ${DIOS_PREBUILT}/inc/cocos/

# extensions
cd ..
cp -r extensions ${DIOS_PREBUILT}/inc/cocos/
cd extensions
find ./ -type f | grep -E "\.h$" | cpio -dump ${DIOS_PREBUILT}/inc/cocos/

# external
cd ../external
find ./ -type f | grep -E "\.h$" | cpio -dump ${DIOS_PREBUILT}/inc/cocos/
find ./ -type d -name "include" -exec cp -rf {}/ ${DIOS_PREBUILT}/inc/cocos/ \;
find ./ -type d -name "mac" -exec cp -rf {}/ ${DIOS_PREBUILT}/inc/cocos/ \;
cp -r chipmunk/include/chipmunk ${DIOS_PREBUILT}/inc/cocos/

cd ${ocd}
cd ..

if [ ! -d proj.mac ]; then
	mkdir proj.mac;
fi
cd proj.mac

function check()
{
	if [[ ! $1 == 0 ]]; then
		echo "\033[31msetup failed\033[0m"
		exit
	fi
}

echo "#####提示：开始构建#####"
cmake -GXcode -DDIOS_CMAKE_PLATFORM=MAC -DCMAKE_TOOLCHAIN_FILE=${DIOS_CMAKE}/toolchain/mac/mac.toolchain.cmake ..
check $?
cmake -GXcode -DDIOS_CMAKE_PLATFORM=MAC -DCMAKE_TOOLCHAIN_FILE=${DIOS_CMAKE}/toolchain/mac/mac.toolchain.cmake ..
check $?
echo "#####提示：构建结束#####"

echo "#####提示：开始编译#####"
xcodebuild -target ALL_BUILD -configuration Debug
xcodebuild -target ALL_BUILD -configuration Release
check $?
echo "#####提示：编译结束#####"

echo "#####提示：开始安装#####"
cmake -DBUILD_TYPE="Debug" -P cmake_install.cmake
cmake -DBUILD_TYPE="Release" -P cmake_install.cmake
check $?
echo "#####提示：安装结束#####"

cmake -P dios_cmake_compile_succeeded.cmake
cmake -P dios_cmake_install_succeeded.cmake
