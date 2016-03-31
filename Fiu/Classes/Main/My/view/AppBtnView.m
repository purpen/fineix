//
//  AppBtnView.m
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AppBtnView.h"

@implementation AppBtnView

+(instancetype)getAppBtnView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][5];
}

@end
