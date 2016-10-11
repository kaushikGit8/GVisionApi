//
//  ImageModel.h
//  Seed-GoogleCloudVision
//
//  Created by Krunal Soni on 21/09/16.
//  Copyright © 2016 Cognizant. All rights reserved.
//
//
//This file is subject to the terms and conditions defined in
//file 'LICENSE.md', which is part of this source code package.

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic,strong) NSMutableArray *faces;
@property (nonatomic,strong) NSMutableArray *nature;
@property (nonatomic,strong) NSMutableArray *others;

+ (instancetype)sharedInstance;

@end
