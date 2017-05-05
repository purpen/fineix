//
//  THNChildHeaderView.h
//  Fiu
//
//  Created by FLYang on 2017/4/27.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNChildHeaderView : UIView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

- (void)thn_setChildUserEarningsMoney:(CGFloat)money;

@end
