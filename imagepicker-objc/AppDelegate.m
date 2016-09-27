// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "AppDelegate.h"
#import "ImageModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ImageModel sharedInstance];
    /*NSString *__block make = @"Honda";
    NSString *(^getFull)(NSString*)=^(NSString *model){
        make = @"Wa";
        return [make stringByAppendingFormat:@"%@",model];
    };
    NSLog(@"%@",getFull(@"Accord"));
    make = @"Po";
    NSLog(@"%@",getFull(@"911 Turbo"));
    
    NSMutableSet *se= [NSMutableSet set];
    [se addObject:make];
    [se addObject:make];
    NSCountedSet * con = [NSCountedSet set];
    [NSString copy];*/
    return YES;
}

@end
