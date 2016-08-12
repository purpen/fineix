//
//  THNAgeBtn.m
//  Fiu
//
//  Created by THN-Dong on 16/8/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNAgeBtn.h"
#import "UIView+FSExtension.h"
#import "UIColor+Extension.h"

@implementation THNAgeBtn

- (void)setup
{
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self setTitleColor:[UIColor colorWithHexString:@"#787878"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor colorWithHexString:@"#9C7215"] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self setImage:[UIImage imageNamed:@"l_age_w"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"l_age_y"] forState:UIControlStateSelected];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = 12;
    self.imageView.height = 12;
    
    // 调整文字
    self.titleLabel.x = self.imageView.width + 5;
    self.titleLabel.y = -8;
    self.titleLabel.width = 40;
    self.titleLabel.height = 30;
}

@end
