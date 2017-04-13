//
//  THNHomeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "CommentNViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"
#import "SearchViewController.h"
#import "THNSubscribeViewController.h"
#import "FBGoodsInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "HomePageViewController.h"
#import "QRCodeScanViewController.h"

#import "THNDomainTableViewCell.h"
#import "THNDomainMenuTableViewCell.h"
#import "THNNewGoodsTableViewCell.h"
#import "THNGoodsSubjectTableViewCell.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNHomeSubjectTableViewCell.h"

#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "RollImageRow.h"
#import "HomeSubjectRow.h"
#import "HotUserListUser.h"
#import "THNArticleModel.h"
#import "DomainCategoryRow.h"
#import "HelpUserRow.h"
#import "NiceDomainRow.h"
#import "HomeGoodsRow.h"
#import "THNMallGoodsModelItem.h"

#import "NSString+TimeDate.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "THNHotUserFlowLayout.h"

#import "LocationManager.h"
#import "THNSelecteCityViewController.h"

static const CGFloat goodsCellHeight = ((SCREEN_WIDTH - 45)/2)*1.21;

static NSString *const URLBannerSlide       = @"/gateway/slide";
static NSString *const URLCategory          = @"/category/getlist";
static NSString *const URLSceneList         = @"/scene_sight/";
static NSString *const URLSubject           = @"/scene_subject/getlist";
static NSString *const URLHomeSubject       = @"/scene_subject/index_subject_stick";
static NSString *const URLSubjectView       = @"/scene_subject/view";
static NSString *const URLLikeScene         = @"/favorite/ajax_love";
static NSString *const URLCancelLike        = @"/favorite/ajax_cancel_love";
static NSString *const URLFavorite          = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite    = @"/favorite/ajax_cancel_favorite";
static NSString *const URLDeleteScene       = @"/scene_sight/delete";
static NSString *const URLNewGoodsList      = @"/product/index_new";
static NSString *const URLHotGoodsList      = @"/product/index_hot";

static NSString *const domainCellId         = @"THNDomainTableViewCellId";
static NSString *const domainMenuCellId     = @"THNDomainMenuTableViewCellId";
static NSString *const newGoodsCellId       = @"newGoodsCellId";
static NSString *const hotGoodsCellId       = @"hotGoodsCellId";
static NSString *const goodsSubjectCellId   = @"THNGoodsSubjectTableViewCellId";
static NSString *const subjectCellId        = @"THNHomeSubjectTableViewCellId";
static NSString *const userInfoCellId       = @"UserInfoCellId";
static NSString *const sceneImgCellId       = @"SceneImgCellId";
static NSString *const dataInfoCellId       = @"DataInfoCellId";
static NSString *const sceneInfoCellId      = @"SceneInfoCellId";

//  判断用户注册时效
static NSInteger const saveTime = 2 * 24 * 60;

@interface THNHomeViewController () <locationManagerDelegate, selectedCityDelegate>{
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    NSString *_sceneId;
    NSString *_userId;
    NSInteger _subjectType;
    BOOL _rollDown;                  //  是否下拉
    CGFloat _lastContentOffset;      //  滚动的偏移量
    BOOL _isNewUser;                 //  是否是新用户
    NSArray *_groupTitle;            //  分组标题
    NSArray *_groupIcon;             //  分组图标
}

/**  */
@property (nonatomic, strong) UIImageView *downImage;

@end

@implementation THNHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setReceiveUmengNotice];
    [self thn_setNavigationViewUI];
    //    [self thn_setFirstAppStart];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_getUserLoginInfo];
    
    [self thn_netWorkGroup];
    [self.navView addSubview:self.addressCityLabel];
    [self.navView addSubview:self.downImage];
    
    //    [self getCity];
}

#pragma mark - 获取登录信息
- (void)thn_getUserLoginInfo {
    if ([self isUserLogin]) {
        [self thn_systemTimeDate];
    } else {
        _isNewUser = YES;
    }
}

//  获取当前时间
- (void)thn_systemTimeDate {
    NSString *getTime = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSInteger registerTime = [[self getRegisterTime] integerValue];
    NSInteger nowTime = [getTime integerValue];
    if (nowTime - registerTime > saveTime) {
        _isNewUser = NO;
    } else {
        _isNewUser = YES;
    }
}

#pragma mark - 推送通知
- (void)thn_setReceiveUmengNotice {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thn_openPushData:) name:@"thnUserInfoNotification" object:nil];
}

/**
 打开接收推送消息
 */
- (void)thn_openPushData:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSInteger type = [[dict valueForKey:@"type"] integerValue];
    NSString *targetId = [dict valueForKey:@"target_id"];

    if (type > 0 && targetId.length > 0) {
        [self thn_openViewControllerWithType:type targetId:targetId];
    }
}

/**
 接收推送消息类型跳转指定页面

 @param type 跳转类型
 @param targetId 专辑ID
 */
- (void)thn_openViewControllerWithType:(NSInteger)type targetId:(NSString *)targetId {
    switch (type) {
        case 1:
            [self thn_openGoodsInfoVC:targetId];
            break;
        case 2:
            [self thn_networkSubjectInfoData:targetId];
            break;
        case 11:
            [self thn_openSceneInfoVC:targetId];
            break;
        case 13:
            [self thn_openUserHomeInfoVC:targetId];
            break;
        default:
            break;
    }
}

//  打开商品详情
- (void)thn_openGoodsInfoVC:(NSString *)targetId {
    FBGoodsInfoViewController *goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
    goodsInfoVC.goodsID = targetId;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

//  打开情境详情
- (void)thn_openSceneInfoVC:(NSString *)targetId {
    THNSceneDetalViewController *sceneInfoVC = [[THNSceneDetalViewController alloc] init];
    sceneInfoVC.sceneDetalId = targetId;
    [self.navigationController pushViewController:sceneInfoVC animated:YES];
}

//  打开个人主页
- (void)thn_openUserHomeInfoVC:(NSString *)targetId {
    HomePageViewController *userHomeVC = [[HomePageViewController alloc] init];
    userHomeVC.userId = targetId;
    userHomeVC.type = @2;
    userHomeVC.isMySelf = [targetId isEqualToString:[self getLoginUserID]];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

#pragma mark - 网络请求
- (void)thn_netWorkGroup {
    [self thn_networkRollImageData];
    [self thn_networkNewUserData];
    //[self thn_networkDomainCategoryData];
    [self thn_networkNiceDomainData];
    [self thn_networkGoodsSubjectListData];
    [self thn_networkNewGoodsData];
    [self thn_networkHotGoodsData];
    [self thn_networkSubjectData];
    [self thn_networkSceneListData];
}

/**
 轮播图
 */
- (void)thn_networkRollImageData {
    NSDictionary *requestDic = @{@"name":@"app_fiu_sight_index_slide",
                                 @"size":@"5",
                                 @"use_cache":@"1"};
    self.rollImgRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:requestDic delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow *rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        [self.homerollView setRollimageView:self.rollList];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 新人专区
 */
- (void)thn_networkNewUserData {
    self.userHelpRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:@{@"name":@"app_fiu_index_new_zone"} delegate:self];
    [self.userHelpRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dict in dataArr) {
            HelpUserRow *model = [[HelpUserRow alloc] initWithDictionary:dict];
            [self.userHelpMarr addObject:model];
        }
    
        [self thn_refreshSeciton:0 item:0];

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 地盘分类
 */
//- (void)thn_networkDomainCategoryData {
//    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"12", @"show_sub":@"1"} delegate:self];
//    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
//        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
//        for (NSDictionary *dict in dataArr) {
//            DomainCategoryRow *model = [[DomainCategoryRow alloc] initWithDictionary:dict];
//            [self.domainCategoryMarr addObject:model];
//        }
//
//        [self thn_refreshSeciton:0 item:1];
//        
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    }];
//}

/**
 推荐地盘
 */
- (void)thn_networkNiceDomainData {
    self.niceDomainRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:@{@"name":@"app_fiu_index_scene_stick"} delegate:self];
    [self.niceDomainRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary *dict in dataArr) {
            NiceDomainRow *model = [[NiceDomainRow alloc] initWithDictionary:dict];
            [self.niceDomainMarr addObject:model];
        }

        [self thn_refreshSeciton:1 item:1];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 最新商品
 */
- (void)thn_networkNewGoodsData {
    self.newestGoodsRequest = [FBAPI getWithUrlString:URLNewGoodsList requestDictionary:@{@"type":@"1", @"use_cache":@"1"} delegate:self];
    [self.newestGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary *goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.newestGoodsMarr addObject:goodsModel];
        }
        
        [self thn_refreshSeciton:2 item:0];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 热门商品
 */
- (void)thn_networkHotGoodsData {
    self.hotGoodsRequest = [FBAPI getWithUrlString:URLHotGoodsList requestDictionary:@{@"type":@"1"} delegate:self];
    [self.hotGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"items"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallGoodsModelItem *goodsModel = [[THNMallGoodsModelItem alloc] initWithDictionary:goodsDic];
            [self.hotGoodsMarr addObject:goodsModel];
        }
        
        [self thn_refreshSeciton:4 item:0];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 商品专辑
 */
- (void)thn_networkGoodsSubjectListData {
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"1",
                                 @"sort":@"2",
                                 @"type":@"5",
                                 @"fine":@"1",
                                 @"use_cache":@"1"};
    self.goodsSubjectRequest = [FBAPI getWithUrlString:URLSubject requestDictionary:requestDic delegate:self];
    [self.goodsSubjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            THNMallSubjectModelRow *goodsModel = [[THNMallSubjectModelRow alloc] initWithDictionary:goodsDic];
            [self.goodsSubjectMarr addObject:goodsModel];
            [self.goodsSubjectIdMarr addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
            [self.goodsSubjectTypeMarr addObject:[NSString stringWithFormat:@"%zi", goodsModel.type]];
        }
        
        [self thn_refreshSeciton:3 item:0];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 活动文章专辑
 */
- (void)thn_networkSubjectData {
    self.subjectRequest = [FBAPI getWithUrlString:URLHomeSubject requestDictionary:@{} delegate:self];
    [self.subjectRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *subArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSInteger idx = 0; idx < 2; ++ idx) {
            HomeSubjectRow *subModel = [[HomeSubjectRow alloc] initWithDictionary:subArr[idx]];
            [self.subjectMarr addObject:subModel];
            [self.subjectIdMarr addObject:[NSString stringWithFormat:@"%zi", subModel.idField]];
        }
        [self.homeTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 点赞
 */
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
        NSLog(@"%@", error);
    }];
}

/**
 取消点赞
 */
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
        NSLog(@"%@", error);
    }];
}

/**
 收藏
 */
- (void)thn_networkFavoriteData:(NSString *)idx {
    self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"1" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 取消收藏
 */
- (void)thn_networkCancelFavoriteData:(NSString *)idx {
    self.cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr[index] setValue:@"0" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 删除情境
 */
- (void)thn_networkDeleteScene:(NSString *)idx {
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSInteger index = [self.sceneIdMarr indexOfObject:idx];
            [self.sceneListMarr removeObjectAtIndex:index];
            [self.sceneIdMarr removeObjectAtIndex:index];
            [self.userIdMarr removeObjectAtIndex:index];
            [self.homeTable deleteSections:[NSIndexSet indexSetWithIndex:index + 1] withRowAnimation:(UITableViewRowAnimationFade)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

/**
 专题详情
 */
- (void)thn_networkSubjectInfoData:(NSString *)idx {
    self.subjectInfoRequest = [FBAPI getWithUrlString:URLSubjectView requestDictionary:@{@"id":idx} delegate:self];
    [self.subjectInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        if (![[[result valueForKey:@"data"] valueForKey:@"type"] isKindOfClass:[NSNull class]]) {
            _subjectType = [[[result valueForKey:@"data"] valueForKey:@"type"] integerValue];
            [self thn_openSubjectTypeController:self.navigationController type:_subjectType subjectId:idx];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}

/**
 情境列表
 */
- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    NSDictionary *requestDic = @{@"page":@"1",
                                 @"size":@"5",
                                 @"sort":@"2",
                                 @"fine":@"1",
                                 @"use_cache":@"1",
                                 @"is_product":@"1"};
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:requestDic delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self.defaultHomeView removeFromSuperview];
        if (![self.view.subviews containsObject:self.homeTable]) {
            [self thn_setHomeViewUI];
        }
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        
        [self.homeTable reloadData];
        if ([self.homeTable.mj_header isRefreshing]) {
            [self.homeTable.mj_header endRefreshing];
        }
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        if (error.code == -1009) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:self.defaultHomeView];
        }
    }];
}

#pragma mark - 刷新数据
/**
 刷新指定单元格
 */
- (void)thn_refreshSeciton:(NSInteger)section item:(NSInteger)item {
    if (self.sceneListMarr.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:section];
        [self.homeTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}

/**
 下拉刷新
 */
- (void)addMJRefresh:(UITableView *)table {
    FBRefresh * header = [FBRefresh headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    table.mj_header = header;
}

/**
 移除旧数据
 */
- (void)loadNewData {
    [self.rollList removeAllObjects];
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [self.userIdMarr removeAllObjects];
    [self.subjectMarr removeAllObjects];
    [self.subjectIdMarr removeAllObjects];
//    [self.domainCategoryMarr removeAllObjects];
    [self.userHelpMarr removeAllObjects];
    [self.niceDomainMarr removeAllObjects];
    [self.newestGoodsMarr removeAllObjects];
    [self.hotGoodsMarr removeAllObjects];
    [self.goodsSubjectMarr removeAllObjects];
    [self.goodsSubjectIdMarr removeAllObjects];
    [self.goodsSubjectTypeMarr removeAllObjects];

    [self thn_networkSceneListData];
    [self thn_networkRollImageData];
    [self thn_networkSubjectData];
    [self thn_networkNewUserData];
    [self thn_networkHotGoodsData];
//    [self thn_networkDomainCategoryData];
    [self thn_networkNiceDomainData];
    [self thn_networkNewGoodsData];
    [self thn_networkGoodsSubjectListData];
}

#pragma mark - 设置视图UI
- (void)thn_setHomeViewUI {
    [self.view addSubview:self.homeTable];
    _groupTitle = @[@"新手福利见面礼", @"D3IN在这里", @"新鲜好货早知道", @"好货合集", @"好货人气王", @"大家都在看"];
    _groupIcon = @[@"shouye_zhuti", @"shouye_jingxuan", @"shouye_jingxuan", @"shouye_jingxuan", @"shouye_jingxuan", @"shouye_jingxuan"];
}

#pragma mark - 无网络时的提示背景
- (BuyCarDefault *)defaultHomeView {
    if (!_defaultHomeView) {
        _defaultHomeView = [[BuyCarDefault alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _defaultHomeView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        [_defaultHomeView.defaultBtn setTitle:NSLocalizedString(@"reloadData", nil) forState:(UIControlStateNormal)];
        [_defaultHomeView.defaultBtn addTarget:self action:@selector(reloadDataClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_defaultHomeView thn_setDefaultViewImage:@"icon_no_network" promptText:NSLocalizedString(@"noNetworking", nil) hiddenButton:NO];
    }
    return _defaultHomeView;
}

- (void)reloadDataClick {
    [self loadNewData];
}

/**
 列表滚动到底部的背景
 */
- (THNHomeTableViewFooter *)footerImageView {
    if (!_footerImageView) {
        _footerImageView = [[THNHomeTableViewFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    }
    return _footerImageView;
}

#pragma mark - 商品的数量
- (NSInteger)thn_setGoodsListCount:(NSMutableArray *)goodsData {
    NSInteger count = 0;
    count = goodsData.count%2 == 0 ? goodsData.count/2 : (goodsData.count + 1)/2;
    return count;
}

#pragma mark - 初始化轮播图&点击跳转事件
- (FBRollImages *)homerollView {
    if (!_homerollView) {
        _homerollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.56)];
        _homerollView.navVC = self.navigationController;
        __weak __typeof(self)weakSelf = self;
        _homerollView.getProjectType = ^ (NSString *idx) {
            [weakSelf thn_networkSubjectInfoData:idx];
        };
    }
    return _homerollView;
}

#pragma mark - tableView
- (UITableView *)homeTable {
    if (!_homeTable) {
        _homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStyleGrouped)];
        _homeTable.delegate = self;
        _homeTable.dataSource = self;
        _homeTable.tableHeaderView = self.homerollView;
        _homeTable.tableFooterView = self.footerImageView;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addMJRefresh:_homeTable];
    }
    return _homeTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count + 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2 || section == 3 || section == 4) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == self.sceneListMarr.count + 5) {
        return self.subjectMarr.count;
    } else {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self)weakSelf = self;
    
    if (indexPath.section == 0) {
        if (_isNewUser) {    //  新手专区
            THNDomainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:domainCellId];
            cell = [[THNDomainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:domainCellId];
            if (self.userHelpMarr.count) {
                [cell thn_setUserHelpModelArr:self.userHelpMarr type:0];
                cell.openUserHelp = ^(NSString *idx) {
                    [weakSelf thn_networkSubjectInfoData:idx];
                };
            }
            cell.nav = self.navigationController;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:domainCellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:domainCellId];
            }
            return cell;
        }
    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {    //  地盘分类
            THNDomainMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:domainMenuCellId];
            cell = [[THNDomainMenuTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:domainMenuCellId];
            cell.nav = self.navigationController;
            if (self.domainCategoryMarr.count) {
                [cell setDomainMenuModelArr:self.domainCategoryMarr];
            }
            return cell;
            
        } else {    //  热门地盘
            THNDomainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:domainCellId];
            cell = [[THNDomainTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:domainCellId];
            cell.nav = self.navigationController;
            if (self.niceDomainMarr.count) {
                [cell thn_setDomainModelArr:self.niceDomainMarr type:1];
            }
            return cell;
        }
        
    } else if (indexPath.section == 2) {    //  最新商品
        THNNewGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newGoodsCellId];
        cell = [[THNNewGoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:newGoodsCellId];
        if (self.newestGoodsMarr.count) {
            [cell thn_setHomeGoodsModelArr:self.newestGoodsMarr];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.section == 3) {    //  商品专辑
        THNGoodsSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsSubjectCellId];
        cell = [[THNGoodsSubjectTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsSubjectCellId];
        if (self.goodsSubjectMarr.count) {
            [cell thn_setGoodsSubjectData:self.goodsSubjectMarr];
        }
        cell.nav = self.navigationController;
        return cell;
    
    }  else if (indexPath.section == 4) {    //  热门商品
        THNNewGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:hotGoodsCellId];
        cell = [[THNNewGoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:hotGoodsCellId];
        if (self.hotGoodsMarr.count) {
            [cell thn_setHomeGoodsModelArr:self.hotGoodsMarr];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.section == self.sceneListMarr.count + 5) {    //  文章活动
        THNHomeSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subjectCellId];
        cell = [[THNHomeSubjectTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:subjectCellId];
        if (self.subjectMarr.count) {
            [cell thn_setSubjectModel:self.subjectMarr[indexPath.row]];
        }
        return cell;
    
    } else {    //  情境列表
        if (indexPath.row == 0) {
            THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
            if (!cell) {
                cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section - 5]];
                [cell thn_touchUpOpenControllerType:(ClickOpenTypeSceneList)];
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;

        } else if (indexPath.row == 1) {
            THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            if (!cell) {
                cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section - 5] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;
            
        } else if (indexPath.row == 2) {
            THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
            if (!cell) {
                cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section - 5]];
                _contentHigh = cell.cellHigh;
                _defaultContentHigh = cell.defaultCellHigh;
            }
            cell.nav = self.navigationController;
            return cell;
            
        } else if (indexPath.row == 3) {
            THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
            if (!cell) {
                cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
            }
            if (self.sceneListMarr.count) {
                [cell thn_setSceneData:self.sceneListMarr[indexPath.section - 5]
                               isLogin:[self isUserLogin]
                            isUserSelf:[self isLoginUserSelf:self.userIdMarr[indexPath.section - 5]]];
                
                cell.beginLikeTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkLikeSceneData:idx];
                };
                
                cell.cancelLikeTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkCancelLikeData:idx];
                };
                
                cell.beginFavoriteTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkFavoriteData:idx];
                };
                
                cell.cancelFavoriteTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkCancelFavoriteData:idx];
                };
                
                cell.deleteTheSceneBlock = ^(NSString *idx) {
                    [weakSelf thn_networkDeleteScene:idx];
                };
            }
            cell.vc = self;
            cell.nav = self.navigationController;
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_isNewUser == YES) {
            return 195;
        }
        return 0.01;
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
//            return 75;
            return 0.01;
        }
        return 195;

    } else if (indexPath.section == 2) {
        NSInteger newGoodsCount = [self thn_setGoodsListCount:self.newestGoodsMarr];
        return (goodsCellHeight * newGoodsCount) + (newGoodsCount * 15);
        
    } else if (indexPath.section == 3) {
        return 366;
        
    } else if (indexPath.section == 4) {
        NSInteger hotGoodsCount = [self thn_setGoodsListCount:self.hotGoodsMarr];
        return (goodsCellHeight * hotGoodsCount) + (hotGoodsCount * 15);
        
    } else if (indexPath.section == self.sceneListMarr.count + 5) {
        return (SCREEN_WIDTH * 0.56) + 10;
    
    } else {
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
            
        } else if (indexPath.row == 3) {
            return 50;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    GroupHeaderView *headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headerView.nav = self.navigationController;
    if (section < 6) {
        if (section == 0 && _isNewUser == NO) {
            return [UIView new];
        }
        if (section == 2 || section == 4) {
            headerView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        }
        [headerView addGroupHeaderViewIcon:_groupIcon[section]
                                 withTitle:_groupTitle[section]
                              withSubtitle:@""
                             withRightMore:section == 3 ? @"查看更多" : @""
                              withMoreType:section == 3 ? 3 : 0];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_isNewUser) {
            return 44.0;
        } else {
            return 0.01;
        }
    } else if (section == 1 || section == 2 || section == 3 || section == 4 || section == 5) {
        return 44.0;
    } else
        return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 4) {
        return 0.01;
    } else
        return 10.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 4 && indexPath.section < self.sceneListMarr.count + 5) {
        if (indexPath.row == 2) {
            if (_contentHigh > 90.0f) {
                if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                    _selectedIndexPath = nil;
                } else {
                    _selectedIndexPath = indexPath;
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    } else if (indexPath.section == 3) {
        NSInteger type = [self.goodsSubjectTypeMarr[indexPath.row] integerValue];
        NSString *idx = self.goodsSubjectIdMarr[indexPath.row];
        [self thn_openSubjectTypeController:self.navigationController type:type subjectId:idx];
    
    } else if (indexPath.section == self.sceneListMarr.count + 5) {
        [self thn_networkSubjectInfoData:self.subjectIdMarr[indexPath.row]];
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            _rollDown = YES;
        }else{
            _rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.homeTable) {
        CGRect tabBarRect = self.tabBarController.tabBar.frame;
        CGRect tableRect = self.homeTable.frame;
        if (_rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            
            [self thn_setTableRect:tableRect tabBarRect:tabBarRect alpha:0.0 statusBarHidden:YES];
            
        } else if (_rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49);
            tableRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
            
            [self thn_setTableRect:tableRect tabBarRect:tabBarRect alpha:1.0 statusBarHidden:NO];
        }
    }
}

- (void)thn_setTableRect:(CGRect)tableRect tabBarRect:(CGRect)tabBarRect alpha:(CGFloat)count statusBarHidden:(BOOL)hidden {
    [UIView animateWithDuration:.3 animations:^{
        self.tabBarController.tabBar.frame = tabBarRect;
        self.homeTable.frame = tableRect;
        self.navView.alpha = count;
        self.leftBtn.alpha = count;
        self.rightBtn.alpha = count;
        [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:(UIStatusBarAnimationSlide)];
    }];
}

#pragma mark - 选择城市
//-(UILabel *)addressCityLabel{
//    if (!_addressCityLabel) {
//        _addressCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
//        _addressCityLabel.center = CGPointMake(self.view.center.x + 50, 45);
//        _addressCityLabel.font = [UIFont systemFontOfSize:12];
//        _addressCityLabel.textColor = [UIColor whiteColor];
//        _addressCityLabel.userInteractionEnabled = YES;
//        [_addressCityLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)]];
//    }
//    return _addressCityLabel;
//}

-(void)labelTap{
    THNSelecteCityViewController *vc = [[THNSelecteCityViewController alloc] init];
    vc.localCity = self.addressCityLabel.text;
    vc.selectedCityDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)setSelectedCityStr:(NSString *)str{
    self.addressCityLabel.text = str;
}

//-(UIImageView *)downImage{
//    if (!_downImage) {
//        _downImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.addressCityLabel.frame.origin.x + self.addressCityLabel.frame.size.width - 20, self.addressCityLabel.frame.origin.y + 9, 11, 6)];
//        _downImage.image = [UIImage imageNamed:@"nav_down"];
//        _downImage.userInteractionEnabled = YES;
//        [_downImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap)]];
//    }
//    return _downImage;
//}

#pragma mark - 获取当前城市信息
-(void)getCity{
    [LocationManager shareLocation].locationDelegate = self;
    [[LocationManager shareLocation] findMe];
}

-(void)setLocalCityStr:(NSString *)str{
    NSString *cityStr = [str substringToIndex:[str length] - 1];
    self.addressCityLabel.text = cityStr;
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"HomeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"HomeLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"shouye_sousuo",@"shouye_dingyue"]];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.delegate = self;
    self.baseTable = self.homeTable;
    self.navViewTitle.hidden = YES;
    [self thn_addNavLogoImage];
    [self thn_addBarItemLeftBarButton:@"" image:@"mall_saoma"];
    [self thn_addBarItemRightBarButton:@"" image:@"shouye_search"];
}

- (void)thn_leftBarItemSelected {
    QRCodeScanViewController * qrVC = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.index = 0;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 初始化数组
- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
}

- (NSMutableArray *)subjectMarr {
    if (!_subjectMarr) {
        _subjectMarr = [NSMutableArray array];
    }
    return _subjectMarr;
}

- (NSMutableArray *)subjectIdMarr {
    if (!_subjectIdMarr) {
        _subjectIdMarr = [NSMutableArray array];
    }
    return _subjectIdMarr;
}

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

- (NSMutableArray *)domainCategoryMarr {
    if (!_domainCategoryMarr) {
        _domainCategoryMarr = [NSMutableArray array];
    }
    return _domainCategoryMarr;
}

- (NSMutableArray *)userHelpMarr {
    if (!_userHelpMarr) {
        _userHelpMarr = [NSMutableArray array];
    }
    return _userHelpMarr;
}

- (NSMutableArray *)niceDomainMarr {
    if (!_niceDomainMarr) {
        _niceDomainMarr = [NSMutableArray array];
    }
    return _niceDomainMarr;
}

- (NSMutableArray *)hotGoodsMarr {
    if (!_hotGoodsMarr) {
        _hotGoodsMarr = [NSMutableArray array];
    }
    return _hotGoodsMarr;
}

- (NSMutableArray *)newestGoodsMarr {
    if (!_newestGoodsMarr) {
        _newestGoodsMarr = [NSMutableArray array];
    }
    return _newestGoodsMarr;
}

- (NSMutableArray *)goodsSubjectMarr {
    if (!_goodsSubjectMarr) {
        _goodsSubjectMarr = [NSMutableArray array];
    }
    return _goodsSubjectMarr;
}

- (NSMutableArray *)goodsSubjectIdMarr {
    if (!_goodsSubjectIdMarr) {
        _goodsSubjectIdMarr = [NSMutableArray array];
    }
    return _goodsSubjectIdMarr;
}

- (NSMutableArray *)goodsSubjectTypeMarr {
    if (!_goodsSubjectTypeMarr) {
        _goodsSubjectTypeMarr = [NSMutableArray array];
    }
    return _goodsSubjectTypeMarr;
}

#pragma mark - 移除通知
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [SVProgressHUD dismiss];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"thnUserInfoNotification" object:nil];
}

@end
