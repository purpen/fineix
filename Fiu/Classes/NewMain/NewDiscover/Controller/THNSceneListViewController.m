//
//  THNSceneListViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/23.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNSceneListViewController.h"
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

static NSString *const URLLikeScene = @"/favorite/ajax_love";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";
static NSString *const URLFollowUser = @"/follow/ajax_follow";
static NSString *const URLCancelFollowUser = @"/follow/ajax_cancel_follow";
static NSString *const URLFavorite = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite = @"/favorite/ajax_cancel_favorite";

static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const commentsCellId = @"CommentsCellId";
static NSString *const twoCommentsCellId = @"TwoCommentsCellId";

@interface THNSceneListViewController () {
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSString *_sceneId;
    NSString *_userId;
}

@end

@implementation THNSceneListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setSceneViewUI];
}

#pragma mark - 网络请求
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
        NSLog(@"%@", error);
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
        NSLog(@"%@", error);
    }];
}

//  关注
- (void)thn_networkBeginFollowUserData:(NSString *)idx {
    self.followRequest = [FBAPI postWithUrlString:URLFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.followRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  取消关注
- (void)thn_networkCancelFollowUserData:(NSString *)idx {
    self.cancelFollowRequest = [FBAPI postWithUrlString:URLCancelFollowUser requestDictionary:@{@"follow_id":idx} delegate:self];
    [self.cancelFollowRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  收藏
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

//  取消收藏
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

#pragma mark - 设置视图UI
- (void)thn_setSceneViewUI {
    [self.view addSubview:self.sceneTable];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.index];
    [self.sceneTable scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
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
    }
    return _sceneTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sceneListMarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak __typeof(self)weakSelf = self;
    
    if (indexPath.row == 0) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setHomeSceneUserInfoData:self.sceneListMarr[indexPath.section] userId:[self getLoginUserID] isLogin:[self isUserLogin]];
            
            cell.beginFollowTheUserBlock = ^(NSString *userId) {
                [weakSelf beginFollowUser:userId];
            };
            
            cell.cancelFollowTheUserBlock = ^(NSString *userId) {
                [weakSelf cancelFollowUser:userId];
            };
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 1) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneImageData:self.sceneListMarr[indexPath.section]];
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 2) {
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneData:self.sceneListMarr[indexPath.section] isLogin:[self isUserLogin]];
            
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
        }
        cell.vc = self;
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 3) {
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        if (self.sceneListMarr.count) {
            if (self.sceneListMarr.count) {
                [cell thn_setSceneContentData:self.sceneListMarr[indexPath.section]];
            }
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 4) {
        if ([self.commentsMarr[indexPath.section] count] > 0) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            [cell thn_setScenecommentData:self.commentsMarr[indexPath.section][0]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            return cell;
        }
        
    } else if (indexPath.row == 5) {
        if ([self.commentsMarr[indexPath.section] count] > 1) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            [cell thn_setScenecommentData:self.commentsMarr[indexPath.section][1]];
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
        if ([self.commentsMarr[indexPath.section] count] > 0) {
            return _commentHigh;
        } else {
            return 0.01f;
        }
    } else if (indexPath.row == 5) {
        if ([self.commentsMarr[indexPath.section] count] > 1) {
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        [UIView animateWithDuration:0.5 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
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
        commentVC.targetId = self.sceneIdMarr[indexPath.section];
        commentVC.sceneUserId = self.userIdMarr[indexPath.section];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

//  关注用户
- (void)beginFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"1" forKey:@"isFollow"];
    [self thn_networkBeginFollowUserData:userId];
}

//  取消关注用户
- (void)cancelFollowUser:(NSString *)userId {
    NSInteger index = [self.userIdMarr indexOfObject:userId];
    [[self.sceneListMarr valueForKey:@"user"][index] setValue:@"0" forKey:@"isFollow"];
    [self thn_networkCancelFollowUserData:userId];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = NSLocalizedString(@"SceneListVC", nil);
    self.delegate = self;
}

#pragma mark - 初始化数组
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

- (NSMutableArray *)commentsMarr {
    if (!_commentsMarr) {
        _commentsMarr = [NSMutableArray array];
    }
    return _commentsMarr;
}

@end
