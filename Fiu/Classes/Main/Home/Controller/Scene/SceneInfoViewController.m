//
//  SceneInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneInfoViewController.h"
#import "SceneListTableViewCell.h"
#import "FiuSceneViewController.h"

static NSString *const URLSceneInfo = @"/scene_sight/view";
static NSString *const URLCommentList = @"/comment/getlist";
static NSString *const URLLikeScenePeople = @"/favorite";
static NSString *const URLLikeScene = @"/favorite/ajax_sight_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_sight_love";
static NSString *const URLSceneGoods = @"/scene_product/getlist";
static NSString *const URLDeleteScene = @"/scene_sight/delete";

@interface SceneInfoViewController () {
    NSDictionary            *   _shareDataDict;
    NSString                *   _sceneUserId;
    NSString                *   _sceneImgUrl;
    CGFloat                     _newTableFrameH;
    UIScrollView            *   _viewScroller;
    FBSceneInfoScrollView   *   _sceneInfoScrollView;
    CGFloat                     _commentCellH;
    CGFloat                     _goodsCellH;
    CGFloat                     _reGoodsCellH;
    CGFloat                     _desCellH;
    CGFloat                     _likeUserCellH;
}

/**城市图标加手势 */
@property(nonatomic,strong) UITapGestureRecognizer *cityTap;

@end

@implementation SceneInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [_viewScroller setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_viewScroller setContentSize:CGSizeMake(_viewScroller.frame.size.width, SCREEN_HEIGHT)];
    [_sceneInfoScrollView setFrame:self.view.frame];
    [_viewScroller setContentOffset:CGPointMake(0, _viewScroller.contentOffset.y)];
    
    [self networkRequestData];
    [self networkCommentData];
    [self networkLikePeopleData];
    [self XuDingYiLookSceneInfo];
    
}

#pragma mark -
- (void)setRollSceneInfoView {
    _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _viewScroller.pagingEnabled = YES;
    _viewScroller.delegate = self;
    _viewScroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_viewScroller];
    [self.view sendSubviewToBack:_viewScroller];
}

- (void)getTableViewFrameH {
    [self setRollSceneInfoView];
    NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_sceneImgUrl]];
    _sceneInfoScrollView = [[FBSceneInfoScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageWithData:imgData] blurredImage:nil viewDistanceFromBottom:0 foregroundView:self.sceneTableView];
    _sceneInfoScrollView.leftBtn = self.leftBtn;
    _sceneInfoScrollView.rightBtn = self.rightBtn;
    _sceneInfoScrollView.logoImg = self.logoImg;
    _sceneInfoScrollView.nav = self.navigationController;
    [_viewScroller addSubview:_sceneInfoScrollView];
    
    [_sceneInfoScrollView setSceneInfoData:self.sceneInfoModel];
}

#pragma mark - 网络请求
#pragma mark 场景详情
- (void)networkRequestData {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"loadingState", nil)];
    self.sceneInfoRequest = [FBAPI getWithUrlString:URLSceneInfo requestDictionary:@{@"id":self.sceneId} delegate:self];
    [self.sceneInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝ %@", result);
        //  分享出去的场景信息
        _shareDataDict = [NSDictionary dictionaryWithDictionary:[result valueForKey:@"data"]];
        _sceneUserId = [NSString stringWithFormat:@"%@", [[result valueForKey:@"data"] valueForKey:@"user_id"]];
        self.sceneInfoModel = [[SceneInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        _sceneImgUrl = self.sceneInfoModel.coverUrl;
        self.homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:[result valueForKey:@"data"]];
        
        //  保存场景封面
        [self.view addSubview:self.downImgView];
        
        if (![self.view.subviews containsObject:_viewScroller]) {
            [self getTableViewFrameH];
        }
        
        //  场景中商品的ids
        self.goodsId = [self.sceneInfoModel.product valueForKey:@"idField"];
        if (self.goodsId.count > 0) {
            NSString * goodsIds;
            if (self.goodsId.count > 1) {
                goodsIds = [self.goodsId componentsJoinedByString:@","];
            } else {
                goodsIds = self.goodsId[0];
            }
            
            [self networkSceneGoodsData:goodsIds];
        }

        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 删除场景
- (void)deleteTheScene {
    self.deleteSceneRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":self.sceneId} delegate:self];
    [self.deleteSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"error :%@", error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 评论列表
- (void)networkCommentData {
    [self.sceneCommentMarr removeAllObjects];
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLCommentList requestDictionary:@{@"type":@"12", @"target_id":self.sceneId, @"sort":@"1"} delegate:self];
    [self.sceneCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.commentArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        
        NSMutableArray * commentMarr = [NSMutableArray array];
        for (NSDictionary * commentDic in self.commentArr) {
            CommentRow * commentModel = [[CommentRow alloc] initWithDictionary:commentDic];
            [commentMarr addObject:commentModel];
        }
        
        if (commentMarr.count >= 3) {
            for (NSInteger idx = 0; idx < 3; ++ idx) {
                [self.sceneCommentMarr addObject:commentMarr[idx]];
            }
        } else if (commentMarr.count < 3) {
            for (NSInteger idx = 0; idx < commentMarr.count; ++ idx) {
                [self.sceneCommentMarr addObject:commentMarr[idx]];
            }
        }
        
        [self.sceneTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 给此场景点赞的用户
- (void)networkLikePeopleData {
    [self.likePeopleMarr removeAllObjects];

    self.likePeopleRequest = [FBAPI postWithUrlString:URLLikeScenePeople requestDictionary:@{@"type":@"sight", @"event":@"love", @"page":@"1" , @"size":@"30", @"id":self.sceneId} delegate:self];
    [self.likePeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * likePeopleArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * likePeopleDic in likePeopleArr) {
            LikeOrSuPeopleRow * likePeopleModel = [[LikeOrSuPeopleRow alloc] initWithDictionary:likePeopleDic];
            [self.likePeopleMarr addObject:likePeopleModel];
        }
        [self.sceneTableView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 此场景中的商品
- (void)networkSceneGoodsData:(NSString *)goodsIds {
    [self.goodsList removeAllObjects];
    self.sceneGoodsRequest = [FBAPI getWithUrlString:URLSceneGoods requestDictionary:@{@"ids":goodsIds, @"size":@"3"} delegate:self];
    [self.sceneGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        NSMutableArray * categoryTagIds = [NSMutableArray array];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.goodsList addObject:goodsModel];
            [self.goodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
            for (NSString * tagIds in goodsModel.categoryTags) {
                [categoryTagIds addObject:tagIds];
            }
        }
        
        NSString * categoryTag = [categoryTagIds componentsJoinedByString:@","];
        [self networkRecommendGoods:categoryTag withIgnoreId:goodsIds];
        
        [self.sceneTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 此场景中的推荐商品
- (void)networkRecommendGoods:(NSString *)tagIds withIgnoreId:(NSString *)ignoreIds {
    [self.reGoodsList removeAllObjects];
    self.recommendRequest = [FBAPI getWithUrlString:URLSceneGoods requestDictionary:@{@"category_tag_ids":tagIds, @"size":@"3", @"ignore_ids":ignoreIds} delegate:self];
    [self.recommendRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * goodsArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * goodsDic in goodsArr) {
            GoodsRow * goodsModel = [[GoodsRow alloc] initWithDictionary:goodsDic];
            [self.reGoodsList addObject:goodsModel];
            [self.reGoodsIdList addObject:[NSString stringWithFormat:@"%zi", goodsModel.idField]];
        }
        
        [self.sceneTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 给此场景点赞
- (void)networkLikeSceneData:(UIButton *)button {
    if (button.selected == NO) {
        self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":self.sceneId} delegate:self];
        [SVProgressHUD show];
        [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            button.selected = YES;
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            [self networkRequestData];
            [self networkLikePeopleData];
            [SVProgressHUD dismiss];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    
    } else if (button.selected == YES) {
        self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":self.sceneId} delegate:self];
        [SVProgressHUD show];
        [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
            button.selected = NO;
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            [self networkRequestData];
            [self networkLikePeopleData];
            [SVProgressHUD dismiss];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
    
}

#pragma mark - 设置场景详情的视图
- (UITableView *)sceneTableView {
    if (!_sceneTableView) {
        _sceneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _sceneTableView.delegate = self;
        _sceneTableView.dataSource = self;
        _sceneTableView.showsVerticalScrollIndicator = NO;
        _sceneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sceneTableView.backgroundColor = [UIColor clearColor];
        _sceneTableView.backgroundView = [UIView new];
        _sceneTableView.opaque = NO;
        _sceneTableView.tableFooterView = [UIView new];
    }
    return _sceneTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return self.sceneCommentMarr.count;
    } else if (section == 2) {
        return self.goodsList.count;
    } else if (section == 3) {
        return self.reGoodsList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * userInfoCellId = @"userInfoCellId";
            UserInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
            if (cell == nil) {
                cell = [[UserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
            }
            cell.nav = self.navigationController;
            [cell setSceneInfoData:self.sceneInfoModel];
            cell.city.userInteractionEnabled = YES;
            [cell.city addGestureRecognizer:self.cityTap];
            [cell.goodBtn addTarget:self action:@selector(networkLikeSceneData:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * contentCellId = @"contentCellId";
            ContentAndTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
            if (cell == nil) {
                cell = [[ContentAndTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentCellId];
            }
            cell.nav = self.navigationController;
            [cell setSceneDescription:self.sceneInfoModel];
            return cell;
        
        } else if (indexPath.row == 2) {
            static NSString * dataNumCellId = @"dataNumCellId";
            DataNumTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:dataNumCellId];
            if (cell == nil) {
                cell = [[DataNumTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataNumCellId];
            }
            [cell.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
            [cell setSceneDataNum:self.sceneInfoModel];
            return cell;
            
        } else if (indexPath.row == 3) {
            static NSString * likePeopleCellId = @"likePeopleCellId";
            LikePeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:likePeopleCellId];
            if (cell == nil) {
                cell = [[LikePeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:likePeopleCellId];
            }
            cell.nav = self.navigationController;
            [cell setLikeOrSuPeopleData:self.likePeopleMarr];
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        static NSString * commentCellId = @"commentCellId";
        CommentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentCellId];
        }
        [cell setCommentData:self.sceneCommentMarr[indexPath.row]];
        return cell;
    
    } else if (indexPath.section == 2) {
        static NSString * mallGoodsCellId = @"MallGoodsCellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsCellId];
        if (cell == nil) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsCellId];
        }
        cell.nav = self.navigationController;
        [cell setGoodsData:self.goodsList[indexPath.row]];
        return cell;
    
    } else if (indexPath.section == 3) {
        static NSString * mallGoodsCellId = @"MallGoodsCellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsCellId];
        cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsCellId];
        cell.nav = self.navigationController;
        [cell setGoodsData:self.reGoodsList[indexPath.row]];
        return cell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 170;
        } else if (indexPath.row == 1) {
            ContentAndTagTableViewCell * cell = [[ContentAndTagTableViewCell alloc] init];
            [cell getContentCellHeight:self.sceneInfoModel.des];
            _desCellH = cell.cellHeight;
            return cell.cellHeight;
        } else if (indexPath.row == 2) {
            return 44;
        } else if (indexPath.row == 3) {
            LikePeopleTableViewCell * cell = [[LikePeopleTableViewCell alloc] init];
            [cell getCellHeight:self.likePeopleMarr];
            _likeUserCellH = cell.cellHeight;
            return cell.cellHeight;
        }
        return 100;
        
    } else if (indexPath.section == 1) {
        CommentTableViewCell * cell = [[CommentTableViewCell alloc] init];
        [cell getCellHeight:[self.sceneCommentMarr valueForKey:@"content"][indexPath.row]];
        return cell.cellHeight;
        
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        if (self.goodsId.count > 0) {
            return 210;
        } else
            return 0.01;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 0.01;
    } else {
        if (self.goodsId.count > 0) {
            return 44;
        } else {
            return 0.01;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    
    if (self.goodsId.count > 0) {
        if (section == 1) {
            self.headerView.backgroundColor = [UIColor whiteColor];
        } else if (section == 2) {
            [self.headerView addGroupHeaderViewIcon:@"Group_scene"
                                          withTitle:NSLocalizedString(@"sceneGoods", nil)
                                       withSubtitle:@""
                                      withRightMore:@""
                                       withMoreType:0];
        } else if (section == 3) {
            if (self.reGoodsList.count == 0) {
                [self.headerView addGroupHeaderViewIcon:@""
                                              withTitle:@""
                                           withSubtitle:@""
                                          withRightMore:@""
                                           withMoreType:0];
            } else {
                [self.headerView addGroupHeaderViewIcon:@"Group_scene"
                                              withTitle:NSLocalizedString(@"sceneLikeGoods", nil)
                                           withSubtitle:@""
                                          withRightMore:@""
                                           withMoreType:0];
            }
        }
    }
    
    return self.headerView;
}

#pragma mark - 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CommentNViewController * commentVC = [[CommentNViewController alloc] init];
        commentVC.targetId = self.sceneId;
        commentVC.sceneUserId = _sceneUserId;
        [self.navigationController pushViewController:commentVC animated:YES];
    } else if (indexPath.section == 2) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.isWant = YES;
        goodsInfoVC.goodsID = self.goodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    } else if (indexPath.section == 3) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        goodsInfoVC.goodsID = self.reGoodsIdList[indexPath.row];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.sceneTableView.contentOffset.y <= 0) {
        self.sceneTableView.scrollEnabled = NO;
    }
}

-(UITapGestureRecognizer *)cityTap{
    if (!_cityTap) {
        _cityTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCityTap:)];
        _cityTap.numberOfTapsRequired = 1;
        _cityTap.numberOfTouchesRequired = 1;
    }
    return _cityTap;
}

-(void)clickCityTap:(UITapGestureRecognizer*)gesture{
    NearQingViewController *vc = [[NearQingViewController alloc] init];
    vc.baseInfo = self.sceneInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看全部评论
- (UIButton *)allComment {
    if (!_allComment) {
        _allComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [_allComment setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        _allComment.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _allComment;
}

#pragma mark - 弹出更多视图
- (void)moreBtnClick {
    FBAlertViewController * alertVC = [[FBAlertViewController alloc] init];
    if ([_sceneUserId isEqualToString:[self getLoginUserID]]) {
        [alertVC initFBAlertVcStyle:YES];
        alertVC.deleteScene = ^ {
            TYAlertView * cancelAlertView = [TYAlertView alertViewWithTitle:@"是否删除当前场景？" message:@""];
            [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"取消" style:(TYAlertActionStyleCancle) handler:^(TYAlertAction *action) {
                
            }]];
            [cancelAlertView addAction:[TYAlertAction actionWithTitle:@"确定删除" style:(TYAlertActionStyleDefault) handler:^(TYAlertAction *action) {
                [self deleteTheScene];
            }]];
            [cancelAlertView showInWindowWithBackgoundTapDismissEnable:YES];
        };
        
    } else {
        [alertVC initFBAlertVcStyle:NO];
    }
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    alertVC.type = @"scene";
    alertVC.targetId = self.sceneId;
    alertVC.sceneData = _shareDataDict;
    alertVC.openCommentVc = ^{
        [self openCommentListVC];
    };
    alertVC.editDoneAndRefresh = ^{
        [self refreshRequestData];
    };
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)openCommentListVC {
    CommentNViewController * commentVC = [[CommentNViewController alloc] init];
    commentVC.targetId = self.sceneId;
    commentVC.sceneUserId = _sceneUserId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

- (void)refreshRequestData {
    [SVProgressHUD show];
    self.sceneInfoRequest = [FBAPI getWithUrlString:URLSceneInfo requestDictionary:@{@"id":self.sceneId} delegate:self];
    [self.sceneInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        //  分享出去的场景信息
        _shareDataDict = [NSDictionary dictionaryWithDictionary:[result valueForKey:@"data"]];
        _sceneUserId = [NSString stringWithFormat:@"%@", [[result valueForKey:@"data"] valueForKey:@"user_id"]];
        self.sceneInfoModel = [[SceneInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        _sceneImgUrl = self.sceneInfoModel.coverUrl;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.sceneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        NSIndexPath * contentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.sceneTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:contentIndexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:(UIStatusBarAnimationSlide)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addNavLogoImgisTransparent:YES];
    [self addBarItemRightBarButton:@"" image:@"Share_Scene" isTransparent:YES];
    [self addBarItemLeftBarButton:@"" image:@"icon_back" isTransparent:YES];
}

- (void)rightBarItemSelected {
    if ([_shareDataDict valueForKey:@"cover_url"]) {
        FBShareViewController * shareVC = [[FBShareViewController alloc] init];
        shareVC.dataDict = _shareDataDict;
        shareVC.sceneId = self.sceneId;
        [self presentViewController:shareVC animated:YES completion:nil];
    }
}

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - 
- (NSMutableArray *)sceneCommentMarr {
    if (!_sceneCommentMarr) {
        _sceneCommentMarr = [NSMutableArray array];
    }
    return _sceneCommentMarr;
}

- (NSArray *)commentArr {
    if (!_commentArr) {
        _commentArr = [NSArray array];
    }
    return _commentArr;
}

- (NSMutableArray *)likePeopleMarr {
    if (!_likePeopleMarr) {
        _likePeopleMarr = [NSMutableArray array];
    }
    return _likePeopleMarr;
}

- (NSArray *)goodsId {
    if (!_goodsId) {
        _goodsId = [NSArray array];
    }
    return _goodsId;
}

- (NSMutableArray *)goodsList {
    if (!_goodsList) {
        _goodsList = [NSMutableArray array];
    }
    return _goodsList;
}

- (NSMutableArray *)goodsIdList {
    if (!_goodsIdList) {
        _goodsIdList = [NSMutableArray array];
    }
    return _goodsIdList;
}

- (NSMutableArray *)reGoodsList {
    if (!_reGoodsList) {
        _reGoodsList = [NSMutableArray array];
    }
    return _reGoodsList;
}

- (NSMutableArray *)reGoodsIdList {
    if (!_reGoodsIdList) {
        _reGoodsIdList = [NSMutableArray array];
    }
    return _reGoodsIdList;
}

#pragma mark - 许丁伊🚺需要的查看封面大图功能
- (void)XuDingYiLookSceneInfo {
    if ([[self getLoginUserID] isEqualToString:@"1067749"]) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(44, 20, 44, 44)];
        [button setImage:[UIImage imageNamed:@"icon_newScene"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(lookSceneImg) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:button];
    }
}

#pragma mark 保存场景封面
- (void)lookSceneImg {
    UIImageWriteToSavedPhotosAlbum([self downImage], self, nil, nil);
    [SVProgressHUD showSuccessWithStatus:@"保存到相册了～"];
}

- (UIImage *)downImage {
    UIGraphicsBeginImageContextWithOptions(self.downImgView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.downImgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 场景封面
- (DownSceneInfoView *)downImgView {
    if (!_downImgView) {
        _downImgView = [[DownSceneInfoView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_downImgView setHomeSceneListData:self.homeSceneModel];
    }
    return _downImgView;
}

@end
