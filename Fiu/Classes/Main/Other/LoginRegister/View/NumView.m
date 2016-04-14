//
//  NumView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NumView.h"

@implementation NumView

+(instancetype)getNumView{
    return [[NSBundle mainBundle] loadNibNamed:@"Signup" owner:nil options:nil][1];
}

@end
