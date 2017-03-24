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
    
    [self addSubview:self.uploadImage];
}

- (void)thn_hiddenUploadImage:(BOOL)hidden {
    self.uploadImage.hidden = hidden;
    if (hidden == NO) {
        self.insertImage.hidden = YES;
    } else {
        self.insertImage.hidden = NO;
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

- (UILabel *)uploadImage {
    if (!_uploadImage) {
        _uploadImage = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH - 44, 43)];
        _uploadImage.text = @"图片正在上传...";
        _uploadImage.font = [UIFont systemFontOfSize:14];
        _uploadImage.textColor = [UIColor colorWithHexString:@"#666666"];
        _uploadImage.backgroundColor = [UIColor whiteColor];
        _uploadImage.hidden = YES;
        _uploadImage.textAlignment = NSTextAlignmentCenter;
    }
    return _uploadImage;
}

@end
