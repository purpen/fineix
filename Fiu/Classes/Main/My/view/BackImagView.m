//
//  BackImagView.m
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BackImagView.h"

@implementation BackImagView

+(instancetype)getBackImageView{
    BackImagView *backImageV = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][2];
    
    return backImageV;
}

@end
