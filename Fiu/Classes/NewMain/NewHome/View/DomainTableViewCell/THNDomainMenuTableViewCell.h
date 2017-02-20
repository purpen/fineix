//
//  THNDomainMenuTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNDomainMenuTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UICollectionView *menuCollectionView;
@property (nonatomic, strong) NSMutableArray *menuMarr;
@property (nonatomic, strong) NSMutableArray *menuIdMarr;

- (void)setDomainMenuModelArr:(NSMutableArray *)data;

@end
