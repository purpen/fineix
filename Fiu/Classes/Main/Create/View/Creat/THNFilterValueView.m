//
//  THNFilterValueView.m
//  Fiu
//
//  Created by FLYang on 2016/11/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNFilterValueView.h"

static const CGFloat MAX_VALUE = 100.0f;
static const CGFloat MIN_VALUE = 0.0f;
static const CGFloat DEFAULT_VALUE = 50.0f;

@interface THNFilterValueView () {
    NSInteger _type;
}

@end

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
    if ([self.delegate respondsToSelector:@selector(thn_cancelChangeFilterValue)]) {
        [self.delegate thn_cancelChangeFilterValue];
    }
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
    if ([self.delegate respondsToSelector:@selector(thn_sureChangeFilterValue:)]) {
        [self.delegate thn_sureChangeFilterValue:self.valueSlider.value];
    }
}

- (UIView *)sliderBack {
    if (!_sliderBack) {
        _sliderBack = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 165 , SCREEN_WIDTH, 120)];
        _sliderBack.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
        
        [_sliderBack addSubview:self.valueSlider];
        [_sliderBack addSubview:self.valueShowLab];
    }
    return _sliderBack;
}

- (UILabel *)valueShowLab {
    if (!_valueShowLab) {
        _valueShowLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, 30)];
        _valueShowLab.textColor = [UIColor whiteColor];
        _valueShowLab.font = [UIFont boldSystemFontOfSize:16];
        _valueShowLab.textAlignment = NSTextAlignmentCenter;
    }
    return _valueShowLab;
}

- (UISlider *)valueSlider {
    if (!_valueSlider) {
        _valueSlider = [[UISlider alloc] initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH - 60, 120)];
        _valueSlider.thumbTintColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _valueSlider.minimumTrackTintColor = [UIColor colorWithHexString:MAIN_COLOR];
        _valueSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#333333"];
        _valueSlider.minimumValue = MIN_VALUE;
        _valueSlider.maximumValue = MAX_VALUE;
        _valueSlider.value = DEFAULT_VALUE;
        [_valueSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _valueSlider;
}

- (void)updateSliderValue:(id)sender {
    [self thn_changeShowValueTextWithType:_type value:self.valueSlider.value];
    if (self.delegate && [self.delegate respondsToSelector:@selector(thn_changeImageFilterValue:)]) {
        [self.delegate thn_changeImageFilterValue:self.valueSlider.value];
    }
}

- (void)thn_setSliderWithType:(NSInteger)type filterImage:(FSFliterImage *)filterImage {
    _type = type;
    CGFloat MaxValue,MinValue,CurrentValue;
    switch (type) {
        case 0:
        {
            MaxValue = 1.0;
            MinValue = -1.0;
            CurrentValue = filterImage.lightValue;
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", CurrentValue *100];
            
        }
            break;
        case 1:
        {
            MaxValue = 4.0;
            MinValue = 0;
            CurrentValue = filterImage.contrastValue;
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", CurrentValue *25];
        }
            break;
        case 2:
        {
            MaxValue = 2.0;
            MinValue = 0;
            CurrentValue = filterImage.staurationValue;
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", CurrentValue *50];
        }
            break;
        case 3:
        {
            MaxValue = 4.0;
            MinValue = -4.0;
            CurrentValue = filterImage.sharpnessValue;
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", CurrentValue *25];
        }
            break;
        case 4:
        {
            MaxValue = 10000;
            MinValue = 1000;
            CurrentValue = filterImage.colorTemperatureValue;
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", CurrentValue /100];
        }
            break;
        default:
            break;
    }
    self.valueSlider.maximumValue = MaxValue;
    self.valueSlider.minimumValue = MinValue;
    self.valueSlider.value = CurrentValue;
}

- (void)thn_changeShowValueTextWithType:(NSInteger)type value:(CGFloat)value {
    switch (type) {
        case 0:
        {
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", value *100];
        }
            break;
        case 1:
        {
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", value *25];
        }
            break;
        case 2:
        {
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", value *50];
        }
            break;
        case 3:
        {
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", value *25];
        }
            break;
        case 4:
        {
            self.valueShowLab.text = [NSString stringWithFormat:@"%.0f", value /100];
        }
            break;
        default:
            break;
    }
}

@end
