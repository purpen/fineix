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

typedef void(^AddBrandInfoDoneBlock)(NSString *brand, NSString *brandId, NSString *goods, NSString *goodsId);
typedef void(^AddGoodsInfoDoneBlock)(NSString *goods, NSString *goodsId);

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

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) FBFootView *footView;   //  底部功能选择视图
@property (nonatomic, strong) UIButton *chooseGoods;
@property (nonatomic, strong) UILabel *writeLab;
@property (nonatomic, strong) UITextField *brand;
@property (nonatomic, strong) UITextField *goods;
@property (nonatomic, weak) id <THNMarkGoodsViewDelegate> delegate;
@property (nonatomic, copy) AddBrandInfoDoneBlock addBrandInfoDoneBlock;
@property (nonatomic, copy) AddGoodsInfoDoneBlock addGoodsInfoDoneBlock;

@end
