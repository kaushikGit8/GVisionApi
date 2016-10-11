//
//  ImageModel.m
//  Seed-GoogleCloudVision
//
//  Created by Krunal Soni on 21/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import "ImageModel.h"
#import <UIKit/UIKit.h>

@implementation ImageModel

+ (instancetype)sharedInstance
{
    static ImageModel *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(instancetype)init{

    if (self = [super init]) {
        
        self.faces = [NSMutableArray new];
        self.nature = [NSMutableArray new];
        self.others = [NSMutableArray new];
        UIImage *image = [UIImage imageNamed:@"demo-image"];
        [self.nature addObject:image];
    }
    
    return self;
}

@end
