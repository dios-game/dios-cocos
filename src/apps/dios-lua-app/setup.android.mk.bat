REM ע��
@echo off

set ocd=%cd%
cd /d %~dp0

if not exist proj.android md proj.android
cd proj.android

echo #####��ʾ����ʼ����#####
cmake -DDIOS_CMAKE_PLATFORM=ANDROID -P ..\CMakeListsAndroid.cmake
rem cmake -DDIOS_CMAKE_PLATFORM=ANDROID -P ..\CMakeListsAndroid.cmake
if %errorlevel% neq 0 goto :cmEnd
echo #####��ʾ����������#####

echo #####��ʾ����ʼ����#####
rem BuildConsole.exe %project%.sln /prj=ALL_BUILD  /Cfg="Debug|WIN32,Release|WIN32" 
call build.bat
if %errorlevel% neq 0 goto :cmEnd
echo #####��ʾ���������#####

echo #####��ʾ����ʼ��װ#####
rem cmake -DBUILD_TYPE="Debug" -P cmake_install.cmake
rem cmake -DBUILD_TYPE="Release" -P cmake_install.cmake
echo #####��ʾ����װ����#####

goto cmDone
:cmEnd
echo setup failed
pause
exit

:cmDone
cmake -P dios_cmake_compile_succeeded.cmake
cmake -P dios_cmake_install_succeeded.cmake
cd /d %ocd%

@echo on
