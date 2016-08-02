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
#import "FBGoodsInfoModelData.h"
#import "InfoTitleTableViewCell.h"
#import "InfoRecommendTableViewCell.h"
#import "FBGoodsColorTableViewCell.h"
#import "FBGoodsCommentTableViewCell.h"
#import "CommentModelRow.h"
#import "GoodsRelationProducts.h"
#import "FBGoodsCommentViewController.h"
#import "FBBuyGoodsViewController.h"
#import "FBSureOrderViewController.h"

static NSString *const URLGoodsInfo = @"/product/view";
static NSString *const URLGoodsCommet = @"/comment/getlist";
static NSString *const URLAddCar = @"/shopping/add_cart";

@interface FBGoodsInfoViewController () {
    NSString * _goodsInfoUrl;
}

@pro_strong FBGoodsInfoModelData        *   goodsInfo;
@pro_strong NSMutableArray              *   recommendGoods;
@pro_strong NSMutableArray              *   goodsComment;

@end

@implementation FBGoodsInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getGoodsCarNumData];
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
        _goodsInfoUrl = [[result valueForKey:@"data"] valueForKey:@"content_view_url"];
        [self setThnGoodsInfoVcUI];
        self.goodsInfo = [[FBGoodsInfoModelData alloc] initWithDictionary:[result valueForKey:@"data"]];
        NSArray * goodsArr  = [[result valueForKey:@"data"] valueForKey:@"relation_products"];
        for (NSDictionary * goodsDict in goodsArr) {
            GoodsRelationProducts * goodsModel = [[GoodsRelationProducts alloc] initWithDictionary:goodsDict];
            [self.recommendGoods addObject:goodsModel];
        }
        [self.rollImgView setThnGoodsRollImgData:self.goodsInfo];
        [self.goodsTable reloadData];
        [self networkGoodsCommentData];
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
        [self.goodsTable addSubview:self.pullLab];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 加入购物车
- (void)networkAddCarGoodsData:(NSDictionary *)goodsData {
    self.addCarRequest = [FBAPI postWithUrlString:URLAddCar requestDictionary:goodsData delegate:self];
    [self.addCarRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self getGoodsCarNumData];
            [self showMessage:@"加入购物车成功"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [self showMessage:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图x
- (void)setThnGoodsInfoVcUI {
    [self.view addSubview:self.goodsTable];
    [self.view addSubview:self.goodsInfoWeb];
    [self.view addSubview:self.buyView];
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollImgView.navVC = self.navigationController;
    }
    return _rollImgView;
}

#pragma mark - 商品详情
- (UIWebView *)goodsInfoWeb {
    if (!_goodsInfoWeb) {
        _goodsInfoWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        _goodsInfoWeb.delegate = self;
        _goodsInfoWeb.scrollView.delegate = self;
        _goodsInfoWeb.scrollView.bounces = YES;
        _goodsInfoWeb.backgroundColor = [UIColor whiteColor];
        _goodsInfoWeb.scrollView.showsVerticalScrollIndicator = NO;
        _goodsInfoWeb.scalesPageToFit = YES;
    }
    return _goodsInfoWeb;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

//  上拉提示
- (UILabel *)pullLab {
    if (!_pullLab) {
        _pullLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.goodsTable.contentSize.height + 30, SCREEN_WIDTH, 20)];
        _pullLab.text = NSLocalizedString(@"goodsPullLab", nil);
        _pullLab.font = [UIFont systemFontOfSize:12];
        _pullLab.textColor = [UIColor colorWithHexString:@"#555555"];
        _pullLab.textAlignment = NSTextAlignmentCenter;
    }
    return _pullLab;
}

#pragma mark 产品详情的上拉&下拉加载
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    decelerate = YES;
    if (scrollView == self.goodsTable) {
        CGPoint contentOffsetPoint = self.goodsTable.contentOffset;
        if (contentOffsetPoint.y >  self.goodsTable.contentSize.height - self.goodsTable.frame.size.height + 50) {
            
            CGRect goodsTableRect = self.goodsTable.frame;
            goodsTableRect.origin.y = -SCREEN_HEIGHT;
            [UIView animateWithDuration:.3 animations:^{
                self.goodsTable.frame = goodsTableRect;
            }];
            
            CGRect goodsInfoRect = self.goodsInfoWeb.frame;
            goodsInfoRect.origin.y = 64;
            [UIView animateWithDuration:.3 animations:^{
                self.goodsInfoWeb.frame = goodsInfoRect;
            }];
            
            //  加载商品的web详情
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_goodsInfoUrl]];
            [self.goodsInfoWeb loadRequest:request];
        }
        
    } else if (scrollView == self.goodsInfoWeb.scrollView) {
        CGPoint webContentOffset = self.goodsInfoWeb.scrollView.contentOffset;
        if (webContentOffset.y < -50) {
            
            CGRect goodsTableRect = self.goodsTable.frame;
            goodsTableRect.origin.y = 64;
            [UIView animateWithDuration:.3 animations:^{
                self.goodsTable.frame = goodsTableRect;
            }];
            
            CGRect goodsInfoRect = self.goodsInfoWeb.frame;
            goodsInfoRect.origin.y = SCREEN_HEIGHT;
            [UIView animateWithDuration:.3 animations:^{
                self.goodsInfoWeb.frame = goodsInfoRect;
            }];
            
            [SVProgressHUD dismiss];
        }
    }
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
        [cell setThnGoodsInfoData:self.goodsInfo];
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

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        InfoTitleTableViewCell * cell = [[InfoTitleTableViewCell alloc] init];
        [cell getContentCellHeight:self.goodsInfo.title];
        return cell.cellHeight;
        
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
        [self OpenGoodsBuyView];
    
    } else if (indexPath.section == 3) {
        FBGoodsCommentViewController * thnCommentVC = [[FBGoodsCommentViewController alloc] init];
        thnCommentVC.targetId = self.goodsID;
        [self.navigationController pushViewController:thnCommentVC animated:YES];
    }
}

#pragma mark - 打开商品购买视图
- (void)OpenGoodsBuyView {
    FBBuyGoodsViewController * buyVC = [[FBBuyGoodsViewController alloc] init];
    buyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    buyVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //  立即购买
    buyVC.buyingGoodsBlock = ^(NSDictionary * dict) {
        FBSureOrderViewController * sureOrderVC = [[FBSureOrderViewController alloc] init];
        sureOrderVC.orderDict = dict;
        sureOrderVC.type = 1;
        [self.navigationController pushViewController:sureOrderVC animated:YES];
    };
    
    //  加入购物车
    buyVC.addGoodsCarBlock = ^(NSDictionary * dict) {
        [self networkAddCarGoodsData:dict];
    };
    
    [self presentViewController:buyVC animated:YES completion:^{
        buyVC.getGoodsModel(self.goodsInfo);
    }];
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
        if (IS_iOS9) {
            _buyingBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _buyingBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        _buyingBtn.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
        [_buyingBtn addTarget:self action:@selector(OpenGoodsBuyView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyingBtn;
}

#pragma mark 加入购物车
- (UIButton *)addCarBtn {
    if (!_addCarBtn) {
        _addCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
        [_addCarBtn setTitle:NSLocalizedString(@"addCarBtn", nil) forState:(UIControlStateNormal)];
        [_addCarBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        if (IS_iOS9) {
            _addCarBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        _addCarBtn.backgroundColor = [UIColor colorWithHexString:@"DB9E18"];
        [_addCarBtn addTarget:self action:@selector(OpenGoodsBuyView) forControlEvents:(UIControlEventTouchUpInside)];
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

- (NSMutableArray *)goodsComment {
    if (!_goodsComment) {
        _goodsComment = [NSMutableArray array];
    }
    return _goodsComment;
}

@end
