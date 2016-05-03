//
//  SceneInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SceneInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "DataNumTableViewCell.h"
#import "ContentAndTagTableViewCell.h"
#import "LikePeopleTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentViewController.h"
#import "FBAlertViewController.h"
#import "GoodsInfoViewController.h"
#import "SceneInfoData.h"
#import "GoodsTableViewCell.h"
#import "CommentRow.h"
#import "HomePageViewController.h"

static NSString *const URLSceneInfo = @"/scene_sight/view";
static NSString *const URLCommentList = @"/comment/getlist";
static NSString *const URLLikeScenePeople = @"/favorite";
static NSString *const URLLikeScene = @"/favorite/ajax_sight_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_sight_love";
static NSString *const URLSceneGoods = @"/scene_product/getlist";

@interface SceneInfoViewController ()

@pro_strong SceneInfoData       *   sceneInfoModel;
@pro_strong NSArray             *   commentArr;
@pro_strong NSMutableArray      *   sceneCommentMarr;
@pro_strong NSMutableArray      *   likePeopleMarr;
@pro_strong NSArray             *   goodsId;

@end

@implementation SceneInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self networkRequestData];
    [self networkCommentData];
    [self networkLikePeopleData];
//    [self networkSceneGoodsData];
    
    [self setSceneInfoViewUI];
}

#pragma mark -
- (void)setSceneInfoViewUI {
    [self.view addSubview:self.sceneTableView];
    
    [self.view addSubview:self.likeScene];
}

#pragma mark - 网络请求
#pragma mark 场景详情
- (void)networkRequestData {
    [SVProgressHUD show];
    self.sceneInfoRequest = [FBAPI getWithUrlString:URLSceneInfo requestDictionary:@{@"id":self.sceneId} delegate:self];
    [self.sceneInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"场景详情：%@", result);
        self.sceneInfoModel = [[SceneInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        if ([[[result valueForKey:@"data"] valueForKey:@"is_love"] integerValue] == 0) {
            self.likeScene.likeBtn.selected = NO;
        } else if ([[[result valueForKey:@"data"] valueForKey:@"is_love"] integerValue] == 1) {
            self.likeScene.likeBtn.selected = YES;
        }
        //  场景中商品的ids
        self.goodsId = [self.sceneInfoModel.product valueForKey:@"idField"];
        NSString * goodsIds;
        if (self.goodsId.count > 1) {
            for (NSInteger idx = 0; idx < self.goodsId.count; ++ idx) {
                NSString * goodsId = [NSString stringWithFormat:@"%@", self.goodsId[idx]];
                goodsIds = [NSString stringWithFormat:@"%@,", goodsId];
            }
            
        } else {
            goodsIds = self.goodsId[0];
        }
        
        NSLog(@"－－＝－＝ %@", goodsIds);
        [self networkSceneGoodsData:goodsIds];
        
        [self.sceneTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 评论列表
- (void)networkCommentData {
    [SVProgressHUD show];
    
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLCommentList requestDictionary:@{@"type":@"12", @"target_id":self.sceneId} delegate:self];
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
        [SVProgressHUD dismiss];
        [self.sceneTableView reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 给此场景点赞的用户
- (void)networkLikePeopleData {
    self.likePeopleRequest = [FBAPI getWithUrlString:URLLikeScenePeople requestDictionary:@{@"type":@"scene", @"event":@"love", @"page":@"1" , @"size":@"10000", @"id":self.sceneId} delegate:self];
    [self.likePeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 点赞的人：%@", result);
//        NSArray * likePeopleArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
//        for (NSDictionary * sceneDic in likePeopleArr) {
//            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
//            [self.sceneListMarr addObject:homeSceneModel];
//            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
//        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 此场景中的商品
- (void)networkSceneGoodsData:(NSString *)goodsIds {
    self.sceneGoodsRequest = [FBAPI getWithUrlString:URLSceneGoods requestDictionary:@{@"ids":goodsIds} delegate:self];
    [self.sceneGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊ 商品：%@", result);
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 给此场景点赞
- (void)networkLikeSceneData {
    if (self.likeScene.likeBtn.selected == NO) {
        self.likeScene.likeBtn.selected = YES;
        self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":self.sceneId} delegate:self];
        [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    
    } else if (self.likeScene.likeBtn.selected == YES) {
        self.likeScene.likeBtn.selected = NO;
        self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":self.sceneId} delegate:self];
        [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD showSuccessWithStatus:[result valueForKey:@"message"]];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
    
}

#pragma mark - 点赞按钮
- (LikeSceneView *)likeScene {
    if (!_likeScene) {
        _likeScene = [[LikeSceneView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 44)];
        [_likeScene.likeBtn addTarget:self action:@selector(networkLikeSceneData) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _likeScene;
}

#pragma mark - 设置场景详情的视图
- (UITableView *)sceneTableView {
    if (!_sceneTableView) {
        _sceneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _sceneTableView.delegate = self;
        _sceneTableView.dataSource = self;
        _sceneTableView.showsVerticalScrollIndicator = NO;
        _sceneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sceneTableView.backgroundColor = [UIColor whiteColor];
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
            cell.nav = self.navigationController;
            [cell setSceneDataNum:self.sceneInfoModel];
            return cell;
            
        } else if (indexPath.row == 3) {
            static NSString * likePeopleCellId = @"likePeopleCellId";
            LikePeopleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:likePeopleCellId];
            if (cell == nil) {
                cell = [[LikePeopleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:likePeopleCellId];
            }
            cell.nav = self.navigationController;
            [cell setUI];
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
//        [cell setUI];
        return cell;
    
    } else if (indexPath.section == 3) {
        static NSString * mallGoodsCellId = @"MallGoodsCellId";
        GoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsCellId];
        if (cell == nil) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:mallGoodsCellId];
        }
//        [cell setUI];
        return cell;
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_HEIGHT;
        } else if (indexPath.row == 1) {
            ContentAndTagTableViewCell * cell = [[ContentAndTagTableViewCell alloc] init];
            [cell getContentCellHeight:self.sceneInfoModel.des];
            return cell.cellHeight;
        } else if (indexPath.row == 2) {
            return 44;
        } else if (indexPath.row == 3) {
            NSArray * arr = [NSArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
            LikePeopleTableViewCell * cell = [[LikePeopleTableViewCell alloc] init];
            [cell getCellHeight:arr];
            return cell.cellHeight;
        }
        return 100;
        
    } else if (indexPath.section == 1) {
        CommentTableViewCell * cell = [[CommentTableViewCell alloc] init];
        [cell getCellHeight:[self.sceneCommentMarr valueForKey:@"content"][indexPath.row]];
        return cell.cellHeight;
    }
    
    return 210;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    } else if (section == 1) {
        return 10;
    } else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 7;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.backgroundColor = [UIColor colorWithHexString:cellBgColor alpha:1];
    
    if (section == 1) {
        self.headerView.backgroundColor = [UIColor whiteColor];
    } else if (section == 2) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"此场景下的商品" withSubtitle:@""];
    } else if (section == 3) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"相近的商品" withSubtitle:@""];
    }
    
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CommentViewController * commentVC = [[CommentViewController alloc] init];
        commentVC.targetId = self.sceneId;
        [self.navigationController pushViewController:commentVC animated:YES];
    } else if (indexPath.section == 2) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    } else if (indexPath.section == 3) {
        GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.sceneTableView) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.sceneTableView) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            self.rollDown = YES;
        }else{
            self.rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.sceneTableView) {
        CGRect likeSceneRect = self.likeScene.frame;
        CGRect tableRect = self.sceneTableView.frame;
        
        if (self.rollDown == YES) {
            tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
            likeSceneRect = CGRectMake(0, SCREEN_HEIGHT - 44, SCREEN_WIDTH, 44);
            [UIView animateWithDuration:.3 animations:^{
                self.likeScene.frame = likeSceneRect;
                self.sceneTableView.frame = tableRect;
            }];
            
        } else if (self.rollDown == NO) {
            tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            likeSceneRect = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44);
            [UIView animateWithDuration:.3 animations:^{
                self.likeScene.frame = likeSceneRect;
                self.sceneTableView.frame = tableRect;
            }];
        }
    }
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

#pragma mark - 弹出举报视图
- (void)moreBtnClick {
    FBAlertViewController * alertVC = [[FBAlertViewController alloc] init];
    [alertVC initFBAlertVcStyle:NO];
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:alertVC animated:YES completion:nil];
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

- (void)leftBarItemSelected {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊分享");
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

@end
