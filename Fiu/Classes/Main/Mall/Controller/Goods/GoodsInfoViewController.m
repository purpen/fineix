//
//  GoodsInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "InfoTitleTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "InfoGoodsHighlightsTableViewCell.h"
#import "GoodsDesTableViewCell.h"
#import "GoodsTagsTableViewCell.h"
#import "InfoUseSceneTableViewCell.h"
#import "InfoRecommendTableViewCell.h"
#import "GoodsBrandViewController.h"
#import "GoodsCarViewController.h"
#import "GoodsInfoData.h"
#import "SceneInfoData.h"
#import "FBGoodsInfoViewController.h"
//#import "ShareViewController.h"

static NSString *const URLGoodsInfo = @"/scene_product/view";
static NSString *const URLRecommendGoods = @"/scene_product/getlist";
static NSString *const URLGoodsScene = @"/sight_and_product/getlist";
static NSString *const URLWantBuy = @"/scene_product/sight_click_stat";
static NSString *const URlGoodsCollect = @"/favorite/ajax_favorite";
static NSString *const URlCancelCollect = @"/favorite/ajax_cancel_favorite";

@interface GoodsInfoViewController () {
    NSString    *   _goodsDes;
    NSArray     *   _goodsTags;
    NSInteger       _collect;
}

@pro_strong GoodsInfoData       *   goodsInfo;
@pro_strong NSMutableArray      *   recommendGoods;
@pro_strong NSMutableArray      *   sceneList;

@end

@implementation GoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getGoodsCarNumData];
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //  统计购买
    if (self.isWant == YES) {
        [self networkWantBuyData];
    }
    [self networkGoodsInfoData];
    [self networkGoodsSceneList];
}

#pragma mark - 网络请求
#pragma mark 商品详情
- (void)networkGoodsInfoData {
    self.goodsInfoRequest = [FBAPI getWithUrlString:URLGoodsInfo requestDictionary:@{@"id":self.goodsID} delegate:self];
    [self.goodsInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        _goodsDes = [[result valueForKey:@"data"] valueForKey:@"summary"];
        _goodsTags = [NSArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"tags"]];
        _collect = [[[result valueForKey:@"data"] valueForKey:@"is_favorite"] integerValue];
        
        if (_collect == 0) {
            self.collectBtn.selected = NO;
        } else if (_collect == 1) {
            self.collectBtn.selected = YES;
        }
    
        if ([[[result valueForKey:@"data"] valueForKey:@"attrbute"] integerValue] == 1) {
            [self.gobuyBtn setTitle:NSLocalizedString(@"goBuyGoods", nil) forState:(UIControlStateNormal)];
        } else if ([[[result valueForKey:@"data"] valueForKey:@"attrbute"] integerValue] == 2) {
            [self.gobuyBtn setTitle:NSLocalizedString(@"goTbBuyGoods", nil) forState:(UIControlStateNormal)];
        } else if ([[[result valueForKey:@"data"] valueForKey:@"attrbute"] integerValue] == 3) {
            [self.gobuyBtn setTitle:NSLocalizedString(@"goTmBuyGoods", nil) forState:(UIControlStateNormal)];
        } else if ([[[result valueForKey:@"data"] valueForKey:@"attrbute"] integerValue] == 4) {
            [self.gobuyBtn setTitle:NSLocalizedString(@"goJdBuyGoods", nil) forState:(UIControlStateNormal)];
        }
        
        self.thnGoodsId = [[result valueForKey:@"data"] valueForKey:@"oid"];
        self.goodsInfo = [[GoodsInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self setGoodsInfoVcUI];
        [self.rollImgView setGoodsRollimageView:self.goodsInfo];

        [self networkRecommendGoodsDataWithCategory:[NSString stringWithFormat:@"%@", [self.goodsInfo valueForKey:@"categoryId"]]];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 相关推荐
- (void)networkRecommendGoodsDataWithCategory:(NSString *)categoryId {
    [SVProgressHUD show];
    self.reGoodsRequest = [FBAPI getWithUrlString:URLRecommendGoods requestDictionary:@{@"category_id":categoryId, @"ignore_ids":self.goodsID, @"sort":@"1", @"page":@"1", @"size":@"8"} delegate:self];
    [self.reGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDict in goodsArr) {
            GoodsInfoData * goodsInfo = [[GoodsInfoData alloc] initWithDictionary:goodsDict];
            [self.recommendGoods addObject:goodsInfo];
        }
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:5];
        [self.goodsInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品应用场景
- (void)networkGoodsSceneList {
    self.goodsSceneRequest = [FBAPI getWithUrlString:URLGoodsScene requestDictionary:@{@"product_id":self.goodsID, @"page":@"1", @"size":@"5"} delegate:self];
    [self.goodsSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSMutableArray * sceneArr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"sight"]];
        if ([sceneArr containsObject:[NSArray array]]) {
            [sceneArr removeObject:[NSArray array]];
        }
        for (NSDictionary * sceneDict in sceneArr) {
            SceneInfoData * sceneModel = [[SceneInfoData alloc] initWithDictionary:sceneDict];
            [self.sceneList addObject:sceneModel];
        }
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
        [self.goodsInfoTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 想购买产品统计
- (void)networkWantBuyData {
    self.wantBuyRequest = [FBAPI postWithUrlString:URLWantBuy requestDictionary:@{@"id":self.goodsID} delegate:self];
    [self.wantBuyRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"%@",result);
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 商品收藏
- (void)networkCollectGoods:(UIButton *)button {
    if (button.selected == NO) {
        self.collectRequest = [FBAPI postWithUrlString:URlGoodsCollect requestDictionary:@{@"id":self.goodsID, @"type":@"10"} delegate:self];
        [self.collectRequest startRequestSuccess:^(FBRequest *request, id result) {
            button.selected = YES;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"collectSuccess", nil)];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    
    } else if (button.selected == YES) {
        self.cancelCollectRequest = [FBAPI postWithUrlString:URlCancelCollect requestDictionary:@{@"id":self.goodsID, @"type":@"10"} delegate:self];
        [self.cancelCollectRequest startRequestSuccess:^(FBRequest *request, id result) {
            button.selected = NO;
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelCollect", nil)];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
    
}

#pragma mark -
- (void)setGoodsInfoVcUI {
    
    [self.view addSubview:self.goodsInfoTable];
    
    [self.view addSubview:self.collectBtn];
    [_collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(44, 44));
        make.top.equalTo(_goodsInfoTable.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
    
    [self.view addSubview:self.gobuyBtn];
    [_gobuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2, 44));
        make.top.equalTo(_goodsInfoTable.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(SCREEN_WIDTH/2);
    }];
    
    UILabel * viewLine = [[UILabel alloc] init];
    viewLine.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    [self.view addSubview:viewLine];
    [viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.top.equalTo(_collectBtn.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
    }];
}

#pragma mark - 收藏
- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [[UIButton alloc] init];
        [_collectBtn setTitle:NSLocalizedString(@"Collect", nil) forState:(UIControlStateNormal)];
//        [_collectBtn setTitle:NSLocalizedString(@"CollectDone", nil) forState:(UIControlStateSelected)];
        [_collectBtn setTitleColor:[UIColor colorWithHexString:@"#555555"] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _collectBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            _collectBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        }
        
        [_collectBtn setTitleEdgeInsets:(UIEdgeInsetsMake(30, -15, 0, 0))];
        [_collectBtn setImage:[UIImage imageNamed:@"goods_star"] forState:(UIControlStateNormal)];
        [_collectBtn setImage:[UIImage imageNamed:@"goods_star_seleted"] forState:(UIControlStateSelected)];
        [_collectBtn setImageEdgeInsets:(UIEdgeInsetsMake(-10, 13, 0, 0))];
        [_collectBtn addTarget:self action:@selector(networkCollectGoods:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectBtn;
}

#pragma mark - 去购买
- (UIButton *)gobuyBtn {
    if (!_gobuyBtn) {
        _gobuyBtn = [[UIButton alloc] init];
        _gobuyBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_gobuyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _gobuyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        } else {
            _gobuyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        }
        [_gobuyBtn addTarget:self action:@selector(buyCarBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gobuyBtn;
}

- (void)buyCarBtnClick {
    if (self.goodsInfo.attrbute == 1) {
        FBGoodsInfoViewController * thnGoodsVC = [[FBGoodsInfoViewController alloc] init];
        thnGoodsVC.goodsID = self.thnGoodsId;
        [self.navigationController pushViewController:thnGoodsVC animated:YES];
    
    } else {
        BOOL isExsit = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.goodsInfo.link]];
        if (isExsit) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.goodsInfo.link]];
        }
    }
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollImgView.navVC = self.navigationController;
    }
    return _rollImgView;
}

#pragma mark - 商品信息
- (UITableView *)goodsInfoTable {
    if (!_goodsInfoTable) {
        _goodsInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _goodsInfoTable.delegate = self;
        _goodsInfoTable.dataSource = self;
        _goodsInfoTable.showsHorizontalScrollIndicator = NO;
        _goodsInfoTable.showsVerticalScrollIndicator = NO;
        _goodsInfoTable.tableHeaderView = self.rollImgView;
        _goodsInfoTable.tableFooterView = [UIView new];
        _goodsInfoTable.sectionHeaderHeight = 0.01f;
        _goodsInfoTable.sectionFooterHeight = 0.01f;
        _goodsInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _goodsInfoTable;
}

#pragma mark - tableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * InfoTitleCellId = @"InfoTitleCellId";
        InfoTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoTitleCellId];
        cell = [[InfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoTitleCellId];
        [cell setGoodsInfoData:self.goodsInfo];
        return cell;
    
    } else if (indexPath.section == 1) {
        static NSString * InfoBrandCellId = @"InfoBrandCellId";
        if (self.goodsInfo.brand.coverUrl.length) {
            InfoBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
            cell = [[InfoBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
            [cell setGoodsBrandData:self.goodsInfo];
            return cell;
            
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
            return cell;
        }
    
    } else if (indexPath.section == 2) {
        static NSString * goodsDesCellId = @"GoodsDesCellId";
        if (_goodsDes.length) {
            GoodsDesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsDesCellId];
            cell = [[GoodsDesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsDesCellId];
            [cell setGoodsDesText:_goodsDes];
            return cell;
        
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsDesCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsDesCellId];
            return cell;
        }
        
    } else if (indexPath.section == 3) {
        static NSString * goodsTagsCellId = @"GoodsTagsCellId";
        if (_goodsTags.count) {
            GoodsTagsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsTagsCellId];
            cell = [[GoodsTagsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsTagsCellId];
            cell.nav = self.navigationController;
            [cell setGoodsTagsTitleData:_goodsTags];
            return cell;
        
        }else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:goodsTagsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsTagsCellId];
            return cell;
        }
        
    } else if (indexPath.section == 4) {
        static NSString * InfoUseSceneCellId = @"InfoUseSceneCellId";
        if (self.sceneList.count) {
            InfoUseSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoUseSceneCellId];
            cell = [[InfoUseSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoUseSceneCellId];
            cell.nav = self.navigationController;
            if (self.sceneList.count > 0) {
                [cell setGoodsScene:self.sceneList];
            }
            return cell;
        
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoUseSceneCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoUseSceneCellId];
            return cell;
        }
        
    } else if (indexPath.section == 5) {
        static NSString * InfoRecommendCellId = @"InfoRecommendCellId";
        InfoRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoRecommendCellId];
        cell = [[InfoRecommendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoRecommendCellId];
        cell.nav = self.navigationController;
        [cell setRecommendGoodsData:self.recommendGoods withType:0];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        InfoTitleTableViewCell * cell = [[InfoTitleTableViewCell alloc] init];
        [cell getContentCellHeight:self.goodsInfo.title];
        return cell.cellHeight;
        
    } else if (indexPath.section == 1) {
        if (self.goodsInfo.brand.coverUrl.length) {
            return 65;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 2) {
        if (_goodsDes.length) {
            GoodsDesTableViewCell * cell = [[GoodsDesTableViewCell alloc] init];
            [cell getContentCellHeight:_goodsDes];
            return  cell.cellHeight;
        } else {
           return 0.01;
        }
        
    } else if (indexPath.section == 3) {
        if (_goodsTags.count) {
            return 49;
        } else {
            return 0.01;
        }
    
    } else if (indexPath.section == 4) {
        if (self.sceneList.count) {
            return ((SCREEN_WIDTH - 15)/2 * 1.77) + 60;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 5) {
        return ((self.recommendGoods.count/2) * (((SCREEN_WIDTH - 40) / 2) * 1.3)) + 44;
    }
    return 44;
}

#pragma mark - 点击跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        GoodsBrandViewController * goodsBrandVC = [[GoodsBrandViewController alloc] init];
        goodsBrandVC.brandId = self.goodsInfo.brandId;
        [self.navigationController pushViewController:goodsBrandVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
    self.delegate = self;
    [self setNavGoodsCarNumLab];
}

- (void)rightBarItemSelected {
    GoodsCarViewController * goodsCarVC = [[GoodsCarViewController alloc] init];
    [self.navigationController pushViewController:goodsCarVC animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 
- (NSMutableArray *)recommendGoods {
    if (!_recommendGoods) {
        _recommendGoods = [NSMutableArray array];
    }
    return _recommendGoods;
}

- (NSMutableArray *)sceneList {
    if (!_sceneList) {
        _sceneList = [NSMutableArray array];
    }
    return _sceneList;
}
@end
