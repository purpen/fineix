//
//  SearchLocationViewController.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchLocationViewController.h"

@interface SearchLocationViewController ()

@end

@implementation SearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"位置"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
    [self addLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
