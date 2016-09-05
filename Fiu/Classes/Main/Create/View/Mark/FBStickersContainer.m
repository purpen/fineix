//
//  FBStickersContainer.m
//  Fiu
//
//  Created by FLYang on 16/5/12.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBStickersContainer.h"

@interface FBStickersContainer () {
    UIButton            *   _deleteControl;
    UIImageView         *   _resizingControl;
    CGFloat                 _startAngle;
    CGPoint                 _prevPos;
    CGPoint                 _prevPosInSelf;
    UIImageView         *   _stickerView;
    UIView              *   _borderView;
    CGAffineTransform       _transForm;
    CGPoint                 startPoint;
    CGFloat                 _diffAngle;
    CGPoint                 _translateCenter;
    BOOL _isResizing;
}

@end

@implementation FBStickersContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBasicParam];
    }
    return self;
}

- (void)setupBasicParam {
    self.userInteractionEnabled = YES;
    //  删除
    _deleteControl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    [_deleteControl setBackgroundImage:[UIImage imageNamed:@"stickers_delete"] forState:UIControlStateNormal];
    [_deleteControl addTarget:self action:@selector(deleteControlAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteControl.userInteractionEnabled = YES;
    
    //  缩放
    _resizingControl = [[UIImageView alloc] init];
    _resizingControl.image = [UIImage imageNamed:@"stickers_ zoom"];
    UIPanGestureRecognizer * resizingGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizingControlAction:)];
    [_resizingControl addGestureRecognizer:resizingGR];
    _resizingControl.userInteractionEnabled = YES;
    
    //  图片
    _stickerView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_deleteControl.frame) / 2 ,CGRectGetHeight(_deleteControl.frame) / 2, self.frame.size.width - (CGRectGetWidth(_deleteControl.frame) / 2 + CGRectGetWidth(_resizingControl.frame) / 2) - 11, self.frame.size.height - (CGRectGetHeight(_deleteControl.frame) / 2 + CGRectGetHeight(_resizingControl.frame) / 2) - 11)];
    _stickerView.layer.borderWidth = 0.7f;
    _stickerView.layer.borderColor = [UIColor colorWithHexString:@"#666666" alpha:.9].CGColor;
    _stickerView.contentMode = UIViewContentModeScaleToFill;
    _stickerView.userInteractionEnabled = YES;

    [self addSubview:_stickerView];
    [self addSubview:_deleteControl];
    [self addSubview:_resizingControl];
    [_resizingControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(22, 22));
        make.bottom.equalTo(_stickerView.mas_bottom).with.offset(11);
        make.right.equalTo(_stickerView.mas_right).with.offset(11);
    }];
    
    _startAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                        self.frame.origin.x+self.frame.size.width - self.center.x);
    _translateCenter = self.center;
    _isResizing = NO;
}

- (void)deleteControlAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemoveStickerContainer:)]) {
        [self.delegate didRemoveStickerContainer:self];
    }
    [self removeFromSuperview];
}

- (void)resizingControlAction:(UIPanGestureRecognizer *)gr {
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
        {
            _prevPos = [gr locationInView:self.superview];
            _prevPosInSelf = [gr locationInView:self];
            _isResizing = YES;
            _startAngle = atan2f(_prevPos.y - self.center.y, _prevPos.x - self.center.x);
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint cPosInView = [gr locationInView:self];
            CGFloat diffX = cPosInView.x - _prevPosInSelf.x;
            CGFloat diffY = cPosInView.y - _prevPosInSelf.y;
            CGFloat minDiff = MIN(fabs(diffX), fabs(diffY));
            if (diffX < 0 || diffY < 0) {
                minDiff = - minDiff;
            }
            _prevPosInSelf = cPosInView;
            
            self.bounds = CGRectMake(self.bounds.origin.x - minDiff/2, self.bounds.origin.y - minDiff/2, self.bounds.size.width + minDiff , self.bounds.size.height + minDiff);
            
            _translateCenter = self.center;
            
            _stickerView.frame = CGRectMake(self.bounds.origin.x - minDiff/2 + 11, self.bounds.origin.y - minDiff/2 + 11, self.bounds.size.width + minDiff - 22 , self.bounds.size.height + minDiff - 22);
            
            _resizingControl.frame = CGRectMake(self.bounds.size.width - CGRectGetWidth(_resizingControl.frame), self.bounds.size.height - CGRectGetHeight(_resizingControl.frame), CGRectGetWidth(_resizingControl.frame), CGRectGetHeight(_resizingControl.frame));
            
            [_deleteControl mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_stickerView.mas_top).with.offset(-11);
                make.left.equalTo(_stickerView.mas_left).with.offset(-11);
            }];
            
            CGPoint cPos = [gr locationInView:self.superview];
            CGFloat currentAngle = atan2f(cPos.y - self.center.y, cPos.x - self.center.x);
            _diffAngle =  currentAngle - _startAngle;
            self.transform = CGAffineTransformMakeRotation(_diffAngle);
            _transForm = self.transform;
            _prevPos  = cPos;
            [self layoutIfNeeded];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            _isResizing = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setupSticker:(NSString *)stickerUrl {
    [_stickerView downloadImage:stickerUrl place:[UIImage imageNamed:@""]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _deleteControl.hidden = YES;
    _resizingControl.hidden = YES;
    _stickerView.layer.borderWidth = 0.0f;
    //  保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    startPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //  计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    float dx = point.x - startPoint.x;
    float dy = point.y - startPoint.y;
    
    //  计算移动后的view中心点
    _translateCenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    //  限制用户不可将视图托出屏幕
    float halfx = CGRectGetMidX(self.bounds);
    _translateCenter.x = MAX(halfx - 50, _translateCenter.x);
    _translateCenter.x = MIN(self.superview.bounds.size.width - halfx + 50, _translateCenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    _translateCenter.y = MAX(halfy, _translateCenter.y);
    _translateCenter.y = MIN(self.superview.bounds.size.height - halfy, _translateCenter.y);
    
    //移动view
    self.center = _translateCenter;
    [self setNeedsDisplay];
    startPoint = point;
    
    _deleteControl.hidden = NO;
    _resizingControl.hidden = NO;
    _stickerView.layer.borderWidth = 0.7f;
}

- (FBSticker *)generateSticker {
    FBSticker * sticker = [FBSticker new];
    sticker.rotateAngle = _diffAngle;
    sticker.image = _stickerView.image;
    sticker.translateCenter = _translateCenter;
    sticker.size = _stickerView.frame.size;
    sticker.containerSize = self.bounds.size;
    return sticker;
}

- (void)recoveryFromSticker:(FBSticker *)sticker {
    self.center = sticker.translateCenter;
    self.transform = CGAffineTransformMakeRotation(sticker.rotateAngle);
    _stickerView.image = sticker.image;
    [self setNeedsDisplay];
}

@end
