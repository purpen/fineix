//
//  THNQRCodeView.h
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNQRCodeView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *qrImageView;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UILabel *linkLabel;
@property (nonatomic, strong) UIButton *linkButton;

- (void)thn_setShareQRCodeInfoImage:(UIImage *)image link:(NSString *)linkUrl;

@end
