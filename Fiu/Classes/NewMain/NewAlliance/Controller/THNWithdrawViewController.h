//
//  THNWithdrawViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/16.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNWithdrawView.h"
#import "THNAllinaceData.h"

@interface THNWithdrawViewController : THNViewController

@property (nonatomic, strong) THNAllinaceData *dataModel;
@property (nonatomic, strong) FBRequest *alianceRequest;
@property (nonatomic, strong) FBRequest *applyRequest;
@property (nonatomic, strong) THNWithdrawView *withdrawView;
@property (nonatomic, strong) UIButton *sureButton;

@end
