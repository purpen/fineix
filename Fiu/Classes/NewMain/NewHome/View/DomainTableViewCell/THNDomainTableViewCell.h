//
//  THNDomainTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "NiceDomainRow.h"
#import "HelpUserRow.h"

typedef void(^OpenUserHelp)(NSString *idx);

@interface THNDomainTableViewCell : UITableViewCell <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UICollectionView *domainCollectionView;
@property (nonatomic, strong) NSMutableArray *domainMarr;
@property (nonatomic, strong) NSMutableArray *domainIdMarr;
@property (nonatomic, strong) NSMutableArray *userHelpMarr;
@property (nonatomic, strong) NSMutableArray *userHelpIdMarr;
@property (nonatomic, copy) OpenUserHelp openUserHelp;

/**
 数据赋值

 @param data model数组
 @param type 赋值的类型 0:新人／1:推荐地盘
 */
- (void)thn_setUserHelpModelArr:(NSMutableArray *)data type:(NSInteger)type;
- (void)thn_setDomainModelArr:(NSMutableArray *)data type:(NSInteger)type;

@end
