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
@property (weak, nonatomic) IBOutlet UILabel *scenarioNumLabel;//情景数量
@property (weak, nonatomic) IBOutlet UILabel *fieldNumLabel;//场景数量
@property (weak, nonatomic) IBOutlet UILabel *focusNumLabel;//关注数量
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;//粉丝数量


+(instancetype)getChanelView;

@end
