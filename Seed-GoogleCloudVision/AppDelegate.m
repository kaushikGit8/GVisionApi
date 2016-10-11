//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import "AppDelegate.h"
#import "ImageModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ImageModel sharedInstance];

    return YES;
}

@end
