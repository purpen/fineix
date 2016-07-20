//
//  AddContentView.m
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddContentView.h"
#import "FBEditShareInfoViewController.h"

@implementation AddContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.title];
        [self addSubview:self.content];
        [self addSubview:self.chooseText];
    }
    return self;
}

#pragma mark - 场景标题
- (UITextField *)title {
    if (!_title) {
        _title = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
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

#pragma mark - 场景描述
- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 100)];
        _content.font = [UIFont systemFontOfSize:14];
        _content.text = NSLocalizedString(@"addDescription", nil);
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        _content.delegate = self;
        _content.returnKeyType = UIReturnKeyDefault;
    }
    return _content;
}

#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
        _content.text = @"";
    }
    _content.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:1];
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_content.text isEqualToString:@""]) {
        if ([self.type isEqualToString:@"scene"]) {
            _content.text = NSLocalizedString(@"addDescription", nil);
        }
        _content.textColor = [UIColor colorWithHexString:@"#A2A2A2" alpha:1];
        
    } else {
        if ([_delegate respondsToSelector:@selector(EditDoneGoGetTags:)]){
            [_delegate EditDoneGoGetTags:textView.text];
        }
    }
}

#pragma mark - 选择语境
- (UIButton *)chooseText {
    if (!_chooseText) {
        _chooseText = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 0, 60, 44)];
        _chooseText.titleLabel.font = [UIFont systemFontOfSize:12];
        [_chooseText setTitle:NSLocalizedString(@"ChooseText", nil) forState:(UIControlStateNormal)];
        [_chooseText setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:(UIControlStateNormal)];
        [_chooseText addTarget:self action:@selector(goChooseText) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _chooseText;
}

- (void)goChooseText {
    FBEditShareInfoViewController * chooseTextVC = [[FBEditShareInfoViewController alloc] init];
    chooseTextVC.bgImg = self.bgImage;
    [self.vc presentViewController:chooseTextVC animated:YES completion:nil];
    
    chooseTextVC.getEdtiShareText = ^ (NSString * title, NSString * des, NSArray * tagS) {
        self.title.text = title;
        self.content.text = des;
        self.content.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.tagS = [NSArray arrayWithArray:tagS];
    };
}


@end
