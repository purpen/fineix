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

@interface THNMarkGoodsView : UIView <
    FBFootViewDelegate,
    UITextFieldDelegate
>

@pro_strong UIView *bgView;
@pro_strong FBFootView *footView;   //  底部功能选择视图
@pro_strong UIButton *chooseGoods;
@pro_strong UILabel *writeLab;
@pro_strong UITextField *brand;
@pro_strong UITextField *goods;

@end
