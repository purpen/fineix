//
//  BotView.h
//  Fiu
//
//  Created by THN-Dong on 16/5/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BotView : UIView

@property (weak, nonatomic) IBOutlet UIButton *optionBtn;
@property (weak, nonatomic) IBOutlet UIButton *qiyeQingdingzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *welfareBtn;

+(instancetype)getBotView;

@end
