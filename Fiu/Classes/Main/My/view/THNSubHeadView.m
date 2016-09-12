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
@property (nonatomic, strong) UILabel *numLabel;
/**  */
@property (nonatomic, strong) UIImageView *goImage;

@end

@interface THNSubHeadView ()

/**  */
@property (nonatomic, strong) UIButton *haveBtn;

@end

@implementation THNSubHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.haveBtn];
        
        [self addSubview:self.numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.centerY.mas_equalTo(self.centerY).offset(0);
        }];
        
        [self addSubview:self.goImage];
        [_goImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-20);
            make.centerY.mas_equalTo(self.centerY).offset(0);
        }];
    }
    return self;
}

-(UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _numLabel.font = [UIFont systemFontOfSize:13];
    }
    return _numLabel;
}

-(UIButton *)haveBtn{
    if (!_haveBtn) {
        _haveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _haveBtn.frame = CGRectMake(0, 0, self.width, self.height);
//        [_haveBtn setImage:[UIImage imageNamed:@"icon_Next"] forState:UIControlStateNormal];
//        
//        _haveBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -100 / 667.0 * SCREEN_HEIGHT, 0, 0);
//        _haveBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -145 / 667.0 * SCREEN_HEIGHT, 0, 0);
//        _haveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, [UIScreen mainScreen].bounds.size.width + 60 / 667.0 * SCREEN_HEIGHT, 0, 0);
//        [_haveBtn setTitleColor:[UIColor colorWithHexString:@"#222222"] forState:UIControlStateNormal];
//        _haveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_haveBtn addTarget:self action:@selector(have:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _haveBtn;
}

-(UIImageView *)goImage{
    if (!_goImage) {
        _goImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Next"]];
    }
    return _goImage;
}

-(void)setNum:(NSInteger)num{
    _num = num;
    self.numLabel.text = [NSString stringWithFormat:@"已定阅%ld个情境主题",(long)self.num];
}

-(void)have:(UIButton*)sender{
    THNSenceTopicViewController *vc = [[THNSenceTopicViewController alloc] init];
    [self.navi pushViewController:vc animated:YES];
}

@end
