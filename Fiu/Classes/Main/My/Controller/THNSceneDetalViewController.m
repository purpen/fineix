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
#import "UserInfoEntity.h"
#import "THNLoginRegisterViewController.h"
#import "FBShareViewController.h"
#import "THNShangPinCollectionViewCell.h"
#import "MJExtension.h"
#import "THNProductDongModel.h"
#import "THNMabeLikeTableViewCell.h"
#import "THNXiangGuanQingJingTableViewCell.h"

@interface THNSceneDetalViewController ()<UITableViewDelegate,UITableViewDataSource, FBNavigationBarItemsDelegate>
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
@pro_strong FBRequest *deleteRequest;

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
static NSString *const URLDeleteScene = @"/scene_sight/delete";

@implementation THNSceneDetalViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)rightBarItemSelected{
    FBShareViewController * shareVC = [[FBShareViewController alloc] init];
    shareVC.sceneModel = self.model;
    shareVC.sceneId = [NSString stringWithFormat:@"%zi", self.model.idField];
    [self presentViewController:shareVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.delegate = self;
    [self addBarItemRightBarButton:@"" image:@"share_icon" isTransparent:NO];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.view addSubview:self.sceneTable];
    
    [SVProgressHUD show];
    FBAPI *api = [[FBAPI alloc] init];
    NSString *uuid = [api uuid];
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/view" requestDictionary:@{
                                                                                           @"id" : self.sceneDetalId,
                                                                                           @"uuid" : uuid,
                                                                                           @"app_type" : @2
                                                                                           } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result[@"success"] isEqualToNumber:@1]) {
            self.model = [[HomeSceneListRow alloc] initWithDictionary:[result valueForKey:@"data"]];
            NSArray *ary = [THNProductDongModel mj_objectArrayWithKeyValuesArray:self.model.products];
            self.model.products = ary;
            self.navViewTitle.text = self.model.title;
            self.comments = [result valueForKey:@"data"][@"comments"];
            [self.sceneTable reloadData];
            [SVProgressHUD dismiss];
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
        [_sceneTable registerClass:[THNShangPinCollectionViewCell class] forCellReuseIdentifier:THNSHANGPinCollectionViewCell];
        [_sceneTable registerClass:[THNMabeLikeTableViewCell class] forCellReuseIdentifier:THNMABLELikeTableViewCell];
        [_sceneTable registerClass:[THNXiangGuanQingJingTableViewCell class] forCellReuseIdentifier:THNXIANGGuanQingJingTableViewCell];
    }
    return _sceneTable;
}

-(void)followClick:(UIButton*)sender{
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    if (indexPath.row == 0) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (self.model) {
            [cell thn_setSceneImageData:self.model];
            cell.vc = self;
            cell.nav = self.navigationController;
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        [cell thn_setHomeSceneUserInfoData:self.model userId:[self getLoginUserID] isLogin:[self isUserLogin]];
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.row == 2) {
        
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        if (self.model) {
            [cell thn_setSceneContentData:self.model];
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
            cell.nav = self.navigationController;
        }
        return cell;
        
    } else if (indexPath.row == 3) {
        
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        if (self.model) {
            [cell thn_setSceneData:self.model
                           isLogin:[self isUserLogin]
                        isUserSelf:[self isLoginUserSelf:[NSString stringWithFormat:@"%zi", self.model.userId]]];
            cell.vc = self;
            cell.nav = self.navigationController;
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
        [cell.like addTarget:self action:@selector(commentsClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.more addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } else if (indexPath.row == 4) {
        if ([self.model.products count] >= 1) {
            THNShangPinCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THNSHANGPinCollectionViewCell];
            cell.modelAry = self.model.products;
            cell.nav = self.navigationController;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            return cell;
        }
    } else if (indexPath.row == 5) {
        if ([self.comments count] > 0) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            cell.graybackView.backgroundColor = [UIColor whiteColor];
            [cell thn_setScenecommentData:self.comments[0]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:commentsCellId];
            return cell;
        }
        
    } else if (indexPath.row == 6) {
        if ([self.comments count] > 1) {
            THNSceneCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[THNSceneCommentTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            cell.graybackView.backgroundColor = [UIColor whiteColor];
            [cell thn_setScenecommentData:self.comments[1]];
            _commentHigh = cell.cellHigh;
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCommentsCellId];
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:twoCommentsCellId];
            return cell;
        }
    } else if (indexPath.row == 7) {
        THNMabeLikeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:THNMABLELikeTableViewCell];
        cell.nav = self.navigationController;
        NSMutableArray *ary = [NSMutableArray array];
        for (THNProductDongModel *model in self.model.products) {
            if (model.category_ids.count > 1) {
                [ary addObjectsFromArray:model.category_ids];
            }
        }
        NSString *string = [ary componentsJoinedByString:@","];
        cell.string = string;
        return cell;
    } else if (indexPath.row == 8) {
        THNXiangGuanQingJingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:THNXIANGGuanQingJingTableViewCell];
        cell.nav = self.navigationController;
        cell.vc = self;
        NSMutableArray *ary = [NSMutableArray array];
        if (self.model.category_ids.count > 1) {
            [ary addObjectsFromArray:self.model.category_ids];
        } else {
            cell.biaoTiLabel.text = @"";
        }
        NSString *string = [ary componentsJoinedByString:@","];
        cell.string = string;
        return cell;
    }
    return nil;
}

//  删除情境
- (void)thn_networkDeleteScene:(NSString *)idx {
    self.deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [self.deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


//  收藏
- (void)thn_networkFavoriteData:(NSString *)idx {
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
        [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
                [self.model setValue:@"1" forKey:@"isFavorite"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

//  取消收藏
- (void)thn_networkCancelFavoriteData:(NSString *)idx {
    self.cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
            [self.model setValue:@"0" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


//  点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.likeSceneRequest = [FBAPI postWithUrlString:URLLikeScene requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
        [self.likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
                [self.model setValue:loveCount forKey:@"loveCount"];
                [self.model setValue:@"1" forKey:@"isLove"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            NSLog(@"%@", error);
        }];

    }
    
}

//  取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    self.cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [self.cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
            [self.model setValue:loveCount forKey:@"loveCount"];
            [self.model setValue:@"0" forKey:@"isLove"];
        }
    } failure:^(FBRequest *request, NSError *error) {
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return SCREEN_WIDTH;
    } else if (indexPath.row == 1) {
        return 50;
    } else if (indexPath.row == 2) {
        if (_selectedIndexPath && _selectedIndexPath.section == indexPath.section) {
            return _contentHigh;
        } else {
            return _defaultContentHigh;
        }
    } else if (indexPath.row == 3) {
        return 40;
    } else if (indexPath.row == 5) {
        if ([self.comments count] > 0) {
            return _commentHigh + 2;
        } else {
            return 0.001f;
        }
    } else if (indexPath.row == 6) {
        if ([self.comments count] > 1) {
            return _commentHigh + 2;
        } else {
            return 0.01f;
        }
    } else if (indexPath.row == 4) {
        if ([self.model.products count] >= 1) {
            return 65 * [self.model.products count] + 10;
        } else {
            return 0.01f;
        }
    } else if (indexPath.row == 7) {
        return 450;
    } else if (indexPath.row == 8) {
        return (900/2 + 10) * 6 ;
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
    if (indexPath.row == 2) {
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
        commentVC.targetId = self.sceneDetalId;
        commentVC.sceneUserId = [NSString stringWithFormat:@"%ld",(long)self.model.userId];
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}


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
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    if (entity.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        self.favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
        [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
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
