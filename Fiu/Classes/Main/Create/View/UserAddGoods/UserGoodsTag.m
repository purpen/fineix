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
    CGPoint     startPoint;
    CGPoint     _translateCenter;
}

@end

@implementation UserGoodsTag

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateHighlighted)];
        [self setImage:[UIImage imageNamed:@"user_goodsTag_left"] forState:(UIControlStateNormal)];
        
        timerAnimation =[NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(animationTimerDidFired)
                                                       userInfo:nil
                                                        repeats:YES];
        [self setUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isMove == YES) {
        //  保存触摸起始点位置
        CGPoint point = [[touches anyObject] locationInView:self.superview];
        startPoint = point;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.isMove == YES) {
        //  计算位移=当前位置-起始位置
        CGPoint point = [[touches anyObject] locationInView:self.superview];
        float dx = point.x - startPoint.x;
        float dy = point.y - startPoint.y;
        
        //  计算移动后的view中心点
        _translateCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
        
        //  限制用户不可将视图托出屏幕
        float halfx = CGRectGetMidX(self.bounds);
        _translateCenter.x = MAX(halfx, _translateCenter.x);
        _translateCenter.x = MIN(self.superview.bounds.size.width - halfx, _translateCenter.x);
        
        float halfy = CGRectGetMidY(self.bounds);
        _translateCenter.y = MAX(halfy + 50, _translateCenter.y);
        _translateCenter.y = MIN(self.superview.bounds.size.height - halfy - 50, _translateCenter.y);
        
        //移动view
        self.center = _translateCenter;
        [self setNeedsDisplay];
        startPoint = point;
    }
}

#pragma mark - 设置视图
- (void)setUI {
    [self addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(105, 23));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(4);
    }];
    
    [self addSubview:self.price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(62.5, 23));
        make.centerY.equalTo(self);
        make.left.equalTo(self.title.mas_right).with.offset(0);
    }];
    
    [self addSubview:self.dele];
    [_dele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.equalTo(self.mas_top).with.offset(-10);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    
    viewTapDot = [self getViewTapDot];
    [self addSubview:viewTapDot];
    [viewTapDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).with.offset(100);
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

#pragma mark - 删除
- (UIButton *)dele {
    if (!_dele) {
        _dele = [[UIButton alloc] init];
        [_dele setBackgroundImage:[UIImage imageNamed:@"stickers_delete"] forState:UIControlStateNormal];
        [_dele addTarget:self action:@selector(deleteTagAction:) forControlEvents:UIControlEventTouchUpInside];
        _dele.userInteractionEnabled = YES;
    }
    return _dele;
}

- (void)deleteTagAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delegateThisTagBtn:)]) {
        [self.delegate delegateThisTagBtn:self.index];
    }
    [self removeFromSuperview];
}

#pragma mark - 动画
-(void)animationTimerDidFired{
    [UIView animateWithDuration:1.5 animations:^{
        viewTapDot.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            viewTapDot.transform = CGAffineTransformIdentity;
        }completion:^(BOOL finished) {
            viewSpread.alpha = 1;
            [UIView animateWithDuration:1.5 animations:^{
                viewSpread.alpha = 0;
                viewSpread.transform = CGAffineTransformMakeScale(8,8);
            }completion:^(BOOL finished) {
                viewSpread.transform = CGAffineTransformIdentity;
            }];
        }];
        
    }];
}

@end
