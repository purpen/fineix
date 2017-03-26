//
//  ChanelView.h
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanelView : UIView
@property (weak, nonatomic) IBOutlet UIView *scenarioView;

@property (weak, nonatomic) IBOutlet UIView *fieldView;
@property (weak, nonatomic) IBOutlet UIView *focusView;
@property (weak, nonatomic) IBOutlet UIView *fansView;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UILabel *fieldNumLabel;//情境数量
@property (weak, nonatomic) IBOutlet UILabel *focusNumLabel;//关注数量
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;//粉丝数量
@property (weak, nonatomic) IBOutlet UIButton *fansBtn;

@property (weak, nonatomic) IBOutlet UIButton *scenceBtn;

+(instancetype)getChanelView;

@end
