//
//  THNXiangGuanQingJingTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//


#import "THNXiangGuanQingJingTableViewCell.h"
#import "Masonry.h"
#import "Fiu.h"
#import "UIImageView+WebCache.h"
#import "THNProductDongModel.h"
#import "FBGoodsInfoViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNSenceModel.h"
#import "THNSenecCollectionViewCell.h"
#import "THNSceneImageTableViewCell.h"
#import "THNUserInfoTableViewCell.h"
#import "THNSceneInfoTableViewCell.h"
#import "THNDataInfoTableViewCell.h"
#import "THNLoginRegisterViewController.h"
#import "FBAlertViewController.h"
#import "THNUserData.h"

static NSString *const sceneImgCellId = @"SceneImgCellId";
static NSString *const userInfoCellId = @"UserInfoCellId";
static NSString *const sceneInfoCellId = @"SceneInfoCellId";
static NSString *const dataInfoCellId = @"DataInfoCellId";
static NSString *const URLDeleteScene = @"/scene_sight/delete";
static NSString *const URLFavorite = @"/favorite/ajax_favorite";
static NSString *const URLCancelFavorite = @"/favorite/ajax_cancel_favorite";
static NSString *const URLCancelLike = @"/favorite/ajax_cancel_love";

@interface THNXiangGuanQingJingTableViewCell () <UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _commentHigh;
    NSIndexPath *_selectedIndexPath;
}
/**  */
@property (nonatomic, strong) UIView *lineView;
/**  */
@property (nonatomic, assign) BOOL b;

@end

@implementation THNXiangGuanQingJingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.scrollEnabled = NO;
//        self.tableView.rowHeight = 1177/2;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.contentView addSubview:self.tableView];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentView).mas_offset(0);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(40);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-5);
        }];
        
        
        self.lineView = [[UIView alloc] init];
        [self.contentView addSubview:self.lineView];
        [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"#f8f8f8"]];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.tableView.mas_top).mas_offset(0);
            make.right.left.mas_equalTo(self.contentView).mas_offset(0);
            make.height.mas_equalTo(40);
        }];
        
        self.biaoTiLabel = [[UILabel alloc] init];
        self.biaoTiLabel.font = [UIFont systemFontOfSize:13];
        self.biaoTiLabel.text = @"情境推荐";
        self.biaoTiLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:self.biaoTiLabel];
        [_biaoTiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(17);
        }];
        
    }
    return self;
}

-(void)haModelAry:(NSMutableArray *)ary{
    self.modelAry = ary;
    [self.tableView reloadData];
}

-(NSMutableArray *)modelAry{
    if (!_modelAry) {
        _modelAry = [NSMutableArray array];
    }
    return _modelAry;
}

-(void)setString:(NSString *)string{
    _string = string;
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/getlist" requestDictionary:@{
                                                                                          @"page" : @(1),
                                                                                          @"size" : @(6),
                                                                                          @"category_ids" : string,
                                                                                          @"stick" : @(1),
                                                                                          @"sort" : @(1)
                                                                                          } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *rows = result[@"data"][@"rows"];
        [self.modelAry removeAllObjects];
        for (NSDictionary * sceneDic in rows) {
            HomeSceneListRow *model = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.modelAry addObject:model];
        }
        if (self.modelAry.count == 0) {
            self.biaoTiLabel.text = @"";
        }
        if (self.b == NO) {
            [self.tableView reloadData];
            self.b = YES;
        }
    } failure:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark - 获取用户登录信息
- (BOOL)isUserLogin {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.isLogin;
}

#pragma mark - 获取用户登录id
- (NSString *)getLoginUserID {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    return userdata.userId;
}

#pragma mark - 是否用户本人
- (BOOL)isLoginUserSelf:(NSString *)userId {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if ([userId isEqualToString:userdata.userId])
        return YES;
    else
        return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self)weakSelf = self;
    HomeSceneListRow *model = self.modelAry[indexPath.section];
    if (indexPath.row == 0) {
        THNSceneImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneImgCellId];
        cell = [[THNSceneImageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneImgCellId];
        if (model) {
            [cell thn_setSceneImageData:model];
            cell.vc = self.vc;
            cell.nav = self.nav;
            [cell thn_touchUpOpenControllerType:(ClickOpenTypeSceneList)];
        }
        return cell;
        
    } else if (indexPath.row == 1) {
        THNUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userInfoCellId];
        cell = [[THNUserInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:userInfoCellId];
        [cell thn_setHomeSceneUserInfoData:model userId:[self getLoginUserID] isLogin:[self isUserLogin]];
        cell.nav = self.nav;
        return cell;
        
    } else if (indexPath.row == 2) {
        
        THNSceneInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sceneInfoCellId];
        cell = [[THNSceneInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneInfoCellId];
        if (model) {
            [cell thn_setSceneContentData:model];
            _contentHigh = cell.cellHigh;
            _defaultContentHigh = cell.defaultCellHigh;
            cell.nav = self.nav;
        }
        return cell;
        
    } else if (indexPath.row == 3) {
        
        THNDataInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dataInfoCellId];
        cell = [[THNDataInfoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:dataInfoCellId];
        if (model) {
            [cell thn_setSceneData:model
                           isLogin:[self isUserLogin]
                        isUserSelf:[self isLoginUserSelf:[NSString stringWithFormat:@"%zi",model.userId]]];
            cell.vc = self.vc;
            cell.nav = self.nav;
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
        cell.like.tag = indexPath.section;
        cell.more.tag = indexPath.section;
        [cell.more addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
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
    } 
    return 44;
}

-(void)commentsClick:(UIButton*)sender{
    HomeSceneListRow *model = self.modelAry[sender.tag];
    if (sender.selected) {
        FBRequest *likeSceneRequest = [FBAPI postWithUrlString:@"/favorite/ajax_love" requestDictionary:@{@"id":@(model.idField), @"type":@"12"} delegate:self];
        [likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
                model.loveCount = [loveCount integerValue];
                model.isLove = 1;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    }else{
        
        FBRequest *cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":@(model.idField), @"type":@"12"} delegate:self];
        [cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
                model.loveCount = [loveCount integerValue];
                model.isLove = 0;
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
        
    }
}

-(void)moreClick:(UIButton*)sender{
    HomeSceneListRow *model = self.modelAry[sender.tag];
    FBAlertViewController * alertVC = [[FBAlertViewController alloc] init];
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    alertVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [alertVC initFBAlertVcStyle:NO isFavorite:model.isFavorite];
    alertVC.targetId = [NSString stringWithFormat:@"%ld",(long)model.idField];
    alertVC.favoriteTheScene = ^(NSString *sceneId) {
        model.isFavorite = 1;
        [self thn_networkFavoriteData];
    };
    alertVC.cancelFavoriteTheScene = ^(NSString *sceneId) {
        model.isFavorite = 0;
        [self thn_networkCancelFavoriteData];
    };
    [self.vc presentViewController:alertVC animated:YES completion:nil];
}

//  删除情境
- (void)thn_networkDeleteScene:(NSString *)idx {
    FBRequest *deleteRequest = [FBAPI postWithUrlString:URLDeleteScene requestDictionary:@{@"id":idx} delegate:self];
    [deleteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [self.nav popViewControllerAnimated:YES];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  收藏
- (void)thn_networkFavoriteData:(NSString *)idx {
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if (userdata.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self.vc presentViewController:vc animated:YES completion:nil];
    }else{
        FBRequest *favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
        [favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
//                [self.model setValue:@"1" forKey:@"isFavorite"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

//  取消收藏
- (void)thn_networkCancelFavoriteData:(NSString *)idx {
    FBRequest *cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
//            [self.model setValue:@"0" forKey:@"isFavorite"];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark 收藏情境
- (void)thn_networkFavoriteData{
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if (userdata.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self.vc presentViewController:vc animated:YES completion:nil];
    }else{
//        FBRequest *favoriteRequest = [FBAPI postWithUrlString:URLFavorite requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
//        [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
//            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
//                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"favoriteDone", nil)];
//            }
//            
//        } failure:^(FBRequest *request, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//        }];
    }
}

#pragma mark 取消收藏
- (void)thn_networkCancelFavoriteData {
//    FBRequest *cancelFavoriteRequest = [FBAPI postWithUrlString:URLCancelFavorite requestDictionary:@{@"id":@(self.model.idField), @"type":@"12"} delegate:self];
//    [cancelFavoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
//        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
//            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"cancelSaveScene", nil)];
//        }
//        
//    } failure:^(FBRequest *request, NSError *error) {
//        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
//    }];
}


//  取消点赞
- (void)thn_networkCancelLikeData:(NSString *)idx {
    FBRequest *cancelLikeRequest = [FBAPI postWithUrlString:URLCancelLike requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
    [cancelLikeRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
//            NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
//            [self.model setValue:loveCount forKey:@"loveCount"];
//            [self.model setValue:@"0" forKey:@"isLove"];
        }
    } failure:^(FBRequest *request, NSError *error) {
    }];
}

//  点赞
- (void)thn_networkLikeSceneData:(NSString *)idx {
    
    THNUserData *userdata = [[THNUserData findAll] lastObject];
    if (userdata.isLogin == NO) {
        THNLoginRegisterViewController *vc = [[THNLoginRegisterViewController alloc] init];
        [self.vc presentViewController:vc animated:YES completion:nil];
    }else{
        FBRequest *likeSceneRequest = [FBAPI postWithUrlString:@"/favorite/ajax_love" requestDictionary:@{@"id":idx, @"type":@"12"} delegate:self];
        [likeSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
            if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
//                NSString *loveCount = [NSString stringWithFormat:@"%zi", [[[result valueForKey:@"data"] valueForKey:@"love_count"] integerValue]];
//                [self.model setValue:loveCount forKey:@"loveCount"];
//                [self.model setValue:@"1" forKey:@"isLove"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
        }];
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        HomeSceneListRow *model = self.modelAry[indexPath.section];
        THNSceneDetalViewController *vc = [[THNSceneDetalViewController alloc] init];
        vc.sceneDetalId = [NSString stringWithFormat:@"%ld",(long)model.idField];
        [self.nav pushViewController:vc animated:YES];
    }
}

@end
