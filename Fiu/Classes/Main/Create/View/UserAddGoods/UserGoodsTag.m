//
//  UserGoodsTag.m
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserGoodsTag.h"
#import "NSTimer+Addition.h"

@interface UserGoodsTag () {
    NSTimer *   timerAnimation;
    UIView  *   viewSpread;
    UIView  *   viewTapDot;
}

@end

@implementation UserGoodsTag

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateHighlighted)];
        [self setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateNormal)];
        
        timerAnimation =[NSTimer scheduledTimerWithTimeInterval:2
                                                         target:self
                                                       selector:@selector(animationTimerDidFired)
                                                       userInfo:nil
                                                        repeats:YES];
        [self setUI];
        
    }
    return self;
}

#pragma mark - 设置视图
- (void)setUI {
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(112.5, 23));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62.5, 23));
        make.centerY.equalTo(self);
        make.left.equalTo(self.title.mas_right).with.offset(0);
    }];
    
    viewTapDot = [self getViewTapDot];
    [self addSubview:viewTapDot];
    [viewTapDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(104);
    }];
    
    viewSpread = [self getViewSpread];
    [self addSubview:viewSpread];
    [viewSpread mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.centerY.equalTo(viewTapDot);
        make.centerX.equalTo(viewTapDot);
    }];
    
    [timerAnimation resumeTimer];
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:fineixColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

#pragma mark - 价格
- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.textColor = [UIColor whiteColor];
        _price.font = [UIFont systemFontOfSize:12];
        _price.textAlignment = NSTextAlignmentCenter;
    }
    return _price;
}

#pragma mark - 圆点
- (UIView *)getViewSpread {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.7];
    view.layer.cornerRadius = 5 / 2;
    view.layer.masksToBounds = YES;
    view.userInteractionEnabled=NO;
    return view;
}

- (UIView *)getViewTapDot {
    UIView *view =[UIView new];
    view.backgroundColor=[UIColor colorWithHexString:fineixColor];
    view.layer.cornerRadius = 5 / 2;
    view.layer.masksToBounds = YES;
    view.userInteractionEnabled=NO;
    return view;
}


#pragma mark - 动画
-(void)animationTimerDidFired{
    [UIView animateWithDuration:1 animations:^{
        viewTapDot.transform = CGAffineTransformMakeScale(1.5,1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            viewTapDot.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            viewSpread.alpha=1;
            [UIView animateWithDuration:1 animations:^{
                viewSpread.alpha=0;
                viewSpread.transform = CGAffineTransformMakeScale(8,8);
            }completion:^(BOOL finished) {
                viewSpread.transform = CGAffineTransformIdentity;
            }];
        }];
        
    }];
}


@end
