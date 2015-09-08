#include "cocos2d.h"
#include "AppDelegate.h"
#include "audio/include/SimpleAudioEngine.h"
#include "base/CCScriptSupport.h"
#include "CCLuaEngine.h"
#include "lua_module_register.h"

USING_NS_CC;
using namespace CocosDenshion;


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
    // fixed me
    //_CrtSetDbgFlag(_CRTDBG_ALLOC_MEM_DF|_CRTDBG_LEAK_CHECK_DF);
}

AppDelegate::~AppDelegate()
{
    // end simple audio engine here, or it may crashed on win32
    SimpleAudioEngine::getInstance()->end();
    //CCScriptEngineManager::destroyInstance();
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
    LuaEngine* engine = LuaEngine::getInstance();
    ScriptEngineManager::getInstance()->setScriptEngine(engine);

#if CC_TARGET_PLATFORM==CC_PLATFORM_WIN32
	engine->addSearchPath(GetCurrentDirectory().c_str());
#endif

    lua_State* L = engine->getLuaStack()->getLuaState();
    lua_module_register(L);
    //The call was commented because it will lead to ZeroBrane Studio can't find correct context when debugging
    //engine->executeScriptFile("src/hello.lua");
    engine->executeString("require 'src/hello.lua'");

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
