//
//  NSNumber+UserModel.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NSNumber+UserModel.h"

@implementation NSNumber (UserModel)

+ (NSNumber *)numberFromGenderString:(NSString *)string
{
    if ([string isEqualToString:@"男"]) {
        return @1;
    } else if ([string isEqualToString:@"女"]) {
        return @2;
    } else {
        return @0;
    }
}

@end
