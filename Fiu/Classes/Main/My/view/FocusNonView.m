//
//  FocusNonView.m
//  Fiu
//
//  Created by THN-Dong on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FocusNonView.h"

@implementation FocusNonView

+(instancetype)getFocusNonView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][5];
}

@end
