//
//  SubmitView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SubmitView.h"

@implementation SubmitView

-(instancetype)getSubmitView{
    return [[NSBundle mainBundle] loadNibNamed:@"Login" owner:nil options:nil][0];
}

@end
