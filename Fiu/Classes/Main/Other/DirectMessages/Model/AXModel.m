//
//  AXModel.m
//  Fiu
//
//  Created by THN-Dong on 16/4/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AXModel.h"

@implementation AXModel

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    AXModel *message = [[self alloc] init];
    [message setValuesForKeysWithDictionary:dict];
    return message;
}

@end