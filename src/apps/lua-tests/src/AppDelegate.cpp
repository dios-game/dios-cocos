#include "cocos2d.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "audio/include/SimpleAudioEngine.h"
#include "lua_assetsmanager_test_sample.h"
#include "lua_module_register.h"
#include "lua_test_bindings.h"

using namespace CocosDenshion;

USING_NS_CC;
#if CC_TARGET_PLATFORM==CC_PLATFORM_WIN32
static inline std::string ConvertPathFormatToUnixStyle(const std::string& path)
{
	std::string ret = path;
	int len = ret.length();
	for (int i = 0; i < len; ++i)
	{
		if (ret[i] == '\\')
		{
			ret[i] = '/';
		}
	}
	return ret;
}

static std::string GetCurrentDirectory()
{
	char current_directory[MAX_PATH];
	::GetCurrentDirectoryA(MAX_PATH, current_directory);
	return ConvertPathFormatToUnixStyle(std::string(current_directory) + "/");
}
static void SetDefaultDirectory(){
	FileUtils::getInstance()->setDefaultResourceRootPath(GetCurrentDirectory());
	{
		std::vector<std::string> searchPaths;
		searchPaths.push_back(GetCurrentDirectory());
		FileUtils::getInstance()->setSearchPaths(searchPaths);
	}
}
#endif //  CC_TARGET_PLATFORM==CC_PLATFORM_WIN32
AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

void AppDelegate::initGLContextAttrs()
{
    GLContextAttrs glContextAttrs = {8, 8, 8, 8, 24, 8};
    
    GLView::setGLContextAttrs(glContextAttrs);
}

bool AppDelegate::applicationDidFinishLaunching()
{
#if CC_TARGET_PLATFORM==CC_PLATFORM_WIN32
	SetDefaultDirectory();
#endif
    // register lua engine
    LuaEngine* pEngine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(pEngine);
#if CC_TARGET_PLATFORM==CC_PLATFORM_WIN32
	pEngine->addSearchPath(GetCurrentDirectory().c_str());
#endif
    
    LuaStack* stack = pEngine->getLuaStack();
    stack->setXXTEAKeyAndSign("2dxLua", strlen("2dxLua"), "XXTEA", strlen("XXTEA"));
    
    lua_State* L = stack->getLuaState();
    
    lua_module_register(L);

    lua_getglobal(L, "_G");
    if (lua_istable(L,-1))//stack:...,_G,
    {
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32 || CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID ||CC_TARGET_PLATFORM == CC_PLATFORM_IOS || CC_TARGET_PLATFORM == CC_PLATFORM_MAC)
        register_assetsmanager_test_sample(L);
#endif
        register_test_binding(L);
    }
    lua_pop(L, 1);


    pEngine->executeScriptFile("src/controller.lua");

    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    Director::getInstance()->stopAnimation();

    SimpleAudioEngine::getInstance()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    Director::getInstance()->startAnimation();

    SimpleAudioEngine::getInstance()->resumeBackgroundMusic();
}
