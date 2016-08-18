//
//  THNMarkGoodsView.h
//  Fiu
//
//  Created by FLYang on 16/8/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "FBFootView.h"

typedef void(^AddBrandInfoDoneBlock)(NSString *brand, NSString *goods);

@protocol THNMarkGoodsViewDelegate <NSObject>

@optional
- (void)mark_AddBands;
- (void)mark_AddGoods;
- (void)mark_GoodsImageAndInfo;

@end

@interface THNMarkGoodsView : UIView <
    FBFootViewDelegate,
    UITextFieldDelegate
>

@pro_strong UIViewController *vc;
@pro_strong UIView *bgView;
@pro_strong FBFootView *footView;   //  底部功能选择视图
@pro_strong UIButton *chooseGoods;
@pro_strong UILabel *writeLab;
@pro_strong UITextField *brand;
@pro_strong UITextField *goods;
@pro_weak id <THNMarkGoodsViewDelegate> delegate;
@pro_copy AddBrandInfoDoneBlock addBrandInfoDoneBlock;

@end
