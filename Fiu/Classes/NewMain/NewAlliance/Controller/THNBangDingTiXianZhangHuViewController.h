//
//  THNBangDingTiXianZhangHuViewController.h
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNZhangHuView.h"
#import "THNZhangHuModel.h"

@protocol THNBangDingTiXianZhangHuViewControllerDelaget <NSObject>

-(void)setBangZhangHu:(ZhangHu)zhangHu andModel:(THNZhangHuModel*)model;

@end

@interface THNBangDingTiXianZhangHuViewController : THNViewController

@property (nonatomic, assign) ZhangHu zhangHu;
/**  */
@property (nonatomic, weak) id<THNBangDingTiXianZhangHuViewControllerDelaget> bangDingDelegate;

@end
