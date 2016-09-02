//
//  THNSceneDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneDetalViewController.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNSceneCommentTableViewCell.h"
#import "MJRefresh.h"
#import "FBRefresh.h"
#import "HomeSceneListRow.h"
#import "CommentRow.h"
#import "FBSubjectModelRow.h"
#import "CommentNViewController.h"
#import "HomeSceneListRow.h"
#import "FBAlertViewController.h"

@interface THNSceneDetalViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSIndexPath *_selectedIndexPath;
}
@pro_strong UITableView *sceneTable;

/**  */
@property (nonatomic, strong) HomeSceneListRow *model;
/**  */
@property (nonatomic, strong) NSArray *comments;
@pro_strong FBRequest *sceneListRequest;
@pro_strong FBRequest *likeSceneRequest;
@pro_strong FBRequest *cancelLikeRequest;
@pro_strong FBRequest *cancelFavoriteRequest;
@pro_strong FBRequest *followRequest;
@pro_strong FBRequest *cancelFollowRequest;
@pro_strong FBRequest *viewCountRequest;
@pro_strong FBRequest *favoriteRequest;

@end

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";
static NSString *const URLFavorite = @"/favorite/ajax_favorite";

static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";
static NSString *const URLCancelFavorite = @"/favorite/ajax_cancel_favorite";


@implementation THNSceneDetalViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = NSLocalizedString(@"situation", nil);
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.sceneTable];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                           @"id" : self.sceneDetalId
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"情境详情 %@",result); 
            self.model = [[HomeSceneListRow alloc] initWithDictionary:[result valueForKey:@"data"]];
//            NSLog(@" 12312  %@",self.model.user.)
            self.comments = [result valueForKey:@"data"][@"comments"];
            [self.sceneTable reloadData];
        }else{
            
        }
    } failure:nil];
}

#pragma mark tableView
- (UITableView *)sceneTable {
    if (!_sceneTable) {
        _sceneTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _sceneTable.delegate = self;
        _sceneTable.dataSource = self;
        _sceneTable.showsVerticalScrollIndicator = NO;
        _sceneTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _sceneTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self addMJRefresh:_sceneTable];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeTheScene:) name:@"likeTheScene" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLikeTheScene:) name:@"cancelLikeTheScene" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(followTheUser:) name:@"followTheUser" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFollowTheUser:) name:@"cancelFollowTheUser" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(favoriteTheScene:) name:@"favoriteTheScene" object:nil];
    }
    return _sceneTable;
}

-(void)followClick:(UIButton*)sender{
    
    if (sender.selected) {
        
        self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":self.model.user.userId} delegate:self];
        [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                self.model.user.isFollow = 1;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    }else{
        self.cancelFollowRequest = [FBAPI postWithUrlString:URLCancelFollowUser requestDictionary:@{@"follow_id":self.model.user.userId} delegate:self];
        [self.cancelFollowRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                self.model.user.isFollow = 1;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        [cell thn_setHomeSceneUserInfoData:self.model userId:[self getLoginUserID] isLogin:[self isUserLogin]];
        cell.follow.tag = indexPath.row;
        [cell.follow addTarget:self action:@selector(followClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (indexPath.row == 1) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (self.model) {
            [cell thn_setSceneImageData:self.model];
            cell.vc = self;
            cell.nav = self.navigationController;
        }
        return cell;
        
    } else if (indexPath.row == 2) {
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        if (self.model) {
            [cell thn_setSceneData:self.model isLogin:[self isUserLogin]];
            cell.vc = self;
            cell.nav = self.navigationController;
        }
        [cell.like addTarget:self action:@selector(commentsClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (indexPath.row == 3) {
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        if (self.model) {
            [cell thn_setSceneContentData:self.model];
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
            cell.nav = self.navigationController;
        }
        return cell;
        
    } else if (indexPath.row == 4) {
        if ([self.comments count] > 0) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            [cell thn_setScenecommentData:self.comments[0]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            return cell;
        }
        
    } else if (indexPath.row == 5) {
        if ([self.comments count] > 1) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            [cell thn_setScenecommentData:self.comments[1]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    } else if (indexPath.row == 1) {
        return SCREEN_WIDTH;
    } else if (indexPath.row == 2) {
        return 40;
    } else if (indexPath.row == 3) {
        if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
            return _contentHigh;
        } else {
            return _defaultContentHigh;
        }
    } else if (indexPath.row == 4) {
        if ([self.comments count] > 0) {
            return _commentHigh;
        } else {
            return 0.01f;
        }
    } else if (indexPath.row == 5) {
        if ([self.comments count] > 1) {
            return _commentHigh;
        } else {
            return 0.01f;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        if (_contentHigh > 70.0f) {
            if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
                _selectedIndexPath = nil;
            } else {
                _selectedIndexPath = indexPath;
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    } else if (indexPath.row == 4 || indexPath.row == 5) {
        CommentNViewController * commentVC = [[CommentNViewController alloc] init];
        //        commentVC.targetId = self.sceneIdMarr[indexPath.section];
        //        commentVC.sceneUserId = self.userIdMarr[indexPath.section];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

//#pragma mark - 点赞
//- (void)likeTheScene:(NSNotification *)idx {
//    [self thn_networkLikeSceneData:[idx object]];
//}
//
//- (void)cancelLikeTheScene:(NSNotification *)idx {
//    [self thn_networkCancelLikeData:[idx object]];
//}
//
//#pragma mark - 关注
//- (void)followTheUser:(NSNotification *)idx {
//    [self thn_networkFollowSceneData:[idx object]];
//}
//
//- (void)cancelFollowTheUser:(NSNotification *)idx {
//    [self thn_networkCancelFollowData:[idx object]];
//}



-(void)commentsClick:(UIButton*)sender{
    if (sender.selected) {
        self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
        [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
                self.model.loveCount = [loveCount integerValue];
                self.model.isLove = 1;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];

    }else{
        
        self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
        [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
                self.model.loveCount = [loveCount integerValue];
                self.model.isLove = 0;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    }
}

-(void)moreClick{
    FBAlertViewController * alertVC = [[FBAlertViewController alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [alertVC initFBAlertVcStyle:NO isFavorite:self.model.isFavorite];
    alertVC.targetId = [NSString stringWithFormat:@"%ld",(long)self.model.idField];
    alertVC.favoriteTheScene = ^(NSString *sceneId) {
        self.model.isFavorite = 1;
        [self thn_networkFavoriteData];
    };
    alertVC.cancelFavoriteTheScene = ^(NSString *sceneId) {
        self.model.isFavorite = 0;
        [self thn_networkCancelFavoriteData];
    };
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark 收藏情境
- (void)thn_networkFavoriteData{
    self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 取消收藏
- (void)thn_networkCancelFavoriteData {
    self.cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
    [self.cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


@end
