//
//  FBSearchView.m
//  fineix
//
//  Created by FLYang on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSearchView.h"

@implementation FBSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    
        [self addSubview:self.bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 30, 30));
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self addSubview:self.line];
    }
    
    return self;
}

#pragma mark - 搜索图标显示
- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] init];
        _searchIcon.image = [UIImage imageNamed:@"Search"];
        _searchIcon.contentMode = UIViewContentModeCenter;

    }
    return _searchIcon;
}

#pragma mark - 搜索输入框
- (UITextField *)searchInputBox {
    if (!_searchInputBox) {
        _searchInputBox = [[UITextField alloc] init];
        _searchInputBox.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchInputBox.font = [UIFont systemFontOfSize:Font_Content];
        _searchInputBox.returnKeyType = UIReturnKeySearch;
        _searchInputBox.delegate = self;
    }
    return _searchInputBox;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchInputBox resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:textField.text];
    }
    return YES;
}

#pragma mark - 视图分割线
- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 1)];
        _line.backgroundColor = [UIColor colorWithHexString:@"#F0F0F1" alpha:1];
    }
    return _line;
}

#pragma mark - 背景
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = [UIColor colorWithHexString:lineGrayColor alpha:1].CGColor;
        _bgView.layer.borderWidth = 1;
        _bgView.layer.cornerRadius = 5;
        
        [_bgView addSubview:self.searchIcon];
        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(_bgView);
            make.left.equalTo(_bgView.mas_left).with.offset(5);
        }];
        
        [_bgView addSubview:self.searchInputBox];
        [_searchInputBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@30);
            make.centerY.equalTo(_searchIcon);
            make.left.equalTo(_searchIcon.mas_right).with.offset(0);
            make.right.equalTo(_bgView.mas_right).with.offset(-5);
        }];
    }
    return _bgView;
}

@end
