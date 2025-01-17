//
//  WriteCommentView.m
//  Fiu
//
//  Created by FLYang on 16/4/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "WriteCommentView.h"

@implementation WriteCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [self setViewUI];
    }
    return self;
}

#pragma mark -
- (void)setViewUI {
    [self addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    
    [self addSubview:self.writeText];
    [_writeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(_sendBtn.mas_left).with.offset(-10);
    }];
}

#pragma mark - 填写评论
- (UITextField *)writeText {
    if (!_writeText) {
        _writeText = [[UITextField alloc] init];
        _writeText.placeholder = NSLocalizedString(@"comment", nil);
        if (IS_iOS9) {
            _writeText.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _writeText.font = [UIFont systemFontOfSize:12];
        }
        _writeText.layer.cornerRadius = 5;
        _writeText.layer.masksToBounds = YES;
        _writeText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _writeText.backgroundColor = [UIColor whiteColor];
        _writeText.returnKeyType = UIReturnKeyDone;
        _writeText.delegate = self;
        
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
        _writeText.leftView = leftView;
        _writeText.leftViewMode = UITextFieldViewModeAlways;
    }
    return _writeText;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_writeText resignFirstResponder];
    _writeText.placeholder = NSLocalizedString(@"comment", nil);
    return YES;
}

#pragma mark - 发送评论按钮
- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:NSLocalizedString(@"sendComment", nil) forState:(UIControlStateNormal)];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
        _sendBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.layer.masksToBounds = YES;
    }
    return _sendBtn;
}

@end
