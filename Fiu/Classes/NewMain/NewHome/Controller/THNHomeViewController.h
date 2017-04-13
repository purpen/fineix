//
//  THNHomeViewController.h
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "FBRollImages.h"
#import "GroupHeaderView.h"
#import "THNHotUserView.h"
#import "FBTabBarItemBadgeBtn.h"
#import "BuyCarDefault.h"
#import "THNHomeTableViewFooter.h"

@interface THNHomeViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITableViewDelegate,
    UITableViewDataSource
>

/**  */
@property (nonatomic, strong) UILabel *addressCityLabel;
@property (nonatomic, strong) FBRequest *rollImgRequest;
@property (nonatomic, strong) FBRequest *userHelpRequest;
@property (nonatomic, strong) FBRequest *categoryRequest;
@property (nonatomic, strong) FBRequest *niceDomainRequest;
@property (nonatomic, strong) FBRequest *newestGoodsRequest;
@property (nonatomic, strong) FBRequest *hotGoodsRequest;
@property (nonatomic, strong) FBRequest *goodsSubjectRequest;
@property (nonatomic, strong) FBRequest *subjectRequest;
@property (nonatomic, strong) FBRequest *subjectInfoRequest;
@property (nonatomic, strong) FBRequest *sceneListRequest;
@property (nonatomic, strong) FBRequest *likeSceneRequest;
@property (nonatomic, strong) FBRequest *cancelLikeRequest;
@property (nonatomic, strong) FBRequest *favoriteRequest;
@property (nonatomic, strong) FBRequest *cancelFavoriteRequest;
@property (nonatomic, strong) FBRequest *deleteRequest;

@property (nonatomic, strong) FBRollImages *homerollView;
@property (nonatomic, strong) UITableView *homeTable;
@property (nonatomic, strong) NSMutableArray *sceneListMarr;
@property (nonatomic, strong) NSMutableArray *sceneIdMarr;
@property (nonatomic, strong) NSMutableArray *userIdMarr;

@property (nonatomic, strong) NSMutableArray *rollList;
@property (nonatomic, strong) NSMutableArray *subjectMarr;
@property (nonatomic, strong) NSMutableArray *subjectIdMarr;

@property (nonatomic, strong) NSMutableArray *domainCategoryMarr;
@property (nonatomic, strong) NSMutableArray *userHelpMarr;
@property (nonatomic, strong) NSMutableArray *niceDomainMarr;
@property (nonatomic, strong) NSMutableArray *newestGoodsMarr;
@property (nonatomic, strong) NSMutableArray *hotGoodsMarr;
@property (nonatomic, strong) NSMutableArray *goodsSubjectMarr;
@property (nonatomic, strong) NSMutableArray *goodsSubjectIdMarr;
@property (nonatomic, strong) NSMutableArray *goodsSubjectTypeMarr;

@property (nonatomic, strong) BuyCarDefault *defaultHomeView;
@property (nonatomic, strong) THNHomeTableViewFooter *footerImageView;

@end
