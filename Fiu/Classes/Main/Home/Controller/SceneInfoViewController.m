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

static NSString *const URLSceneInfo = @"/scene_sight/view";
static NSString *const URLCommentList = @"/comment/getlist";
static NSString *const URLLikeScenePeople = @"/favorite";

@interface SceneInfoViewController ()

@pro_strong SceneInfoData       *   sceneInfoModel;
@pro_strong NSMutableArray      *   sceneCommentMarr;

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
    
    self.textMar = [NSMutableArray arrayWithObjects:@"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。", @"家是我们人生的驿站", @"家是我们人生的驿站，是我们生活的乐园，也是我们避风的港湾。它更是一条逼你拼命挣钱的鞭子，让你为它拉车犁地。家又是一个充满亲情的地方，就会有一种亲情感回荡心头。在风雨人生中，渐渐地形成了一种强烈的感觉：我爱家，更离不开家。",nil];
    
    [self setSceneInfoViewUI];
}


- (NSMutableArray *)sceneCommentMarr {
    if (!_sceneCommentMarr) {
        _sceneCommentMarr = [NSMutableArray array];
    }
    return _sceneCommentMarr;
}

#pragma mark -
- (void)setSceneInfoViewUI {
    [self.view addSubview:self.sceneTableView];
    
    [self.view addSubview:self.likeScene];
}

#pragma mark - 网络请求
//  场景详情
- (void)networkRequestData {
    [SVProgressHUD show];
    self.sceneInfoRequest = [FBAPI getWithUrlString:URLSceneInfo requestDictionary:@{@"id":self.sceneId} delegate:self];
    [self.sceneInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.sceneInfoModel = [[SceneInfoData alloc] initWithDictionary:[result valueForKey:@"data"]];
        [self networkCommentData];
        [self networkLikePeopleData];
        [self.sceneTableView reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  评论列表
- (void)networkCommentData {
    self.sceneCommentRequest = [FBAPI getWithUrlString:URLCommentList requestDictionary:@{@"type":@"12", @"target_id":self.sceneId} delegate:self];
    [self.sceneCommentRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 评论：%@", result);
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

//  给此场景点赞的用户
- (void)networkLikePeopleData {
    self.likePeopleRequest = [FBAPI getWithUrlString:URLLikeScenePeople requestDictionary:@{@"type":@"scene", @"event":@"love", @"page":@"1" , @"size":@"10000", @"id":self.sceneId} delegate:self];
    [self.likePeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ 点赞的人：%@", result);
        
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

//  此场景中的商品
- (void)networkSceneGoodsData {
    
}

#pragma mark - 点赞按钮
- (LikeSceneView *)likeScene {
    if (!_likeScene) {
        _likeScene = [[LikeSceneView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_HEIGHT, 44)];
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
        return 3;
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
        [cell setUI:self.textMar[indexPath.row]];
        return cell;
    }
    
    static NSString * CellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    return cell;
    
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
        [cell getCellHeight:self.textMar[indexPath.row]];
        return cell.cellHeight;
    }
    
    return 100;
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

@end
