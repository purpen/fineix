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
        
        [self addSubview:self.searchIcon];
        
        [self addSubview:self.searchInputBox];
        
        [self addSubview:self.line];
    }
    
    return self;
}

#pragma mark - 搜索图标显示
- (UIImageView *)searchIcon {
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 44)];
        _searchIcon.image = [UIImage imageNamed:@"Search"];
        _searchIcon.contentMode = UIViewContentModeCenter;

    }
    return _searchIcon;
}

#pragma mark - 搜索输入框
- (UITextField *)searchInputBox {
    if (!_searchInputBox) {
        _searchInputBox = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 50, 44)];
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

@end
