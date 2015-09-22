
SET(DIOS_CONFIG_TEMPLATE prebuit)
SET(DIOS_CONFIG_MODULE cocos-js) 


# 
# 初始化工程, 配置基本变量;
# 
MACRO(dios_config_module_init MODULE)
	
	#
	# 1. 基本属性配置;
	#
	SET(DIOS_MODULE_${MODULE}_ANDROID_NAME "cocos2d_js_static")
	SET(DIOS_MODULE_${MODULE}_APP_NAME ${MODULE}) 

	# 模块类型变量; app(APPLICATION); lib(STATIC, SHARED);
	SET(DIOS_MODULE_${MODULE}_TYPE PREBUILT) # default  pc mac
	SET(DIOS_MODULE_${MODULE}_ANDROID_TYPE STATIC)
	SET(DIOS_MODULE_${MODULE}_IOS_TYPE STATIC) # can only build static library on ios

	# 模块版本;
	SET(DIOS_MODULE_${MODULE}_VERSION_CODE "1")
	SET(DIOS_MODULE_${MODULE}_VERSION_STRING "1.0.1")

	# IOS设置;
	SET(DIOS_MODULE_${MODULE}_IOS_GUI_IDENTIFIER "com.${DIOS_CMAKE_COMPANY}.${MODULE}")
	SET(DIOS_MODULE_${MODULE}_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")
	SET(DIOS_MODULE_${MODULE}_IPHONEOS_DEPLOYMENT_TARGET 5.0)

	# 是否使用预编译头
	SET(DIOS_MODULE_${MODULE}_PRECOMPILED true)
	SET(DIOS_MODULE_${MODULE}_PREBUILT true)

	# 
	# 2. 计算md5;
	# dios_module_add_default_md5(${MODULE})
	# 	额外计算默认目录的md5，其中包括src,inc,proto,src.android/cpp,src.ios/cpp,src.win/cpp，src.unix/cpp
	# dios_module_add_directory_md5(${MODULE} patch)
	# 	额外计算工程当前某目录下的MD5为模块MD5
	dios_module_add_file_md5(${MODULE} ${DIOS_CMAKE_COCOS_DIRECTORY}/cocos/cocos2d.cpp)
	# 
	# 3. 导入模块;
	# 
	# dios_module_link_library(${MODULE} lib FALSE)
	
	# dios_module_link_library(${MODULE} lib false)
	# dios_module_link_library(${MODULE} foo false)
	# dios_module_link_library(${MODULE} dios_util false)
	# dios_module_link_library(${MODULE} dios_com false)
	# dios_module_link_library(${MODULE} lua false)
	# dios_module_link_library(${MODULE} tolua false)
	# dios_module_link_library(${MODULE} gtest false)
	# dios_module_link_library(${MODULE} pthread false)
	# dios_module_link_library(${MODULE} dl false)
	# dios_module_link_library(${MODULE} socket false)
	# dios_module_link_library(${MODULE} xml2 false)
	# dios_module_link_library(${MODULE} z false)
	# dios_module_link_library(${MODULE} inet false)
	# dios_module_link_library(${MODULE} vld false)


ENDMACRO()


# 
# 导出模块的library和头文件目录;
# 
MACRO(dios_config_find_module MODULE)

	#  dios_find_module(<module>
	#    [PACKAGE <package>]
	#    [COMPONENTS <component...>]
	#    [HEADERS <path>])

	SET(LIBRARY_LIST ${ARGN})
#	FOREACH(TEMP_LIBRARY_NAME ${LIBRARY_LIST})
#		IF(${TEMP_LIBRARY_NAME} STREQUAL pthread)	
#		ELSEIF(${TEMP_LIBRARY_NAME} STREQUAL pthread)
#		ENDIF()
#	ENDFOREACH()

	IF(DIOS_CMAKE_PLATFORM_WIN32)
		dios_find_module(${MODULE} PACKAGE cocos COMPONENTS libjscocos2d libcocos2d HEADERS cocos/cocos2d.h)
		dios_find_module(${MODULE} PACKAGE external1 COMPONENTS websockets libzlib libwebp libiconv freetype250)	
		dios_find_module(${MODULE} PACKAGE external2 COMPONENTS glew32 glfw3 libchipmunk libcurl_imp libSpine)	# 
		dios_find_module(${MODULE} PACKAGE external3 COMPONENTS libpng libjpeg libtiff libbox2d mozjs-33 sqlite3)	
		dios_find_add_libraries(${MODULE} ws2_32 wsock32 winmm opengl32)
		
		# dios_find_module(${MODULE} PACKAGE external HEADERS external/json/document.h)	
		# dios_find_module(${MODULE} PACKAGE extensions HEADERS extensions/cocos-ext.h)	
		# dios_find_module(${MODULE} PACKAGE GL HEADERS GL/glew.h)	
		# dios_find_module(${MODULE} PACKAGE chipmunk HEADERS chipmunk/chipmunk.h)	
		# dios_find_module(${MODULE} PACKAGE freetype2 HEADERS freetype2/freetype.h)	
		# dios_find_module(${MODULE} PACKAGE glfw3 HEADERS glfw3/glfw3.h)			
		# dios_find_module(${MODULE} PACKAGE curl HEADERS curl/curl/curl.h)		
	ELSEIF(DIOS_CMAKE_PLATFORM_ANDORID)
	ELSEIF(DIOS_CMAKE_PLATFORM_IOS)
	ELSEIF(DIOS_CMAKE_PLATFORM_MAC)
		dios_find_module(${MODULE} PACKAGE cocos COMPONENTS libjscocos2d libcocos2d HEADERS cocos/cocos2d.h)		
		dios_find_add_libraries(${MODULE} iconv)
		dios_find_add_libraries(${MODULE} sqlite3)
		dios_find_add_libraries(${MODULE} z)
		dios_find_add_libraries(${MODULE} "-framework AppKit")
		dios_find_add_libraries(${MODULE} "-framework AudioToolbox")
		dios_find_add_libraries(${MODULE} "-framework AVFoundation")
		dios_find_add_libraries(${MODULE} "-framework Foundation")
		dios_find_add_libraries(${MODULE} "-framework IOKit")
		dios_find_add_libraries(${MODULE} "-framework OpenAL")
		dios_find_add_libraries(${MODULE} "-framework OpenGL")
		dios_find_add_libraries(${MODULE} "-framework QuartzCore")
		dios_find_add_libraries(${MODULE} "-framework Security")
	ELSE()
		MESSAGE(FATAL "Load ${MODULE} is not match!")
	ENDIF()

ENDMACRO()


# 
# 准备构建项目;
# 
MACRO(dios_config_module_pre_build)

	# 添加target前的事件
	# dios_module_add_definitions(<module> -DDEFINITION1 -DDEFINITION2)
	# dios_module_add_includes(<module> <include...>)
	# 
	# SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /subsystem:windows")
	# 

ENDMACRO()

# 
# 构建项目结束，准备链接;
# 
MACRO(dios_config_module_post_build)

	# 
	# 添加target后的事件
	# dios_module_add_libraries(<module> <librariy...>)
	# 

ENDMACRO()
