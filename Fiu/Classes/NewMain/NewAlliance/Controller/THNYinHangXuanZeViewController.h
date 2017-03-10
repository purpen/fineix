//
//  THNYinHangXuanZeViewController.h
//  Fiu
//
//  Created by THN-Dong on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNYinHangModel.h"

@protocol THNYinHangXuanZeViewControllerDelegate <NSObject>

-(void)setSelectedBank:(THNYinHangModel*)model;

@end

@interface THNYinHangXuanZeViewController : THNViewController
/**  */
@property (nonatomic, weak) id<THNYinHangXuanZeViewControllerDelegate> bankDelegate;

@end
