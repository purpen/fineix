//
//  THNSubHeadView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSubHeadView.h"
#import "UIView+FSExtension.h"

@interface THNSubHeadView ()

/**  */
@property (nonatomic, strong) UIButton *haveBtn;

@end

@implementation THNSubHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.haveBtn];
    }
    return self;
}

-(UIButton *)haveBtn{
    if (!_haveBtn) {
        _haveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _haveBtn.frame = CGRectMake(0, 0, self.width, self.height);
        [_haveBtn setImage:[UIImage imageNamed:@"go"] forState:UIControlStateNormal];
        [_haveBtn setTitle:[NSString stringWithFormat:@"已定阅2个情境主题"] forState:UIControlStateNormal];
        _haveBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -100, 0, 0);
        _haveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -110, 0, 0);
        _haveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width + 60, 0, 0);
        [_haveBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _haveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _haveBtn;
}

@end
