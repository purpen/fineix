//
//  ChangePwdViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()<FBNavigationBarItemsDelegate>

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text =
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
