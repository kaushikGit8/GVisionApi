//
//  ImageModel.h
//  imagepicker-objc
//
//  Created by Kaushik Jadhav on 21/09/16.
//  Copyright © 2016 Sara Robinson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic,strong) NSMutableArray *faces;
@property (nonatomic,strong) NSMutableArray *nature;

+ (instancetype)sharedInstance;

@end
