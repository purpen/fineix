//
//  THNSubHeadView.m
//  Fiu
//
//  Created by THN-Dong on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSubHeadView.h"
#import "UIView+FSExtension.h"
#import "THNSenceTopicViewController.h"
#import "UIColor+Extension.h"
#import "Fiu.h"

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
        
        _haveBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -100 / 667.0 * SCREEN_HEIGHT, 0, 0);
        _haveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -142 / 667.0 * SCREEN_HEIGHT, 0, 0);
        _haveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width + 60 / 667.0 * SCREEN_HEIGHT, 0, 0);
        [_haveBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
        _haveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_haveBtn addTarget:self action:@selector(have:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _haveBtn;
}

-(void)setNum:(NSInteger)num{
    _num = num;
    [self.haveBtn setTitle:[NSString stringWithFormat:@"已定阅%ld个情境主题",(long)self.num] forState:UIControlStateNormal];
}

-(void)have:(UIButton*)sender{
    THNSenceTopicViewController *vc = [[THNSenceTopicViewController alloc] init];
    [self.navi pushViewController:vc animated:YES];
}

@end
