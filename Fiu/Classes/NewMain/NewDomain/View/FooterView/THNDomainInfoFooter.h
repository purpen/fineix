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
#import "DominInfoData.h"
#import "THNShangJiaLocationMapView.h"

@interface THNDomainInfoFooter : UIView <
    UITableViewDelegate,
    UITableViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    SGTopTitleViewDelegate
>

@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) SGTopTitleView *menuView;
@property (nonatomic, strong) UIScrollView *rollView;
@property (nonatomic, strong) UITableView *sceneTable;
@property (nonatomic, strong) UICollectionView *goodsList;
@property (nonatomic, strong) UITableView *infoTable;
@property (nonatomic, strong) UILabel *backLabel;
@property (nonatomic, strong) UIView *commentView;
@property (nonatomic, strong) THNShangJiaLocationMapView *mapView;
@property (nonatomic, strong) UIView *creatSceneView;
@property (nonatomic, strong) DominInfoData *infoModel;

@property (nonatomic, strong) FBRequest *sceneListRequest;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) NSMutableArray *userIdMarr;
@property (nonatomic, assign) NSInteger sceneCurrentpage;
@property (nonatomic, assign) NSInteger sceneTotalPage;

@property (nonatomic, strong) FBRequest *goodsListRequest;
@property (nonatomic, strong) NSMutableArray *goodsListMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;
@property (nonatomic, strong) NSMutableArray *goodsMarr;
@property (nonatomic, assign) NSInteger currentpageNum;
@property (nonatomic, assign) NSInteger totalPageNum;

@property (nonatomic, strong) UIButton *fineButton;
@property (nonatomic, strong) UIButton *nowButton;

- (void)thn_setDomainInfo:(DominInfoData *)model;

- (void)thn_tableViewStartRolling:(BOOL)roll;

@end
