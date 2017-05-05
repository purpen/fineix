//
//  THNQRCodeView.m
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNQRCodeView.h"

@interface THNQRCodeView () {
    NSString *_linkUrl;
    UIImage *_shareImage;
}

@end

@implementation THNQRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self thn_setViewUI];
        [self addGestureRecognizer];
    }
    return self;
}

- (void)thn_setShareQRCodeInfoImage:(UIImage *)image link:(NSString *)linkUrl {
    _linkUrl = linkUrl;
    _shareImage = image;
    self.qrImageView.image = image;
    self.linkLabel.text = linkUrl;
}

- (void)thn_setViewUI {
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    [self thn_addViewKit];
}

- (void)thn_addViewKit {
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.top.equalTo(self.mas_top).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.qrImageView];
    [_qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 180));
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.hintLabel];
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 20));
        make.top.equalTo(_qrImageView.mas_bottom).with.offset(10);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.linkLabel];
    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 30));
        make.top.equalTo(_hintLabel.mas_bottom).with.offset(0);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.linkButton];
    [_linkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.centerX.equalTo(self);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel.text = @"扫一扫";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIImageView *)qrImageView {
    if (!_qrImageView) {
        _qrImageView = [[UIImageView alloc] init];
        _qrImageView.layer.borderWidth = 0.5;
        _qrImageView.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
        _qrImageView.userInteractionEnabled = YES;
    }
    return _qrImageView;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont systemFontOfSize:12];
        _hintLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _hintLabel.text = @"长按保存二维码";
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}

- (UILabel *)linkLabel {
    if (!_linkLabel) {
        _linkLabel = [[UILabel alloc] init];
        _linkLabel.font = [UIFont systemFontOfSize:14];
        _linkLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _linkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _linkLabel;
}

- (UIButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [[UIButton alloc] init];
        _linkButton.layer.cornerRadius = 3.0;
        _linkButton.layer.masksToBounds = YES;
        _linkButton.layer.borderWidth = 0.5;
        _linkButton.layer.borderColor = [UIColor colorWithHexString:MAIN_COLOR].CGColor;
        _linkButton.backgroundColor = [UIColor whiteColor];
        _linkButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_linkButton setTitle:@"复制链接" forState:(UIControlStateNormal)];
        [_linkButton setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:(UIControlStateNormal)];
        [_linkButton addTarget:self  action:@selector(copyLinkURL:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _linkButton;
}

- (void)copyLinkURL:(UIButton *)button {
    if (_linkUrl.length > 0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _linkUrl;
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无分享链接"];
    }
}

#pragma mark - 添加手势操作
- (void)addGestureRecognizer {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
    [self.qrImageView addGestureRecognizer:longPress];
}

- (void)saveImage:(UILongPressGestureRecognizer *)loogPress {
    switch (loogPress.state) {
        case UIGestureRecognizerStateBegan:
            [self saveImageToPhotoAlbum];
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        default:
            break;
    }
}

#pragma mark - 保存图片到本地
- (void)saveImageToPhotoAlbum {
    UIImageWriteToSavedPhotosAlbum(_shareImage,
                                   self,
                                   @selector(image:didFinishSavingWithError:contextInfo:),
                                   nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL){
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"已保存到相册"];
    }
}

@end
