//
//  ImageModel.m
//  imagepicker-objc
//
//  Created by Kaushik Jadhav on 21/09/16.
//  Copyright © 2016 Sara Robinson. All rights reserved.
//

#import "ImageModel.h"

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
    }
    
    return self;
}

@end
