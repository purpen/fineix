//
//  BottomView.m
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BottomView.h"

@implementation BottomView

+(instancetype)getBottomView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][3];
}

@end
