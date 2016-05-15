//
//  FiuPeopleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "FiuPeopleUser.h"
#import "FiuBrandRow.h"

@interface FiuPeopleTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@pro_strong UINavigationController  *   nav;
@pro_strong UICollectionView        *   peopleView;
@pro_strong NSMutableArray          *   headerMarr;
@pro_strong NSArray                 *   widthArr;
@pro_assign CGFloat                     width;
@pro_strong NSMutableArray          *   userIdMarr;

/**
 *  Fiu类型
 *  0:伙伴 
 *  1:品牌
 */
@pro_assign NSInteger                   type;

- (void)setFiuPeopleData:(NSMutableArray *)model withType:(NSInteger)type;

- (void)setFiuBrandData:(NSMutableArray *)model withType:(NSInteger)type;

@end
