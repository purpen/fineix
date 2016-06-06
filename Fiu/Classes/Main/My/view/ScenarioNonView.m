//
//  ScenarioNonView.m
//  Fiu
//
//  Created by THN-Dong on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenarioNonView.h"

@implementation ScenarioNonView

+(instancetype)getScenarioNonView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][4];
}

@end
