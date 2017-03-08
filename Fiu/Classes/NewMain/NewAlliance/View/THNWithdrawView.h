//
//  THNWithdrawView.h
//  Fiu
//
//  Created by FLYang on 2017/1/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"


@interface THNWithdrawView : UIView <
    UITextFieldDelegate
>

@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UILabel *rmbLabel;
@property (nonatomic, strong) UITextField *moneyTextField;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UILabel *maxMoneyLabel;
@property (nonatomic, strong) UIButton *allMoneyBtn;

- (void)thn_setCanWithdrawMoneyData:(CGFloat)money;

@end
