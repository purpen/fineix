//
//  AddCategoryView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddCategoryView.h"
#import "ChooseCategotyViewController.h"
#import "FBNavigationViewController.h"

@implementation AddCategoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.addCategory];
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH - 15, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.2];
        [self addSubview:lineLab];
        
    }
    return self;
}

- (void)getChooseFScene:(NSString *)title {
    [self.addCategory setTitle:title forState:(UIControlStateNormal)];
    [self.addCategory setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}

#pragma mark 选择情景分类
- (UIButton *)addCategory {
    if (!_addCategory) {
        _addCategory = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_addCategory setTitle:NSLocalizedString(@"addCategory", nil) forState:(UIControlStateNormal)];
        _addCategory.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [_addCategory setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.8] forState:(UIControlStateNormal)];
        _addCategory.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_addCategory setImage:[UIImage imageNamed:@"icon_addCategory"] forState:(UIControlStateNormal)];
        [_addCategory setImageEdgeInsets:(UIEdgeInsetsMake(0, 15, 0, 0))];
        [_addCategory setTitleEdgeInsets:(UIEdgeInsetsMake(0, 25, 0, 0))];
        [_addCategory addTarget:self action:@selector(addCategoryClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addCategory;
}

- (void)addCategoryClick {
    ChooseCategotyViewController * chooseCategoryVC = [[ChooseCategotyViewController alloc] init];
    FBNavigationViewController * nav = [[FBNavigationViewController alloc] initWithRootViewController:chooseCategoryVC];
    [self.vc presentViewController:nav animated:YES completion:nil];
}

@end
