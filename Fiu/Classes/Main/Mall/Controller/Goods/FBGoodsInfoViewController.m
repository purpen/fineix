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
#import "CommentModelRow.h"
#import "GoodsRelationProducts.h"
#import "FBGoodsCommentViewController.h"
#import "FBBuyGoodsViewController.h"
#import "FBSureOrderViewController.h"
#import "THNBrandInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNDiscoverSceneCollectionViewCell.h"
#import "InfoTitleTableViewCell.h"
#import "GoodsDesTableViewCell.h"
#import "InfoBrandTableViewCell.h"
#import "ShareViewController.h"
#import <UMSocialCore/UMSocialCore.h>

static NSString *const URLGoodsInfo = @"/product/view";
static NSString *const URLAddCar = @"/shopping/add_cart";
static NSString *const URlGoodsCollect = @"/favorite/ajax_favorite";
static NSString *const URlCancelCollect = @"/favorite/ajax_cancel_favorite";
static NSString *const URLSceneList = @"/sight_and_product/getlist";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const SceneListCellId = @"SceneListCellId";

static NSString *const ShareURlText = @"我在Fiu浮游™寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！来吧，去Fiu一下 >>> http://m.taihuoniao.com/fiu";

@interface FBGoodsInfoViewController () {
    NSString * _goodsInfoUrl;
    NSString *_goodsDes;
    NSInteger _collect;
    NSInteger _canBuy;
    CGFloat _sceneListHeight;
    FBGoodsCommentViewController *_goodsCommentVC;
    ShareViewController *_shareVC;
}

@pro_strong FBGoodsInfoModelData        *   goodsInfo;
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
    [self setThnGoodsInfoVcUI];
    [self thn_networkSceneListData];
    [self networkGoodsInfoData];
}

#pragma mark - 网络请求
#pragma mark 商品详情
- (void)networkGoodsInfoData {
    [SVProgressHUD show];
    self.goodsInfoRequest = [FBAPI getWithUrlString:URLGoodsInfo requestDictionary:@{@"id":self.goodsID} delegate:self];
    [self.goodsInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *goodsDict = [result valueForKey:@"data"];
        _goodsDes = goodsDict[@"advantage"];
        _goodsInfoUrl = goodsDict[@"content_view_url"];
        _collect = [goodsDict[@"is_favorite"] integerValue];
        if (![goodsDict[@"stage"] isKindOfClass:[NSNull class]]) {
            _canBuy = [goodsDict[@"stage"] integerValue];
            
            if (_canBuy == 9) {
                self.menuView.hidden = NO;
                self.goodsBuyView.hidden = NO;
                
            } else {
                [self changeRollFrame];
                self.menuView.hidden = YES;
                self.goodsBuyView.hidden = YES;
            }
        }
        
        [self.goodsBuyView isCollectTheGoods:_collect];
        
        self.goodsInfo = [[FBGoodsInfoModelData alloc] initWithDictionary:goodsDict];
        [self.rollImgView setThnGoodsRollImgData:self.goodsInfo];
        [self.goodsTable reloadData];
        [SVProgressHUD dismiss];
        if (self.goodsInfo.idField != 0) {
            self.menuView.hidden = NO;
            self.goodsInfoRoll.hidden = NO;
            if (_canBuy == 9) {
                self.goodsBuyView.hidden = NO;
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
   
    if (self.goodsInfo.idField == 0) {
        self.menuView.hidden = YES;
        self.goodsInfoRoll.hidden = YES;
        self.goodsBuyView.hidden = YES;
    }
}

#pragma mark 加入购物车
- (void)networkAddCarGoodsData:(NSDictionary *)goodsData {
    self.addCarRequest = [FBAPI postWithUrlString:URLAddCar requestDictionary:goodsData delegate:self];
    [self.addCarRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self getGoodsCarNumData];
            [self showMessage:@"已加入到购物车"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [self showMessage:[error localizedDescription]];
    }];
}

#pragma mark 商品收藏
- (void)networkCollectGoods:(BOOL)selected {
    if (selected == NO) {
        self.collectRequest = [FBAPI postWithUrlString:URlGoodsCollect requestDictionary:@{@"id":self.goodsID, @"type":@"1"} delegate:self];
        [self.collectRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"collectSuccess", nil)];
            [self.goodsBuyView changeCollectBtnState:YES];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    } else if (selected == YES) {
        self.cancelCollectRequest = [FBAPI postWithUrlString:URlCancelCollect requestDictionary:@{@"id":self.goodsID, @"type":@"1"} delegate:self];
        [self.cancelCollectRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelCollect", nil)];
            [self.goodsBuyView changeCollectBtnState:NO];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    NSDictionary *requestDic = @{@"page":@(self.currentpageNum + 1),
                                 @"size":@"30",
                                 @"sort":@"0",
                                 @"product_id":self.goodsID};
    self.sceneRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:[sceneDic valueForKey:@"sight"]];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        
        NSInteger count;
        if (self.sceneListMarr.count%2 != 0) {
            count = (self.sceneListMarr.count +1)/2;
        } else {
            count = self.sceneListMarr.count/2;
        }

        _sceneListHeight = ((SCREEN_WIDTH - 45)/2)*1.5 * count;
        self.goodsTable.tableFooterView = self.sceneList;
       [self.sceneList reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.sceneListMarr[index] setValue:loveCount forKey:@"loveCount"];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isLove"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图x
- (void)setThnGoodsInfoVcUI {
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.goodsInfoRoll];
    [self.goodsInfoRoll addSubview:self.goodsTable];
    [self.goodsInfoRoll addSubview:self.goodsInfoWeb];

    _goodsCommentVC = [[FBGoodsCommentViewController alloc] init];
    [self addChildViewController:_goodsCommentVC];
    [self.goodsInfoRoll addSubview:_goodsCommentVC.view];
    
    [self.view addSubview:self.goodsBuyView];
}

- (void)changeRollFrame {
    CGRect rollRect = self.goodsInfoRoll.frame;
    rollRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.goodsInfoRoll.frame = rollRect;
    
    CGRect goodsTableRect = self.goodsTable.frame;
    goodsTableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.goodsTable.frame = goodsTableRect;
}

- (UIScrollView *)goodsInfoRoll {
    if (!_goodsInfoRoll) {
        _goodsInfoRoll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT - 152)];
        _goodsInfoRoll.showsHorizontalScrollIndicator = NO;
        _goodsInfoRoll.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsInfoRoll.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        _goodsInfoRoll.scrollEnabled = NO;
        _goodsInfoRoll.pagingEnabled = YES;
    }
    return _goodsInfoRoll;
}

- (FBSegmentView *)menuView {
    if (!_menuView) {
        NSArray *menuTitle = @[NSLocalizedString(@"niceGoods", nil),
                               NSLocalizedString(@"niceGoodsInfo", nil),
                               NSLocalizedString(@"goodsComment", nil)];
        _menuView = [[FBSegmentView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _menuView.delegate = self;
        [_menuView set_menuItemTitle:menuTitle];
        [_menuView set_showBottomLine:NO];
        [_menuView addViewBottomLine];
    }
    return _menuView;
}

- (void)menuItemSelected:(NSInteger)index {
    CGPoint rollPoint = self.goodsInfoRoll.contentOffset;
    rollPoint.x = SCREEN_WIDTH * index;
    [UIView animateWithDuration:.3 animations:^{
        self.goodsInfoRoll.contentOffset = rollPoint;
    }];
    
    if (index == 1) {
        //  加载商品的web详情
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_goodsInfoUrl]];
        [self.goodsInfoWeb loadRequest:request];
    } else if (index == 2) {
        [_goodsCommentVC networkSceneCommenstData:self.goodsID];
    }
}

#pragma mark - 轮播图
- (FBRollImages *)rollImgView {
    if (!_rollImgView) {
        _rollImgView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.56)];
        _rollImgView.navVC = self.navigationController;
        _rollImgView.vc = self;
    }
    return _rollImgView;
}

#pragma mark - 商品详情
- (UIWebView *)goodsInfoWeb {
    if (!_goodsInfoWeb) {
        _goodsInfoWeb = [[UIWebView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 152)];
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

#pragma mark 情景列表
- (UICollectionView *)sceneList {
    if (!_sceneList) {
        UICollectionViewFlowLayout *flowLayou = [[UICollectionViewFlowLayout alloc] init];
        flowLayou.itemSize = CGSizeMake((SCREEN_WIDTH - 45)/2, ((SCREEN_WIDTH - 45)/2)*1.21);
        flowLayou.minimumLineSpacing = 15.0f;
        flowLayou.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        flowLayou.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _sceneList = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _sceneListHeight)
                                        collectionViewLayout:flowLayou];
        _sceneList.showsVerticalScrollIndicator = NO;
        _sceneList.delegate = self;
        _sceneList.dataSource = self;
        _sceneList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_sceneList registerClass:[THNDiscoverSceneCollectionViewCell class] forCellWithReuseIdentifier:SceneListCellId];
    }
    return _sceneList;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sceneListMarr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self)weakSelf = self;
    
    THNDiscoverSceneCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SceneListCellId
                                                                                          forIndexPath:indexPath];
    if (self.sceneListMarr.count) {
        [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row] isLogin:[self isUserLogin]];
        
        cell.beginLikeTheSceneBlock = ^(NSString *idx) {
            [weakSelf thn_networkLikeSceneData:idx];
        };
        
        cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
            [weakSelf thn_networkCancelLikeData:idx];
        };
    }
    cell.vc = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    THNSceneDetalViewController *sceneDataVC = [[THNSceneDetalViewController alloc] init];
    sceneDataVC.sceneDetalId = self.sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneDataVC animated:YES];
}

- (UITableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 152) style:(UITableViewStyleGrouped)];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * InfoTitleCellId = @"InfoTitleCellId";
        InfoTitleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoTitleCellId];
        cell = [[InfoTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoTitleCellId];
        if (_canBuy != 9) {
            cell.nextBtn.hidden = YES;
        }
        [cell setThnGoodsInfoData:self.goodsInfo];
        return cell;
        
    } else if (indexPath.section == 1) {
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
        
    } else if (indexPath.section == 2) {
        static NSString * InfoBrandCellId = @"InfoBrandCellId";
        if (self.goodsInfo.brand.title.length) {
            InfoBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
            cell = [[InfoBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
            [cell setGoodsBrandData:self.goodsInfo];
            return cell;
            
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:InfoBrandCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:InfoBrandCellId];
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
        if (_goodsDes.length) {
            GoodsDesTableViewCell * cell = [[GoodsDesTableViewCell alloc] init];
            [cell getContentCellHeight:_goodsDes];
            return  cell.cellHeight;
        } else {
            return 0.01;
        }
        
    } else if (indexPath.section == 2) {
        if (self.goodsInfo.brand.title.length) {
            return 70;
        } else {
            return 0.01;
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
    if (indexPath.section == 0) {
        if (_canBuy == 9) {
            [self.menuView updateMenuBtnState:1];
            [self menuItemSelected:1];
        }
        
    } else if (indexPath.section == 2) {
        THNBrandInfoViewController * goodsBrandVC = [[THNBrandInfoViewController alloc] init];
        goodsBrandVC.brandId = self.goodsInfo.brandId;
        [self.navigationController pushViewController:goodsBrandVC animated:YES];
    }
}

#pragma mark - 底部功能栏
- (THNGoodsBuyView *)goodsBuyView {
    if (!_goodsBuyView) {
        _goodsBuyView = [[THNGoodsBuyView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44)];
        _goodsBuyView.delegate = self;
    }
    return _goodsBuyView;
}

- (void)selectedGoodsBuyViewBtnIndex:(NSInteger)index selectedState:(BOOL)selected {
    switch (index) {
        case 0:
            [self networkCollectGoods:selected];
            break;
            
        case 1:
            [self showSharView];
            break;
            
        case 2:
            if ([self isUserLogin]) {
                [self OpenGoodsBuyView:1];
            } else {
                [self openUserLoginVC];
            }
            break;
            
        case 3:
            if ([self isUserLogin]) {
                [self OpenGoodsBuyView:2];
            } else {
                [self openUserLoginVC];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - 分享商品
- (void)showSharView {
    _shareVC = [[ShareViewController alloc] init];
    _shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    _shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_shareVC animated:YES completion:nil];
    [_shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.goodsInfo.title descr:self.goodsInfo.advantage thumImage:self.goodsInfo.coverUrl];
    //设置网页地址
    shareObject.webpageUrl = self.goodsInfo.shareViewUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [_shareVC dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
            
        } else {
            [_shareVC dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
        }
    }];
}

-(void)wechatShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_WechatSession)];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_WechatTimeLine)];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_QQ)];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_Sina)];
}


#pragma mark - 打开商品购买视图
- (void)OpenGoodsBuyView:(NSInteger)buyState {
    FBBuyGoodsViewController * buyVC = [[FBBuyGoodsViewController alloc] init];
    buyVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    buyVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    buyVC.buyState = buyState;
    
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

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent)];
    self.navViewTitle.text = NSLocalizedString(@"GoodsInfoVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"" image:@"mall_car" isTransparent:NO];
    self.delegate = self;
    [self setNavGoodsCarNumLab];
    self.view.clipsToBounds = YES;
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

@end
