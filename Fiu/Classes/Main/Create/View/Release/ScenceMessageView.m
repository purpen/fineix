//
//  ScenceMessageView.m
//  fineix
//
//  Created by FLYang on 16/3/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenceMessageView.h"
#import "FBEditShareInfoViewController.h"

@implementation ScenceMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:grayLineColor alpha:1];
    }
    return self;
}

- (void)getCreateType:(NSString *)type {
    self.type = type;
    [self setUI];
}

#pragma mark - 设置视图
- (void)setUI {
    [self addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44.5));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
        make.left.right.equalTo(self).with.offset(0);
    }];
}

#pragma mark - top
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];

        [_topView addSubview:self.imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(86.62, 154));
            make.top.equalTo(_topView.mas_top).with.offset(15);
            make.left.equalTo(_topView.mas_left).with.offset(15);
        }];
        
        [_topView addSubview:self.content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_top).with.offset(5);
            make.left.equalTo(_imageView.mas_right).with.offset(10);
            make.right.equalTo(_topView.mas_right).with.offset(-10);
            make.bottom.equalTo(_topView.mas_bottom).with.offset(-5);
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
        _content.font = [UIFont systemFontOfSize:14];
        if ([self.type isEqualToString:@"scene"]) {
            _content.text = NSLocalizedString(@"addDescription", nil);
        } else if ([self.type isEqualToString:@"fScene"]) {
            _content.text = NSLocalizedString(@"addFiuSceneDes", nil);
        }
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        _content.delegate = self;
        _content.returnKeyType = UIReturnKeyDone;
    }
    return _content;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        _content.text = @"";
    } else if ([_content.text isEqualToString:NSLocalizedString(@"addFiuSceneDes", nil)]) {
        _content.text = @"";
    }
    _content.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [_content resignFirstResponder];
        if ([_content.text isEqualToString:@""]) {
            if ([self.type isEqualToString:@"scene"]) {
                _content.text = NSLocalizedString(@"addDescription", nil);
            } else if ([self.type isEqualToString:@"fScene"]) {
                _content.text = NSLocalizedString(@"addFiuSceneDes", nil);
            }
            _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:@""]) {
        if ([self.type isEqualToString:@"scene"]) {
            _content.text = NSLocalizedString(@"addDescription", nil);
        } else if ([self.type isEqualToString:@"fScene"]) {
            _content.text = NSLocalizedString(@"addFiuSceneDes", nil);
        }
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
    
    } else {
        if ([_delegate respondsToSelector:@selector(EditDoneGoGetTags:)]){
            [_delegate EditDoneGoGetTags:textView.text];
        }
    }
}

#pragma mark - bottom
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 84, 44.5));
            make.top.equalTo(_bottomView.mas_top).with.offset(0);
            make.left.equalTo(_bottomView.mas_left).with.offset(15);
        }];
        
        [_bottomView addSubview:self.chooseText];
        [_chooseText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(54, 44.5));
            make.top.equalTo(_bottomView.mas_top).with.offset(0);
            make.right.equalTo(_bottomView.mas_right).with.offset(-10);
        }];
    }
    return _bottomView;
}
#pragma mark - 场景标题
- (UITextField *)title {
    if (!_title) {
        _title = [[UITextField alloc] init];
        _title.placeholder = NSLocalizedString(@"addTitle", nil);
        _title.font = [UIFont systemFontOfSize:14];
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

#pragma mark - 选择语境
- (UIButton *)chooseText {
    if (!_chooseText) {
        _chooseText = [[UIButton alloc] init];
        _chooseText.titleLabel.font = [UIFont systemFontOfSize:12];
        [_chooseText setTitle:NSLocalizedString(@"ChooseText", nil) forState:(UIControlStateNormal)];
        [_chooseText setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        [_chooseText addTarget:self action:@selector(goChooseText) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseText;
}

- (void)goChooseText {
    FBEditShareInfoViewController * chooseTextVC = [[FBEditShareInfoViewController alloc] init];
    chooseTextVC.bgImg = self.imageView.image;
    [self.vc presentViewController:chooseTextVC animated:YES completion:nil];
    
    chooseTextVC.getEdtiShareText = ^ (NSString * title, NSString * des, NSArray * tagS) {
        self.title.text = title;
        self.content.text = des;
        self.content.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.tagS = [NSArray arrayWithArray:tagS];
//        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝ %@", self.tagS);
    };
}

@end
