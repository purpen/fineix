//
//  TalentView.m
//  Fiu
//
//  Created by THN-Dong on 16/5/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "TalentView.h"

@implementation TalentView

+(instancetype)getTalentView{
    TalentView *view = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][3];
    return view;
}

@end
