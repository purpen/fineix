//
//  FBBuyGoodsViewController.h
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "FBGoodsInfoModelData.h"

typedef void(^GetGoodsInfoModelBlock)(FBGoodsInfoModelData * model);
typedef void(^BuyingGoodsBlock)(NSDictionary * orderData);
typedef void(^AddGoodsCarBlock)(NSDictionary * addCarGoodsData);

@interface FBBuyGoodsViewController : FBViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong FBGoodsInfoModelData       *   goodsInfo;
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
@pro_assign NSInteger               num;
@pro_assign NSInteger               quantity;
@pro_strong UIButton            *   addBtn;
@pro_strong UIButton            *   subBtn;
@pro_strong NSString            *   skuId;

@pro_strong GetGoodsInfoModelBlock  getGoodsModel;
@pro_strong BuyingGoodsBlock        buyingGoodsBlock;
@pro_strong AddGoodsCarBlock        addGoodsCarBlock;

@end
