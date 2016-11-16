//
//  THNFilterValueView.m
//  Fiu
//
//  Created by FLYang on 2016/11/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNFilterValueView.h"

@implementation THNFilterValueView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.0f];
        [self setViewUI];
    }
    return self;
}

- (void)setViewUI {
    [self addSubview:self.valueTitle];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.sliderBack];
}

- (UILabel *)valueTitle {
    if (!_valueTitle) {
        _valueTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _valueTitle.backgroundColor = [UIColor colorWithHexString:@"#222222"];
        _valueTitle.textAlignment = NSTextAlignmentCenter;
        _valueTitle.font = [UIFont systemFontOfSize:17];
        _valueTitle.textColor = [UIColor whiteColor];
    }
    return _valueTitle;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH/2, 45)];
        _cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#25272A"];
        [_cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelBtn;
}

- (void)cancelBtnClick:(UIButton *)button {
    self.hidden = YES;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 45, SCREEN_WIDTH/2, 45)];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#25272A"];
        [_sureBtn setImage:[UIImage imageNamed:@"icon_sure"] forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

- (void)sureBtnClick:(UIButton *)button {
    self.hidden = YES;
}

- (UIView *)sliderBack {
    if (!_sliderBack) {
        _sliderBack = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 165 , SCREEN_WIDTH, 120)];
        _sliderBack.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        
        [_sliderBack addSubview:self.valueSlider];
    }
    return _sliderBack;
}

- (UISlider *)valueSlider {
    if (!_valueSlider) {
        _valueSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 120)];
        _valueSlider.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _valueSlider.minimumTrackTintColor = [UIColor colorWithHexString:MAIN_COLOR];
        _valueSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#333333"];
        _valueSlider.minimumValue = 0;
        _valueSlider.maximumValue = 100;
        _valueSlider.value = 50;
        [_valueSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _valueSlider;
}

- (void)updateSliderValue:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_changeImageFilterValue:)]) {
        [self.delegate thn_changeImageFilterValue:self.valueSlider.value];
    }
}

- (void)thn_setSliderWithType:(NSInteger)type filterImage:(FSFliterImage *)filterImage {
    CGFloat MaxValue,MinValue,CurrentValue;
    switch (type) {
        case 0:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = filterImage.lightValue;
            
        }
            break;
        case 1:
        {
            MaxValue = 4.0;
            MinValue = 0;
            CurrentValue = filterImage.contrastValue;
        }
            break;
        case 2:
        {
            MaxValue = 2.0;
            MinValue = 0;
            CurrentValue = filterImage.staurationValue;
        }
            break;
        case 3:
        {
            MaxValue = 4.0;
            MinValue = -4.0;
            CurrentValue = filterImage.sharpnessValue;
        }
            break;
        case 4:
        {
            MaxValue = 10000;
            MinValue = 1000;
            CurrentValue = filterImage.colorTemperatureValue;
        }
            break;
        default:
            break;
    }
    self.valueSlider.maximumValue = MaxValue;
    self.valueSlider.minimumValue = MinValue;
    self.valueSlider.value = CurrentValue;
}

@end
