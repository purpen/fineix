//
//  FBBuyGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "GoodsInfoData.h"

typedef void(^GetGoodsInfoModelBlock)(GoodsInfoData * model);

@interface FBBuyGoodsViewController : FBViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong GoodsInfoData       *   goodsInfo;
@pro_strong UIView              *   buyView;
@pro_strong UIButton            *   cancelBtn;
@pro_strong UIImageView         *   goodsImg;
@pro_strong UILabel             *   goodsTitle;
@pro_strong UILabel             *   goodsPrice;
@pro_strong UILabel             *   goodsChoose;
@pro_strong UIView              *   chooseNumView;
@pro_strong UILabel             *   chooseNum;
@pro_strong UIButton            *   buyingBtn;
@pro_strong UIButton            *   addCarBtn;
@pro_strong UICollectionView    *   goodsColorView;
@pro_strong NSMutableArray      *   goodsSkus;

@pro_strong GetGoodsInfoModelBlock getGoodsModel;

@end
