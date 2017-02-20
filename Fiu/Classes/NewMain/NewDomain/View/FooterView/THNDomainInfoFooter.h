//
//  THNDomainInfoFooter.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "SGTopTitleView.h"

@interface THNDomainInfoFooter : UIView <
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    SGTopTitleViewDelegate
>

@property (nonatomic, strong) SGTopTitleView *menuView;
@property (nonatomic, strong) UIScrollView *rollView;
@property (nonatomic, strong) UITableView *sceneTable;
@property (nonatomic, strong) UICollectionView *goodsList;
@property (nonatomic, strong) UITableView *infoTable;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) UIView *mapView;

- (void)thn_setTableViewData:(id)sceneData goods:(id)goodsData info:(id)infoData;

- (void)thn_tableViewStartRolling:(BOOL)roll;

@end
