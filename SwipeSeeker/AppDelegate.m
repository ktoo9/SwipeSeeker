#import "AppDelegate.h"
#import "SSListController.h"
#import "SSSettingController.h"
#import "SSSettingManager.h"
#import "SSMediaManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    [[SSSettingManager sharedManager] load];
    [[SSMediaManager sharedManager] load];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    
    SSListController* videoListController = [[SSListController alloc] initWithStyle:UITableViewStylePlain];
    videoListController.items = [SSMediaManager sharedManager].videos;
    videoListController.navigationItem.title = @"video";
    videoListController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"video" image:[UIImage imageNamed:@"icon_video.png"] tag:0];
    
    SSListController* audioListController = [[SSListController alloc] initWithStyle:UITableViewStylePlain];
    audioListController.items = [SSMediaManager sharedManager].audios;
    audioListController.navigationItem.title = @"audio";
    audioListController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"audio" image:[UIImage imageNamed:@"icon_audio.png"] tag:0];
    
    SSSettingController* settingController = [[SSSettingController alloc] initWithStyle:UITableViewStyleGrouped];
    settingController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"setting" image:[UIImage imageNamed:@"icon_setting.png"] tag:0];
    
    NSArray* controllers;
    controllers = [NSArray arrayWithObjects:
                   [[UINavigationController alloc] initWithRootViewController:videoListController],
                   [[UINavigationController alloc] initWithRootViewController:audioListController],
                   settingController, nil];

    _rootController = [[UITabBarController alloc] init];
    [_rootController setViewControllers:controllers animated:NO];
    [_window addSubview:_rootController.view];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    [[SSMediaManager sharedManager] save];
    [[SSSettingManager sharedManager] save];
}

@end