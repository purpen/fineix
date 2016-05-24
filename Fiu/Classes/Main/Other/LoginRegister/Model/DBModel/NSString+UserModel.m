//
//  NSString+UserModel.m
//  fineix
//
//  Created by THN-Dong on 16/3/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NSString+UserModel.h"

@implementation NSString (UserModel)

+ (NSString *)stringFromGenderNumber:(NSNumber *)number
{
    switch ([number integerValue]) {
        case 1:
            return @"男";
            break;
        case 2:
            return @"女";
            break;
        default:
            return @"保密";
            break;
    }
}

@end
