//
//  IntegralRules.m
//  Fiu
//
//  Created by THN-Dong on 16/5/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "IntegralRules.h"

@interface IntegralRules ()<FBNavigationBarItemsDelegate>

@end

@implementation IntegralRules

-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"积分规则";
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
