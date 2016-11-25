//
//  THNApplyRefundView.m
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNApplyRefundView.h"

static NSInteger const textFieldTag = 757;

@interface THNApplyRefundView () {
    NSArray *_titleArr;
    NSArray *_placeholderArr;
}

@end

@implementation THNApplyRefundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self set_viewUI];
    }
    return self;
}

- (void)set_viewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
}

- (void)thn_setRefundInfoData:(NSDictionary *)data {
    [self thn_setRefundPrice:[[data valueForKey:@"refund_price"] floatValue]];
    
}

//  设置退款金额
- (void)thn_setRefundPrice:(CGFloat)price {
    UITextField *textField = (UITextField *)[self viewWithTag:textFieldTag];
    textField.text = [NSString stringWithFormat:@"￥%.2f", price];
    textField.userInteractionEnabled = NO;
}

- (NSArray *)thn_setShowType:(NSInteger)type {
    if (type == 1) {
        _titleArr = @[@"退款金额", @"退款原因", @"退款说明"];
        _placeholderArr = @[@"", @"请选择退款原因", @"请输入退款说明"];
    } else if (type == 2) {
        _titleArr = @[@"退款金额", @"退货原因", @"退货说明"];
        _placeholderArr = @[@"", @"请选择退货原因", @"请输入退货说明"];
    }
    
    [self set_defaultTextLable];
    [self set_defaultTextField];
    
    return _titleArr;
}

- (void)set_defaultTextLable {
    for (NSUInteger idx = 0; idx < _titleArr.count; ++ idx) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15 + 80 * idx, 100, 15)];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithHexString:@"#666666"];
        lab.text = _titleArr[idx];
        [self addSubview:lab];
    }
}

- (void)set_defaultTextField {
    for (NSUInteger idx = 0; idx < _titleArr.count; ++ idx) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 35 + 80 * idx, SCREEN_WIDTH - 30, 44)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = [UIColor colorWithHexString:@"#222222"];
        textField.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC" alpha:.5].CGColor;
        textField.layer.borderWidth = 0.5f;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.placeholder = _placeholderArr[idx];
        textField.tag = textFieldTag + idx;
        [self addSubview:textField];
    }
}

@end
