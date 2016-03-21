//
//  NSString+Helper.m
//  fineix
//
//  Created by THN-Dong on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

-(BOOL)checkTel{
    NSString *regex = @"^(13[\\d]{9}|15[\\d]{9}|18[\\d]{9}|14[5,7][\\d]{8}|17[6,7,8][\\d]{8})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

@end
