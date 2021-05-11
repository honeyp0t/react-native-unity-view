#include <csignal>
#import <UIKit/UIKit.h>
#import "UnityUtils.h"


// Hack to work around iOS SDK 4.3 linker problem
// we need at least one __TEXT, __const section entry in main application .o files
// to get this section emitted at right time and so avoid LC_ENCRYPTION_INFO size miscalculation
static const int constsection = 0;

bool unity_inited = false;

int g_argc;
char** g_argv;

void UnityInitTrampoline();

UnityFramework* ufw;

extern "C" void InitArgs(int argc, char* argv[])
{
    g_argc = argc;
    g_argv = argv;
}

extern "C" bool UnityIsInited()
{
    return unity_inited;
}

UnityFramework* UnityFrameworkLoad()
{
    NSString* bundlePath = nil;
    bundlePath = [[NSBundle mainBundle] bundlePath];
    bundlePath = [bundlePath stringByAppendingString: @"/Frameworks/UnityFramework.framework"];

    NSBundle* bundle = [NSBundle bundleWithPath: bundlePath];
    if ([bundle isLoaded] == false) [bundle load];

    UnityFramework* ufw = [bundle.principalClass getInstance];
    if (![ufw appController])
    {
        // unity is not initialized
        [ufw setExecuteHeader: &_mh_execute_header];
    }
    return ufw;
}

extern "C" void InitUnity()
{
    if (unity_inited) {
        return;
    }
    unity_inited = true;

    ufw = UnityFrameworkLoad();

    [ufw setDataBundleId: "com.unity3d.framework"];

    [ufw runEmbeddedWithArgc:g_argc argv:g_argv appLaunchOpts:nil];
    
    if ([ufw appController]) {
        [[ufw appController] setUnityMessageHandler:^(const char *message) {
            [UnityUtils onUnityMessage:message];
        }];
    }
}

extern "C" void UnityPostMessage(NSString* gameObject, NSString* methodName, NSString* message)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ufw sendMessageToGOWithName:[gameObject UTF8String] functionName:[methodName UTF8String] message:[message UTF8String]];
    });
}

extern "C" void UnityPauseCommand()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ufw pause:true];
    });
}

extern "C" void UnityResumeCommand()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ufw pause:false];
    });
}

extern "C" void SetKeyWindow()
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication* application = [UIApplication sharedApplication];
        for(UIWindow *window in application.windows) {
            if(window.tag == 42) {
                [window makeKeyWindow];
                break;
            }

        }
    });
}

@implementation UnityUtils

static NSHashTable* mUnityEventListeners = [NSHashTable weakObjectsHashTable];
static BOOL _isUnityReady = NO;

+ (BOOL)isUnityReady
{
    return _isUnityReady;
}

+ (UnityAppController*)GetUnityAppController
{
    if (!ufw) {
        return nil;
    }
    
    return [ufw appController];
}

+ (void)handleAppStateDidChange:(NSNotification *)notification
{
    if (!_isUnityReady) {
        return;
    }
    
    if (![ufw appController])
    {
        return;
    }
    
    UnityAppController* unityAppController = [ufw appController];

    UIApplication* application = [UIApplication sharedApplication];

    if ([notification.name isEqualToString:UIApplicationWillResignActiveNotification]) {
        [unityAppController applicationWillResignActive:application];
    } else if ([notification.name isEqualToString:UIApplicationDidEnterBackgroundNotification]) {
        [unityAppController applicationDidEnterBackground:application];
    } else if ([notification.name isEqualToString:UIApplicationWillEnterForegroundNotification]) {
        [unityAppController applicationWillEnterForeground:application];
    } else if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        [unityAppController applicationDidBecomeActive:application];
    } else if ([notification.name isEqualToString:UIApplicationWillTerminateNotification]) {
        [unityAppController applicationWillTerminate:application];
    } else if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification]) {
        [unityAppController applicationDidReceiveMemoryWarning:application];
    }
}

+ (void)listenAppState
{
    for (NSString *name in @[UIApplicationDidBecomeActiveNotification,
                             UIApplicationDidEnterBackgroundNotification,
                             UIApplicationWillTerminateNotification,
                             UIApplicationWillResignActiveNotification,
                             UIApplicationWillEnterForegroundNotification,
                             UIApplicationDidReceiveMemoryWarningNotification]) {

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAppStateDidChange:)
                                                     name:name
                                                   object:nil];
    }
}

+ (void)createPlayer:(void (^)(void))completed
{
    if (_isUnityReady) {
        completed();
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserverForName:@"UnityReady" object:nil queue:[NSOperationQueue mainQueue]  usingBlock:^(NSNotification * _Nonnull note) {
        _isUnityReady = YES;
        completed();
    }];

    if (UnityIsInited()) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication* application = [UIApplication sharedApplication];

        // Always keep RN window in top
        UIWindow* reactNativeWindow = application.keyWindow;
        reactNativeWindow.tag = 42;

        InitUnity();
        
        // Lower the window level on the unity window
        UnityAppController* controller = [UnityUtils GetUnityAppController];
        if(controller) {
            controller.window.windowLevel = reactNativeWindow.windowLevel - 1;
        }
        
        // Make react native window key window again (changes from keywindow when unity initializes)
        [reactNativeWindow makeKeyWindow];
        
        [UnityUtils listenAppState];
    });
}


+ (void)onUnityMessage:(const char*)message
{
    for (id<UnityEventListener> listener in mUnityEventListeners) {
        [listener onMessage:[NSString stringWithUTF8String:message]];
    }
}

+ (void)addUnityEventListener:(id<UnityEventListener>)listener
{
    [mUnityEventListeners addObject:listener];
}

+ (void)removeUnityEventListener:(id<UnityEventListener>)listener
{
    [mUnityEventListeners removeObject:listener];
}


@end
