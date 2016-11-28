//
//  THNStateHeaderView.m
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNStateHeaderView.h"

static NSString *const waitText = @"退款申请已提交，客服会尽快与您联系";
static NSString *const returnWaitText = @"退货申请已提交，客服会尽快与您联系";
static NSString *const doneText = @"退款成功";
static NSString *const refuseText = @"商家已拒绝，请与客服联系";

@implementation THNStateHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_cellViewUI];
    }
    return self;
}

- (void)thn_setRefundStage:(RefundStage)stage withSummary:(NSString *)summary type:(NSInteger)type {
    switch (stage) {
        case RefundWait:
            if (type == 1) {
                self.stageLab.text = waitText;
            } else if (type == 2){
                self.stageLab.text = returnWaitText;
            }
            break;
            
        case RefundDone:
            self.stageLab.text = doneText;
            break;
            
        case RefundRefuse:
            self.stageLab.text = refuseText;
            [self showSummaryText:summary];
            break;
            
        default:
            break;
    }
    self.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"refund_stage_%zi", stage]];
}

- (void)set_cellViewUI {
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.centerY.equalTo(self).with.offset(-5);
    }];
    
    [self addSubview:self.stageLab];
    [_stageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.left.equalTo(_icon.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.centerY.equalTo(_icon);
    }];
    
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 10)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    [self addSubview:bottomLine];
}

- (void)showSummaryText:(NSString *)text {
    self.summaryLab.text = text;
    [self addSubview:self.summaryLab];
    [_summaryLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@12);
        make.left.equalTo(_icon.mas_right).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.top.equalTo(_stageLab.mas_bottom).with.offset(5);
    }];
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _icon;
}

- (UILabel *)stageLab {
    if (!_stageLab) {
        _stageLab = [[UILabel alloc] init];
        _stageLab.font = [UIFont boldSystemFontOfSize:14];
        _stageLab.textColor = [UIColor colorWithHexString:@"#222222"];
    }
    return _stageLab;
}

- (UILabel *)summaryLab {
    if (!_summaryLab) {
        _summaryLab = [[UILabel alloc] init];
        _summaryLab.font = [UIFont systemFontOfSize:12];
        _summaryLab.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _summaryLab;
}

@end
