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
//    [message setValuesForKeysWithDictionary:dict];
    message.content = [dict objectForKey:@"content"];
    message.created_at = [dict objectForKey:@"created_at"];
    message.user_type = [dict objectForKey:@"user_type"];
    return message;
}

@end
