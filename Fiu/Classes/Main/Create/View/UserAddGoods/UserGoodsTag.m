//
//  UserGoodsTag.m
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "UserGoodsTag.h"
#import "NSTimer+Addition.h"
#import "UIImage+Helper.h"
#import "UILable+Frame.h"

@interface UserGoodsTag () {
    NSTimer *   timerAnimation;
    UIView  *   viewSpread;
    UIView  *   viewTapDot;
    UIView  *   viewMidPoint;
    CGPoint     startPoint;
    CGPoint     _translateCenter;
}

@end

@implementation UserGoodsTag

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.isFlip = NO;
        timerAnimation = [NSTimer scheduledTimerWithTimeInterval:3
                                                          target:self
                                                        selector:@selector(animationTimerDidFired)
                                                        userInfo:nil
                                                         repeats:YES];
    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipTheBackgroundPosition:)];
        [self addGestureRecognizer:tap];
        [self setUI];
    }
    return self;
}

- (void)thn_setSceneImageUserGoodsTagLoc:(NSInteger)loc {
    if (loc == 1) {
        [self.bgBtn setBackgroundImage:[UIImage resizedImage:@"mark_TagImage" xPos:0.2 yPos:0.5] forState:(UIControlStateNormal)];
        [viewTapDot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 6));
            make.top.equalTo(_bgBtn.mas_bottom).with.offset(0);
            make.right.equalTo(_bgBtn.mas_right).with.offset(-18);
        }];
        
    } else if (loc == 2) {
        [self.bgBtn setBackgroundImage:[UIImage resizedImage:@"mark_TagImage" xPos:0.8 yPos:0.5] forState:(UIControlStateNormal)];
        [viewTapDot mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 6));
            make.top.equalTo(_bgBtn.mas_bottom).with.offset(0);
            make.left.equalTo(_bgBtn.mas_left).with.offset(19);
        }];
    }
}

- (void)flipTheBackgroundPosition:(UITapGestureRecognizer *)tap {
    if (self.isFlip == NO) {
        self.isFlip = YES;
        [UIView animateWithDuration:.3 animations:^{
            [self.bgBtn setBackgroundImage:[UIImage resizedImage:@"mark_TagImage" xPos:0.8 yPos:0.5] forState:(UIControlStateNormal)];
            [viewTapDot mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(6, 6));
                make.top.equalTo(_bgBtn.mas_bottom).with.offset(0);
                make.left.equalTo(_bgBtn.mas_left).with.offset(19);
            }];
            
            [self layoutIfNeeded];
        }];
        
    } else if (self.isFlip == YES){
        self.isFlip = NO;
        [UIView animateWithDuration:.3 animations:^{
            [self.bgBtn setBackgroundImage:[UIImage resizedImage:@"mark_TagImage" xPos:0.2 yPos:0.5] forState:(UIControlStateNormal)];
            [viewTapDot mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(6, 6));
                make.top.equalTo(_bgBtn.mas_bottom).with.offset(0);
                make.right.equalTo(_bgBtn.mas_right).with.offset(-18);
            }];
            
            [self layoutIfNeeded];
        }];
    }
    
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
        _translateCenter.x = MAX(halfx + 10, _translateCenter.x);
        _translateCenter.x = MIN(self.superview.bounds.size.width - halfx - 10, _translateCenter.x);
        
        float halfy = CGRectGetMidY(self.bounds);
        _translateCenter.y = MAX(halfy + 10, _translateCenter.y);
        _translateCenter.y = MIN(self.superview.bounds.size.height - halfy - 10, _translateCenter.y);
        
        //移动view
        self.center = _translateCenter;
        [self setNeedsDisplay];
        startPoint = point;
    }
}

- (void)userTag_SetGoodsInfo:(NSString *)text {
    self.title.text = text;
    CGFloat width = [self.title boundingRectWithSize:CGSizeMake(320, 0)].width;
    if (width*1.5 > SCREEN_WIDTH/2) {
        width = SCREEN_WIDTH/2;
    } else {
        width = [self.title boundingRectWithSize:CGSizeMake(320, 0)].width * 1.5;
    }
    
    int tagX = (arc4random() % 4) * 30;
    int tagY = ((arc4random() % 2) + 10) * 20;
    self.frame = CGRectMake(tagX, tagY, width + 25, 32);

    [self.bgBtn setBackgroundImage:[UIImage resizedImage:@"mark_TagImage" xPos:0.2 yPos:0.5] forState:(UIControlStateNormal)];
}

#pragma mark - 设置视图
- (void)setUI {
    [self addSubview:self.bgBtn];
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(25);
    }];
    
    [self.bgBtn addSubview:self.title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(_bgBtn).with.offset(-5);
        make.left.equalTo(_bgBtn.mas_left).with.offset(5);
        make.top.equalTo(_bgBtn.mas_top).with.offset(0);
    }];
    
    [self addSubview:self.dele];
    [_dele mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.top.equalTo(self.mas_top).with.offset(2);
        make.left.equalTo(self.mas_left).with.offset(0);
    }];
    
    viewTapDot = [self getViewTapDot];
    self.posPoint = viewTapDot;
    [self addSubview:viewTapDot];
    [viewTapDot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.top.equalTo(_bgBtn.mas_bottom).with.offset(0);
        if (self.isFlip == NO) {
            make.right.equalTo(_bgBtn.mas_right).with.offset(-18);
        } else {
            make.left.equalTo(_bgBtn.mas_left).with.offset(19);
        }
    }];
    
    viewSpread = [self getViewSpread];
    [self addSubview:viewSpread];
    [viewSpread mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.centerY.equalTo(viewTapDot);
        make.centerX.equalTo(viewTapDot);
    }];
    
    viewMidPoint = [self getViewMidPoint];
    [self addSubview:viewMidPoint];
    [viewMidPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(6, 6));
        make.centerY.equalTo(viewTapDot);
        make.centerX.equalTo(viewTapDot);
    }];
    
    [timerAnimation resumeTimer];
}

- (UIButton *)bgBtn {
    if (!_bgBtn) {
        _bgBtn = [[UIButton alloc] init];
        _bgBtn.userInteractionEnabled = NO;
    }
    return _bgBtn;
}

#pragma mark - 标题
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
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
        if (IS_iOS9) {
            _price.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        } else {
            _price.font = [UIFont systemFontOfSize:12];
        }
        _price.textAlignment = NSTextAlignmentCenter;
    }
    return _price;
}

#pragma mark - 圆点
- (UIView *)getViewSpread {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.9];
    view.layer.cornerRadius = 6/2;
    view.layer.masksToBounds = YES;
    view.userInteractionEnabled=NO;
    return view;
}

- (UIView *)getViewTapDot {
    UIView * view =[UIView new];
    view.backgroundColor= [UIColor colorWithHexString:@"#FFFFFF" alpha:0.3];
    view.layer.cornerRadius = 6/2;
    view.layer.masksToBounds = YES;
    view.userInteractionEnabled=NO;
    return view;
}

- (UIView *)getViewMidPoint {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor colorWithHexString:fineixColor alpha:0.8];
    view.layer.cornerRadius = 6/2;
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
        [self.delegate delegateThisTagBtn:self];
    }
    [self removeFromSuperview];
}

#pragma mark - 动画
- (void)animationTimerDidFired {
    [UIView animateWithDuration:1.5 animations:^{
        viewTapDot.transform = CGAffineTransformMakeScale(5,5);
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
