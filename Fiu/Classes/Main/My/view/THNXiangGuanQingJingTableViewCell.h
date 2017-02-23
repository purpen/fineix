//
//  THNXiangGuanQingJingTableViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"

#define THNXIANGGuanQingJingTableViewCell @"THNXiangGuanQingJingTableViewCell"

@interface THNXiangGuanQingJingTableViewCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;
/**  */
@property (nonatomic, strong) NSMutableArray *modelAry;
/**  */
@property (nonatomic, strong) UINavigationController *nav;
/**  */
@property(nonatomic,copy) NSString *string;

@end
