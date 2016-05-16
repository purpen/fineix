//
//  FBGoodsInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/16.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBGoodsInfoViewController.h"
#import "GoodsCarViewController.h"
#import "GoodsInfoData.h"
#import "InfoTitleTableViewCell.h"
#import "InfoRecommendTableViewCell.h"
#import "FBGoodsColorTableViewCell.h"
#import "FBGoodsCommentTableViewCell.h"
#import "CommentModelRow.h"
#import "GoodsRelationProducts.h"
#import "FBGoodsCommentViewController.h"
#import "FBBuyGoodsViewController.h"

static NSString *const URLGoodsInfo = @"/product/view";
static NSString *const URLGoodsCommet = @"/comment/getlist";

@interface FBGoodsInfoViewController ()

@pro_strong GoodsInfoData       *   goodsInfo;
@pro_strong NSMutableArray      *   recommendGoods;
@pro_strong NSMutableArray      *   goodsComment;

@end

@implementation FBGoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkGoodsInfoData];
    
}

#pragma mark - 网络请求
#pragma mark 商品详情
- (void)networkGoodsInfoData {
    [SVProgressHUD show];
    self.goodsInfoRequest = [FBAPI getWithUrlString:URLGoodsInfo requestDictionary:@{@"id":self.goodsID} delegate:self];
    [self.goodsInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSLog(@"＝＝＝＝＝＝＝ %@", result);
        [self setThnGoodsInfoVcUI];
        self.goodsInfo = [[GoodsInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        NSArray * goodsArr  = [[result valueForKey:@"data"] valueForKey:@"relation_products"];
        for (NSDictionary * goodsDict in goodsArr) {
            GoodsRelationProducts * goodsModel = [[GoodsRelationProducts alloc] initWithDictionary:goodsDict];
            [self.recommendGoods addObject:goodsModel];
        }
        [self.rollImgView setThnGoodsRollImgData:self.goodsInfo];
        [self networkGoodsCommentData];
        [self.goodsTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 商品的评价
- (void)networkGoodsCommentData {
    self.commentRequest = [FBAPI getWithUrlString:URLGoodsCommet requestDictionary:@{@"type":@"4", @"page":@"1", @"size":@"3", @"target_id":self.goodsID} delegate:self];
    [self.commentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * commentArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        if (commentArr.count > 0) {
            for (NSDictionary * commentDict in commentArr) {
                CommentModelRow * model = [[CommentModelRow alloc] initWithDictionary:commentDict];
                [self.goodsComment addObject:model];
            }
        }
        [self.goodsTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 设置视图
- (void)setThnGoodsInfoVcUI {
    [self.view addSubview:self.goodsTable];
    [self.view addSubview:self.buyView];
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.48)];
        _rollImgView.navVC = self.navigationController;
    }
    return _rollImgView;
}

#pragma mark - 商品信息列表
- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStyleGrouped)];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.showsVerticalScrollIndicator = NO;
        _goodsTable.showsHorizontalScrollIndicator = NO;
        _goodsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _goodsTable.backgroundColor = [UIColor colorWithHexString:grayLineColor];
        _goodsTable.tableHeaderView = self.rollImgView;
    }
    return _goodsTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return self.goodsComment.count + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * InfoTitleCellId = @"InfoTitleCellId";
        InfoTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoTitleCellId];
        if (!cell) {
            cell = [[InfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoTitleCellId];
        }
        [cell setGoodsInfoData:self.goodsInfo];
        return cell;
        
    } else if (indexPath.section == 1) {
        static NSString * thnGoodsColorTableViewCellId = @"FBGoodsColorTableViewCellId";
        FBGoodsColorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:thnGoodsColorTableViewCellId];
        if (!cell) {
            cell = [[FBGoodsColorTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:thnGoodsColorTableViewCellId];
        }
        cell.goodsColorLab.text = NSLocalizedString(@"GoodsColors", nil);
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString * thnInfoRecommendCellId = @"ThnInfoUseSceneCellId";
        InfoRecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:thnInfoRecommendCellId];
        if (!cell) {
            cell = [[InfoRecommendTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:thnInfoRecommendCellId];
        }
        cell.nav = self.navigationController;
        [cell setRecommendGoodsData:self.recommendGoods withType:1];
        return cell;
    
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            static NSString * thnGoodsCommentCellId = @"ThnGoodsCommentCellId";
            FBGoodsColorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:thnGoodsCommentCellId];
            if (!cell) {
                cell = [[FBGoodsColorTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:thnGoodsCommentCellId];
            }
            cell.goodsColorLab.text = NSLocalizedString(@"GoodsComment", nil);
            return cell;
            
        } else {
            static NSString * thnGoodsCommentInfoCellId = @"ThnGoodsCommentInfoCellId";
            FBGoodsCommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:thnGoodsCommentInfoCellId];
            if (!cell) {
                cell = [[FBGoodsCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:thnGoodsCommentInfoCellId];
            }
            [cell setCommentModel:self.goodsComment[indexPath.row - 1]];
            return cell;
        }
    }
    
    static NSString * GoodsInfoCellId = @"GoodsInfoCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:GoodsInfoCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:GoodsInfoCellId];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else if (indexPath.section == 1) {
        return 44;
    } else if (indexPath.section == 2) {
        return 280;
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 44;
        } else {
            if (self.goodsComment.count > 0) {
                return 100;
            } else if (self.goodsComment.count == 0) {
                return 0.01;
            }
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        FBBuyGoodsViewController * buyVC = [[FBBuyGoodsViewController alloc] init];
        buyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        buyVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:buyVC animated:YES completion:^{
            buyVC.getGoodsModel(self.goodsInfo);
        }];
    
    } else if (indexPath.section == 3) {
        FBGoodsCommentViewController * thnCommentVC = [[FBGoodsCommentViewController alloc] init];
        thnCommentVC.targetId = self.goodsID;
        [self.navigationController pushViewController:thnCommentVC animated:YES];
    }
}

#pragma mark - 立即购买／加入购物车视图
- (UIView *)buyView {
    if (!_buyView) {
        _buyView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        [_buyView addSubview:self.buyingBtn];
        [_buyView addSubview:self.addCarBtn];
    }
    return _buyView;
}

#pragma mark 立即购买
- (UIButton *)buyingBtn {
    if (!_buyingBtn) {
        _buyingBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44)];
        [_buyingBtn setTitle:NSLocalizedString(@"buyingBtn", nil) forState:(UIControlStateNormal)];
        [_buyingBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _buyingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _buyingBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
    }
    return _buyingBtn;
}

#pragma mark 加入购物车
- (UIButton *)addCarBtn {
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
        [_addCarBtn setTitle:NSLocalizedString(@"addCarBtn", nil) forState:(UIControlStateNormal)];
        [_addCarBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _addCarBtn.backgroundColor = [UIColor colorWithHexString:@"DB9E18"];
    }
    return _addCarBtn;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"Nav_Car" isTransparent:NO];
    self.delegate = self;
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

- (NSMutableArray *)goodsComment {
    if (!_goodsComment) {
        _goodsComment = [NSMutableArray array];
    }
    return _goodsComment;
}

@end
