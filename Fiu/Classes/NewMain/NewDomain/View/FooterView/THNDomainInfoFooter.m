//
//  THNDomainInfoFooter.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoFooter.h"
#import "MallListGoodsCollectionViewCell.h"
#import "THNBusinessInfoTableViewCell.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneDetalViewController.h"
#import "FBGoodsInfoViewController.h"
#import "HomeSceneListRow.h"
#import "GoodsRow.h"
#import "FBRefresh.h"
#import "THNLoginRegisterViewController.h"
#import "PictureToolViewController.h"

static NSString *const URLGoodsList         = @"/sight_and_product/scene_getlist";
static NSString *const URLSceneList         = @"/scene_sight/getlist";
static NSString *const goodsListCellId      = @"MallListGoodsCollectionViewCellId";
static NSString *const infoCellId           = @"THNBusinessInfoTableViewCellId";
static NSString *const commentCellId        = @"commentCellId";
static NSString *const userInfoCellId       = @"UserInfoCellId";
static NSString *const sceneImgCellId       = @"SceneImgCellId";
static NSString *const dataInfoCellId       = @"DataInfoCellId";
static NSString *const sceneInfoCellId      = @"SceneInfoCellId";

static CGFloat const newGoodsCellHeight = ((SCREEN_WIDTH - 45)/2)*1.21;
static NSInteger const tableViewTag     = 2421;
static NSInteger const tableViewCount   = 2;
static NSInteger const actionButtonTag  = 611;

@interface THNDomainInfoFooter () {
    BOOL            _onFooter;
    NSArray         *_leftArr;
    NSMutableArray  *_rightArr;
    NSIndexPath     *_selectedIndexPath;
    CGFloat         _contentHigh;
    CGFloat         _defaultContentHigh;
    NSString        *_domainId;
    NSString        *_sort;
}

@end

@implementation THNDomainInfoFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _leftArr = @[@"营业时间：", @"联系电话：", @"店铺标签："];
        [self setViewUI];
    }
    return self;
}

- (void)thn_setDomainInfo:(DominInfoData *)model {
    NSLog(@"---- 经纬度 ----：%@", model.location.coordinates);
    self.mapView.latitude = [model.location.coordinates[1] floatValue];
    self.mapView.longitude = [model.location.coordinates[0] floatValue];
    [self.mapView setPoint];
    
    //  地盘id
    _domainId = [NSString stringWithFormat:@"%zi", model.idField];
    
    //  商家基本信息
    _rightArr = [NSMutableArray array];
    [_rightArr addObject:model.extra.tel];
    [_rightArr addObject:model.extra.shopHours];
    [_rightArr addObject:[model.tags componentsJoinedByString:@"、"]];
    [self.infoTable reloadData];
    
    //  加载情景列表
    _sort = @"0";
    self.sceneCurrentpage = 0;
    [self addMJRefreshTable:self.sceneTable];
    [self thn_networkDomainSceneList:_domainId sort:_sort];
    
    //  加载商品列表
    self.currentpageNum = 0;
    [self thn_networkGoodsListData:_domainId];
}

#pragma mark - 网络请求情景列表数据
- (void)thn_networkDomainSceneList:(NSString *)domainId sort:(NSString *)sort {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"scene_id":domainId,
                                 @"page":@(self.sceneCurrentpage + 1),
                                 @"size":@"10",
                                 @"sort":sort,
                                 @"use_cache":@"0"};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        
        [self.sceneTable reloadData];
        self.sceneCurrentpage = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.sceneTotalPage = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
         [self requestIsLastData:self.sceneTable currentPage:self.sceneCurrentpage withTotalPage:self.sceneTotalPage];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 网络请求商品列表数据
- (void)thn_networkGoodsListData:(NSString *)domainId {
    [SVProgressHUD show];
    self.goodsListRequest = [FBAPI getWithUrlString:URLGoodsList requestDictionary:@{@"page":@(self.currentpageNum + 1),
                                                                                     @"size":@"10",
                                                                                     @"scene_id":domainId} delegate:self];
    [self.goodsListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"product"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow *goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsListMarr addObject:goodsModel];
            [self.goodsIdMarr addObject:[NSString stringWithFormat:@"%zi",goodsModel.idField]];
        }
        
        [self.goodsList reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.goodsList currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 是否分页加载
- (void)requestIsLastData:(UIScrollView *)scrollView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (scrollView.mj_footer.state == MJRefreshStateNoMoreData) {
            [scrollView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        scrollView.mj_footer.state = MJRefreshStateNoMoreData;
        scrollView.mj_footer.hidden = true;
    }

    if ([scrollView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [scrollView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [scrollView.mj_footer endRefreshing];
        }
    }
}

#pragma mark - 上拉加载
- (void)addMJRefresh:(UICollectionView *)collectionView {
    collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self thn_networkGoodsListData:_domainId];
        } else {
            [collectionView.mj_footer endRefreshing];
        }
    }];
}

- (void)addMJRefreshTable:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.sceneCurrentpage < self.sceneTotalPage) {
            [self thn_networkDomainSceneList:_domainId sort:_sort];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 监测列表是否可滚动
- (void)thn_tableViewStartRolling:(BOOL)roll {
    self.sceneTable.scrollEnabled = roll;
    self.goodsList.scrollEnabled = roll;
    self.infoTable.scrollEnabled = roll;
}

#pragma mark - 设置界面UI
- (void)setViewUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self addSubview:self.menuView];
    
    [self addSubview:self.rollView];
    [_rollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(44);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
    
    [self creatTableViewCount:tableViewCount];
    [self.rollView addSubview:self.goodsList];
    [_goodsList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.equalTo(_rollView.mas_left).with.offset(SCREEN_WIDTH);
        make.top.equalTo(self.mas_top).with.offset(50);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
    }];
}

#pragma mark - 商家信息头部地图视图
- (UIView *)mapView {
    if (!_mapView) {
        _mapView = [[THNShangJiaLocationMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    }
    return _mapView;
}

#pragma mark - 创建情景头部视图
- (UIView *)creatSceneView {
    if (!_creatSceneView) {
        _creatSceneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        _creatSceneView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        UIButton *creatButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105, 12.5, 90, 30)];
        [creatButton setTitle:@"＋上传情境" forState:(UIControlStateNormal)];
        creatButton.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        [creatButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        creatButton.titleLabel.font = [UIFont systemFontOfSize:14];
        creatButton.layer.cornerRadius = 3;
        [creatButton addTarget:self action:@selector(creatButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_creatSceneView addSubview:creatButton];
        
        NSArray *sortArr = @[@"推荐", @"最新"];
        for (NSInteger idx = 0; idx < sortArr.count; ++ idx) {
            UIButton *actionBtn = [[UIButton alloc] init];
            [actionBtn setTitle:sortArr[idx] forState:(UIControlStateNormal)];
            [actionBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
            [actionBtn setTitleColor:[UIColor colorWithHexString:MAIN_COLOR] forState:(UIControlStateSelected)];
            actionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            actionBtn.tag = actionButtonTag + idx;
            if (actionBtn.tag == actionButtonTag) {
                actionBtn.selected = YES;
                self.fineButton = actionBtn;
                [self.fineButton addTarget:self action:@selector(fineActionClick:) forControlEvents:(UIControlEventTouchUpInside)];
            } else {
                actionBtn.selected = NO;
                self.nowButton = actionBtn;
                [self.nowButton addTarget:self action:@selector(nowActionClick:) forControlEvents:(UIControlEventTouchUpInside)];
            }
            [_creatSceneView addSubview:actionBtn];
            [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(40, 50));
                make.left.equalTo(_creatSceneView.mas_left).with.offset(15 + (40 * idx));
                make.centerY.equalTo(creatButton);
            }];
        }
    }
    return _creatSceneView;
}

#pragma mark 情景排序
- (void)fineActionClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.nowButton.selected = NO;
        [self thn_sortSceneList:@"1"];
    }
}

- (void)nowActionClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        self.fineButton.selected = NO;
        [self thn_sortSceneList:@"0"];
    }
}

- (void)thn_sortSceneList:(NSString *)sort {
    _sort = sort;
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    self.sceneCurrentpage = 0;
    [self thn_networkDomainSceneList:_domainId sort:sort];
}

#pragma mark - 上传情境
- (void)creatButtonClick:(UIButton *)button {
    if ([self thn_userIsLogin]) {
        PictureToolViewController *pictureToolVC = [[PictureToolViewController alloc] init];
        pictureToolVC.domainId = _domainId;
        [self.vc presentViewController:pictureToolVC animated:YES completion:nil];
    } else {
        THNLoginRegisterViewController *loginSignupVC = [[THNLoginRegisterViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
        [self.vc presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark - 用户是否登录账户
- (BOOL)thn_userIsLogin {
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest *request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        entity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
    
    return entity.isLogin;
}

#pragma mark - 地盘评价头部视图
- (UIView *)commentView {
    if (!_commentView) {
        _commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _commentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17.5, 100, 15)];
        leftLabel.text = @"用户评价";
        leftLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        [_commentView addSubview:leftLabel];
        
        UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 105, 10, 90, 30)];
        [sendButton setTitle:@"发表评价" forState:(UIControlStateNormal)];
        sendButton.backgroundColor = [UIColor colorWithHexString:MAIN_COLOR];
        [sendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        sendButton.layer.cornerRadius = 3;
        [_commentView addSubview:sendButton];
    }
    return _commentView;
}

#pragma mark - tab切换按钮
- (SGTopTitleView *)menuView {
    if (!_menuView) {
        _menuView = [[SGTopTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _menuView.staticTitleArr = @[@"相关情景", @"相关产品", @"商家信息"];
        _menuView.backgroundColor = [UIColor whiteColor];
        _menuView.delegate_SG = self;
        [_menuView staticTitleLabelSelecteded:_menuView.allTitleLabel[0]];
    }
    return _menuView;
}

- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    self.rollView.contentOffset = CGPointMake(SCREEN_WIDTH * index, 0);
}

#pragma mark - 界面分页视图
- (UIScrollView *)rollView {
    if (!_rollView) {
        _rollView = [[UIScrollView alloc] init];
        _rollView.contentSize = CGSizeMake(SCREEN_WIDTH * tableViewCount, 0);
        _rollView.pagingEnabled = YES;
        _rollView.showsVerticalScrollIndicator = NO;
        _rollView.showsHorizontalScrollIndicator = NO;
        _rollView.bounces = NO;
        _rollView.scrollEnabled = NO;
        
        [_rollView addSubview:self.creatSceneView];
        [_creatSceneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 45));
            make.left.top.equalTo(_rollView).with.offset(0);
        }];
    }
    return _rollView;
}

#pragma mark - 提示下拉返回文字
- (UILabel *)backLabel {
    if (!_backLabel) {
        _backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 30)];
        _backLabel.font = [UIFont systemFontOfSize:12];
        _backLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.text = @"继续下拉返回详情";
    }
    return _backLabel;
}

#pragma mark - 商品列表
- (UICollectionView *)goodsList {
    if (!_goodsList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, newGoodsCellHeight);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _goodsList = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                        collectionViewLayout:flowLayou];
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_goodsList registerClass:[MallListGoodsCollectionViewCell class] forCellWithReuseIdentifier:goodsListCellId];
        
        [_goodsList addSubview:self.backLabel];
        [self addMJRefresh:_goodsList];
    }
    return _goodsList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MallListGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsListCellId
                                                                                       forIndexPath:indexPath];
    if (self.goodsListMarr.count) {
        [cell setGoodsListData:self.goodsListMarr[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBGoodsInfoViewController *goodsVC = [[FBGoodsInfoViewController alloc] init];
    goodsVC.goodsID = self.goodsIdMarr[indexPath.row];
    [self.nav pushViewController:goodsVC animated:YES];
}

#pragma mark - 创建地盘下的情景&商家信息列表
- (void)creatTableViewCount:(NSInteger)count {
    for (NSInteger idx = 0; idx < count; ++ idx) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH * 2) * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                              style:(UITableViewStyleGrouped)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [UIView new];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.scrollEnabled = NO;
        tableView.tag = tableViewTag + idx;
        tableView.backgroundColor = [UIColor whiteColor];
        
        if (tableView.tag == tableViewTag + 1) {
            tableView.tableHeaderView = self.mapView;
            tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        }
        
        [self initTableViewIndex:tableView];
        
        UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, 30)];
        backLabel.font = [UIFont systemFontOfSize:12];
        backLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        backLabel.textAlignment = NSTextAlignmentCenter;
        backLabel.text = @"继续下拉返回详情";
        [tableView addSubview:backLabel];
        
        [self.rollView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.left.equalTo(self.rollView.mas_left).with.offset((SCREEN_WIDTH * 2) * idx);
            make.top.equalTo(self.mas_top).with.offset(100 + (-50 * idx));
            make.bottom.equalTo(self.mas_bottom).with.offset(0);
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.infoTable) {
        return 2;
    } else if (tableView == self.sceneTable) {
        return self.sceneListMarr.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.sceneTable) {
        return 3;
    } else if (tableView == self.infoTable) {
        if (section == 0) {
            return 3;
        } else
            return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTable) {
        if (indexPath.section == 0) {
            THNBusinessInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
            cell = [[THNBusinessInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:infoCellId];
            [cell thn_setBusinessInfoData:_leftArr[indexPath.row] right:_rightArr[indexPath.row]];
            if (indexPath.row == 2) {
                cell.line.hidden = YES;
            }
            return cell;
        }
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentCellId];
        return cell;
        
    } else if (tableView == self.sceneTable) {
        if (indexPath.row == 0) {
            THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
            if (!cell) {
                cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
                cell.sceneImage.userInteractionEnabled = NO;
            }
            if (self.sceneListMarr.count) {
                [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section]];
            }
            return cell;
            
        } else if (indexPath.row == 1) {
            THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            if (!cell) {
                cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section] userId:@"" isLogin:NO];
            }
            return cell;
            
        } else if (indexPath.row == 2) {
            THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
            if (!cell) {
                cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section]];
                _contentHigh = cell.cellHigh;
                _defaultContentHigh = cell.defaultCellHigh;
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.sceneTable) {
        return 15;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.infoTable) {
        if (section == 0) {
            return 0.01;
        } else
            return 50;
    }
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.infoTable) {
        if (section == 1) {
            return self.commentView;
        }
    }
    return [UIView new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTable) {
        if (indexPath.section == 0) {
            return 35;
        } else {
            return 100;
        }
        
    } else if (tableView == self.sceneTable) {
        if (indexPath.row == 0) {
            return SCREEN_WIDTH;
            
        } else if (indexPath.row == 1) {
            return 50;
            
        } else if (indexPath.row == 2) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                return _contentHigh + 15;
            } else {
                return _defaultContentHigh + 15;
            }
            
        }
    }
    return 0.01f;
}

#pragma mark - 打开情景详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.sceneTable) {
        if (indexPath.row == 2) {
            if (_contentHigh > 65.0f) {
                if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                    _selectedIndexPath = nil;
                } else {
                    _selectedIndexPath = indexPath;
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } else {
            [SVProgressHUD showInfoWithStatus:@"打开情景详情"];
            THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
            vc.sceneDetalId = self.sceneIdMarr[indexPath.section];
            [self.nav pushViewController:vc animated:YES];

        }
    }
}

#pragma mark - 判断滑动到顶部继续下拉返回
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.sceneTable || scrollView == self.goodsList || scrollView == self.infoTable) {
        NSInteger contentOffset = scrollView.contentOffset.y;
        if (contentOffset < -SCREEN_HEIGHT * 0.13) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableOnHeader" object:nil];
        }
    }
}

- (void)initTableViewIndex:(UITableView *)table {
    switch (table.tag) {
        case tableViewTag:
            self.sceneTable = table;
            break;
        case tableViewTag + 1:
            self.infoTable = table;
            break;
    }
}

#pragma mark - inieArray
- (NSMutableArray *)sceneListMarr {
    if (!_sceneListMarr) {
        _sceneListMarr = [NSMutableArray array];
    }
    return _sceneListMarr;
}

- (NSMutableArray *)sceneIdMarr {
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

- (NSMutableArray *)userIdMarr {
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

- (NSMutableArray *)goodsListMarr {
    if (!_goodsListMarr) {
        _goodsListMarr = [NSMutableArray array];
    }
    return _goodsListMarr;
}

- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

@end
