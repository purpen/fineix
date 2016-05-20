//
//  NearChangViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class FiuSceneInfoData;

@interface NearChangViewController : FBViewController

@property(nonatomic,strong) FiuSceneInfoData *baseInfo;
@property(nonatomic,strong) UIButton *positioningBtn;
@property(nonatomic,strong) UIButton *searchBtn;

@end
