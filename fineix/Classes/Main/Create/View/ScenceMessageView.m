//
//  ScenceMessageView.m
//  fineix
//
//  Created by FLYang on 16/3/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenceMessageView.h"

@implementation ScenceMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
        
        [self addSubview:self.topView];
        
        [self addSubview:self.bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44.5));
            make.top.equalTo(_topView.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        }];
    }
    return self;
}

#pragma mark - top
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 182)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        [_topView addSubview:self.imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(115.5, 154));
            make.top.equalTo(_topView.mas_top).with.offset(15);
            make.left.equalTo(_topView.mas_left).with.offset(15);
        }];
        
        [_topView addSubview:self.content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_top).with.offset(15);
            make.left.equalTo(_imageView.mas_right).with.offset(15);
            make.right.equalTo(_topView.mas_right).with.offset(-15);
            make.bottom.equalTo(_topView.mas_bottom).with.offset(-15);
        }];
    }
    return _topView;
}

#pragma mark - 场景缩略图
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds  = YES;  //  是否剪切掉超出 UIImageView 范围的图片
        [_imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _imageView;
}

#pragma mark - 场景描述
- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.font = [UIFont systemFontOfSize:Font_GoodsPrice];
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        _content.delegate = self;
        _content.returnKeyType = UIReturnKeyDone;
    }
    return _content;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_content.text  isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        _content.text = @"";
    }
    _content.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_content resignFirstResponder];
        if ([_content.text isEqualToString:@""]) {
            _content.text = NSLocalizedString(@"addDescription", nil);
            _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:@""]) {
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
    }
}

#pragma mark - bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, 44.5));
            make.top.equalTo(_bottomView.mas_top).with.offset(0);
            make.left.equalTo(_bottomView.mas_left).with.offset(15);
        }];
        
    }
    return _bottomView;
}
#pragma mark - 场景标题
- (UITextField *)title {
    if (!_title) {
        _title = [[UITextField alloc] init];
        _title.placeholder = NSLocalizedString(@"addTitle", nil);
        _title.font = [UIFont systemFontOfSize:Font_GoodsPrice];
        _title.clearButtonMode = UITextFieldViewModeWhileEditing;
        _title.delegate = self;
        _title.returnKeyType = UIReturnKeyDone;
    }
    return _title;
}

#pragma mark UITextFieldDelegate 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_title resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
