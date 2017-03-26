//
//  THNAccessoryView.m
//  Fiu
//
//  Created by FLYang on 2017/3/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNAccessoryView.h"

@implementation THNAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
    [self addSubview:line];
    
    [self addSubview:self.insertImage];
    [_insertImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-44);
    }];
    
    [self addSubview:self.closeKeybord];
    [_closeKeybord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self).with.offset(0);
        make.width.mas_equalTo(@44);
    }];
    
    [self addSubview:self.uploadState];
    [self addSubview:self.uploadActivity];
}

- (void)thn_hiddenUploadImage:(BOOL)hidden {
    self.uploadState.hidden = hidden;
    if (hidden == NO) {
        self.insertImage.hidden = YES;
        [self.uploadActivity startAnimating];
    } else {
        self.insertImage.hidden = NO;
        [self.uploadActivity stopAnimating];
    }
}

- (UIButton *)insertImage {
    if (!_insertImage) {
        _insertImage = [[UIButton alloc] init];
        [_insertImage setImage:[UIImage imageNamed:@"icon_insertImage"] forState:(UIControlStateNormal)];
        [_insertImage addTarget:self action:@selector(insertImageClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _insertImage;
}

- (UIButton *)closeKeybord {
    if (!_closeKeybord) {
        _closeKeybord = [[UIButton alloc] init];
        [_closeKeybord setImage:[UIImage imageNamed:@"icon_more_open"] forState:(UIControlStateNormal)];
        [_closeKeybord addTarget:self action:@selector(closeKeybordClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeKeybord;
}

- (void)insertImageClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_writeInputBoxInsertImage)]) {
        [self.delegate thn_writeInputBoxInsertImage];
    }
}

- (void)closeKeybordClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(thn_writeInputBoxResignFirstResponder)]) {
        [self.delegate thn_writeInputBoxResignFirstResponder];
    }
}

- (UILabel *)uploadState {
    if (!_uploadState) {
        _uploadState = [[UILabel alloc] initWithFrame:CGRectMake(50, 1, SCREEN_WIDTH - 90, 43)];
        _uploadState.text = @"图片正在上传...";
        _uploadState.font = [UIFont systemFontOfSize:14];
        _uploadState.textColor = [UIColor colorWithHexString:@"#666666"];
        _uploadState.backgroundColor = [UIColor whiteColor];
        _uploadState.hidden = YES;
    }
    return _uploadState;
}

- (UIActivityIndicatorView *)uploadActivity {
    if (!_uploadActivity) {
        _uploadActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 2, 40, 40)];
        _uploadActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _uploadActivity.backgroundColor = [UIColor whiteColor];
    }
    return _uploadActivity;
}

@end
