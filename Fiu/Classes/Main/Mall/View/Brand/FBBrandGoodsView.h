//
//  FBBrandGoodsView.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "BrandListModel.h"

@interface FBBrandGoodsView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UINavigationController  *   nav;
@property (nonatomic, strong) UICollectionView        *   selfBrandList;
@property (nonatomic, strong) UIButton                *   allselfBrand;

- (void)setBrandData:(NSMutableArray *)dataMarr withIdData:(NSMutableArray *)idMarr;

@end
