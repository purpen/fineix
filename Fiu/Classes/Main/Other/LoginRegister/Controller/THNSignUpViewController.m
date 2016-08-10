//
//  THNSignUpViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSignUpViewController.h"

@interface THNSignUpViewController ()

/**  */
@property (nonatomic, strong) NSMutableArray *textAry;

@end

@implementation THNSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < 11; i++) {
        UITextField *tF = [[UITextField alloc] initWithFrame:CGRectMake(80 + i * 5, 220, 2, 20)];
        tF.placeholder = @"*";
        tF.borderStyle = UITextBorderStyleNone;
        tF.textColor = [UIColor whiteColor];
        [self.view addSubview:tF];
    }
}


@end
