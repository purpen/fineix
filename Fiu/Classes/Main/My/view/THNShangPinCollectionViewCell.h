//
//  THNShangPinCollectionViewCell.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define THNSHANGPinCollectionViewCell @"THNShangPinCollectionViewCell"

@interface THNShangPinCollectionViewCell : UITableViewCell

@property (nonatomic, strong) UITableView *tableview;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) UINavigationController *nav;

@end

#define CELL @"Cell"

@class THNProductDongModel;

@interface Cell : UITableViewCell

@property (nonatomic, strong) THNProductDongModel *model;
/**  */
@property (nonatomic, strong) UIView *lineView;

@end
