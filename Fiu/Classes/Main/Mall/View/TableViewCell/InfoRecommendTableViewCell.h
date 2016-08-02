//
//  InfoRecommendTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "GoodsRelationProducts.h"

@interface InfoRecommendTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController      *   nav;
@pro_strong UICollectionViewFlowLayout  *   flowLayout;
@pro_strong UILabel                     *   headerTitle;              //  标题
@pro_strong UICollectionView            *   recommendListView;        //  推荐商品的列表
@pro_strong NSMutableArray              *   goodsData;
@pro_strong NSMutableArray              *   goodsIds;
@pro_assign NSInteger                       type;

/**
 *  type
 *  0:goods
 *  1:thnGoods
 */
- (void)setRecommendGoodsData:(NSMutableArray *)model withType:(NSInteger)type;

@end
