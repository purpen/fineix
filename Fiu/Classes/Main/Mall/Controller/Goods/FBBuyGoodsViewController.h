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

@interface FBBuyGoodsViewController : FBViewController <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) FBGoodsInfoModelData    *goodsInfo;
@property (nonatomic, strong) UIView                  *buyView;
@property (nonatomic, strong) UIButton                *cancelBtn;
@property (nonatomic, strong) UIImageView             *goodsImg;
@property (nonatomic, strong) UILabel                 *goodsTitle;
@property (nonatomic, strong) UILabel                 *goodsPrice;
@property (nonatomic, strong) UILabel                 *goodsChoose;
@property (nonatomic, strong) UIView                  *chooseNumView;
@property (nonatomic, strong) UILabel                 *chooseNum;
@property (nonatomic, strong) UICollectionView        *goodsColorView;
@property (nonatomic, strong) NSMutableArray          *goodsSkus;
@property (nonatomic, strong) NSMutableArray          *goodsSkusImage;
@property (nonatomic, strong) UIButton                *addBtn;
@property (nonatomic, strong) UIButton                *subBtn;
@property (nonatomic, strong) NSString                *skuId;
@property (nonatomic, assign) NSInteger                num;
@property (nonatomic, assign) NSInteger                quantity;

@property (nonatomic, strong) GetGoodsInfoModelBlock  getGoodsModel;
@property (nonatomic, strong) BuyingGoodsBlock        buyingGoodsBlock;
@property (nonatomic, strong) AddGoodsCarBlock        addGoodsCarBlock;

/**
 * buyState
 * 1:加入购物车／2:立即购买
 */
@property (nonatomic, assign) NSInteger buyState;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) NSString *storageId;  //  地盘id

@end
