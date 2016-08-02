//
//  SearchTF.m
//  Fiu
//
//  Created by THN-Dong on 16/8/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchTF.h"

@interface SearchTF ()


@end

@implementation SearchTF

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.placeholder = @"搜索用户";
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:14];
        self.leftView = self.view;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.returnKeyType = UIReturnKeySearch;
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

-(UIView *)view{
    if (!_view) {
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 40, 35)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(search)];
        _view.userInteractionEnabled = YES;
        [_view addGestureRecognizer:tap];
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search"]];
        searchIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40 -16, 9.5, 16, 16);
        self.searchIcon = searchIcon;
        [_view addSubview:_searchIcon];
    }
    return _view;
}

-(void)search{
    [self becomeFirstResponder];
}

-(BOOL)becomeFirstResponder{
    self.view.frame = CGRectMake(0, 0, 15 + 16, 35);
    _searchIcon.frame = CGRectMake(15, 9.5, 16, 16);
    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 40, 35);
    _searchIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40 -16, 9.5, 16, 16);
    return [super resignFirstResponder];
}


@end
