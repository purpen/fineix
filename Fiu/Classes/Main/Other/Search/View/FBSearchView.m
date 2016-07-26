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
            make.size.mas_equalTo(CGSizeMake(self.bounds.size.width - 70, 30));
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(15);
        }];
        
        [self addSubview:self.cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.right.equalTo(self.mas_right).with.offset(-5);
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
        _searchInputBox.clearButtonMode = UITextFieldViewModeAlways;
        _searchInputBox.font = [UIFont fontWithName:@"PingFangSC-Light" size:Font_Content];
        _searchInputBox.returnKeyType = UIReturnKeySearch;
        _searchInputBox.delegate = self;
    }
    return _searchInputBox;
}

#pragma mark - 取消按钮
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:NSLocalizedString(@"cancel", nil) forState:(UIControlStateNormal)];
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [_cancelBtn addTarget:self action:@selector(canceleSearch) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

//  收起键盘
- (void)canceleSearch {
    if ([self.delegate respondsToSelector:@selector(cancelSearch)]) {
        [self.delegate cancelSearch];
    }
    [_searchInputBox resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_searchInputBox resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:textField.text];
    }
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    [self changeSearchBoxFrame:YES];
//}

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

//#pragma mark - 改变输入框状态
//- (void)changeSearchBoxFrame:(BOOL)type {
//    if (type == YES) {
//        [UIView animateWithDuration:.2 animations:^{
//            [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(self.bounds.size.width - 70);
//            }];
//            
//            [_bgView layoutIfNeeded];
//            
//        } completion:^(BOOL finished) {
//            [self addSubview:self.cancelBtn];
//            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(44, 44));
//                make.top.equalTo(self.mas_top).with.offset(0);
//                make.right.equalTo(self.mas_right).with.offset(-5);
//            }];
//        }];
//    
//    } else if (type == NO) {
//        [_cancelBtn removeFromSuperview];
//        [UIView animateWithDuration:.2 animations:^{
//            [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_equalTo(self.bounds.size.width - 30);
//            }];
//            
//            [_bgView layoutIfNeeded];
//        }];
//
//    }
//}

@end
