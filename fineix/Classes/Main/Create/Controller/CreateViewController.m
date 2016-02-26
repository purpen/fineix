//
//  CreateViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CreateViewController.h"

@implementation CreateViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    back.backgroundColor = [UIColor redColor];
    [back addTarget:self action:@selector(backClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:back];
}

- (void)backClick {
    [self dismissViewControllerAnimated:self completion:nil];
}

@end
