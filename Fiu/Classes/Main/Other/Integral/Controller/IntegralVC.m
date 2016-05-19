//
//  IntegralVC.m
//  Fiu
//
//  Created by THN-Dong on 16/5/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "IntegralVC.h"
#import "IntegralRules.h"

@interface IntegralVC ()<FBNavigationBarItemsDelegate>

@end

@implementation IntegralVC

-(void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"积分";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"积分规则" image:nil isTransparent:NO];
}

-(void)rightBarItemSelected{
    IntegralRules *vc = [[IntegralRules alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
