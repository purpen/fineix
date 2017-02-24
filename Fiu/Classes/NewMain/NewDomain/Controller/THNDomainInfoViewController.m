//
//  THNDomainInfoViewController.m
//  Fiu
//
//  Created by FLYang on 2017/2/17.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNDomainInfoViewController.h"
#import "THNBusinessTableViewCell.h"
#import "THNCouponTableViewCell.h"
#import "THNDesTableViewCell.h"
#import "THNMoreDesTableViewCell.h"
#import "THNTitleTableViewCell.h"
#import "THNLightspotTableViewCell.h"
#import "NSString+JSON.h"
#import <UMSocialCore/UMSocialCore.h>
#import "THNShareActionView.h"
#import "THNDomianLightViewController.h"

static NSString *const businessCellId = @"THNBusinessTableViewCellId";
static NSString *const couponCellId = @"THNCouponTableViewCellId";
static NSString *const desCellId = @"THNDesTableViewCellId";
static NSString *const moreCellId = @"THNMoreDesTableViewCellId";
static NSString *const lightTitleCellId = @"THNTitleTableViewCellId";
static NSString *const lightspotCellId = @"THNLightspotTableViewCellId";
static NSString *const URLDomainInfo = @"/scene_scene/view";
static NSString *const URLShareLink = @"/gateway/share_link";

@interface THNDomainInfoViewController () {
    BOOL _rowSelected;
    NSIndexPath *_selectedIndexPath;
    CGFloat _contentHigh;
    CGFloat _defaultContentHigh;
    CGFloat _lastContentOffset;
    CGFloat _lightTextHeight;
    BOOL _onFooterView;
    NSString *_domainId;
    NSString *_linkUrl;
}

@end

@implementation THNDomainInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _onFooterView = NO;
    [self thn_networkDomainInfoData];
    [self thn_setViewUI];
}

#pragma mark - 网络请求
#pragma mark 地盘详情数据
- (void)thn_networkDomainInfoData {
    [SVProgressHUD show];
    self.infoRequest = [FBAPI postWithUrlString:URLDomainInfo requestDictionary:@{@"id":self.infoId} delegate:self];
    [self.infoRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSLog(@"============ 地盘详情： %@", [NSString jsonStringWithObject:result]);
            NSDictionary *dict =  [result valueForKey:@"data"];
            self.infoModel = [[DominInfoData alloc] initWithDictionary:dict];
            if (self.infoModel) {
                _domainId = [NSString stringWithFormat:@"%zi",self.infoModel.idField];
                self.favoriteButton.selected = self.infoModel.isFavorite;
                [self.headerImages thn_setRollimageView:self.infoModel];
                [self.footerView thn_setDomainInfo:self.infoModel];
                self.navViewTitle.text = self.infoModel.title;
                [self.domainInfoTable reloadData];
                self.headerImages.ary = self.infoModel.location.coordinates;
            }
            [SVProgressHUD dismiss];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
    }];
}

#pragma mark 获取分享链接
- (void)thn_networkShareInfoData {
    self.shareRequest = [FBAPI postWithUrlString:URLShareLink requestDictionary:@{@"id":self.infoId, @"type":@"3"} delegate:self];
    [self.shareRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] isEqualToNumber:@1]) {
            NSDictionary *dict =  [result valueForKey:@"data"];
            _linkUrl = [dict valueForKey:@"url"];
            [THNShareActionView showShare:self shareMessageObject:[self shareMessageObject] linkUrl:_linkUrl];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@" ---- %@ ----", error);
    }];
}

#pragma mark 收藏／取消收藏地盘
- (void)thn_networkFavoriteDomain:(BOOL)favorite {
    NSString *url;
    if (favorite) {
        url = @"/favorite/ajax_favorite";
    } else {
        url = @"/favorite/ajax_cancel_favorite";
    }
    self.favoriteRequest = [FBAPI postWithUrlString:url requestDictionary:@{@"id":_domainId, @"type":@"11"} delegate:self];
    [self.favoriteRequest startRequestSuccess:^(FBRequest *request, id result) {
        if ([[result valueForKey:@"success"] integerValue] == 1) {
            if (favorite) {
                [SVProgressHUD showSuccessWithStatus:@"已收藏"];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"");
    }];
}

#pragma mark - 设置界面UI
- (void)thn_setViewUI {
    [self.view addSubview:self.domainInfoTable];
}

#pragma mark 头部地盘图片
- (THNDomainInfoHeaderImage *)headerImages {
    if (!_headerImages) {
        _headerImages = [[THNDomainInfoHeaderImage alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _headerImages;
}

#pragma mark 地盘信息列表
- (UITableView *)domainInfoTable {
    if (!_domainInfoTable) {
        _domainInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _domainInfoTable.delegate = self;
        _domainInfoTable.dataSource = self;
        _domainInfoTable.tableHeaderView = self.headerImages;
        _domainInfoTable.tableFooterView = self.footerView;
        _domainInfoTable.showsVerticalScrollIndicator = NO;
        _domainInfoTable.bounces = NO;
        _domainInfoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _domainInfoTable.sectionHeaderHeight = 0.01f;
        _domainInfoTable.sectionFooterHeight = 0.01f;
    }
    return _domainInfoTable;
}

#pragma mark 地盘底部功能信息
- (THNDomainInfoFooter *)footerView {
    if (!_footerView) {
        _footerView = [[THNDomainInfoFooter alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _footerView.nav = self.navigationController;
        _footerView.vc = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableBackTop:) name:@"tableOnHeader" object:nil];
    }
    return _footerView;
}

#pragma mark 下拉返回地盘列表头部
- (void)tableBackTop:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.domainInfoTable.contentOffset = CGPointMake(0, 0);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            THNBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:businessCellId];
            cell = [[THNBusinessTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:businessCellId];
            [cell thn_setBusinessData:self.infoModel];
            return cell;
            
        } else if (indexPath.row == 1) {
            THNCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellId];
            cell = [[THNCouponTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:couponCellId];
            //        [cell thn_setCouponCount];
            return cell;
        } else if (indexPath.row == 2) {
            THNDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:desCellId];
            cell = [[THNDesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:desCellId];
            [cell thn_setDesData:self.infoModel];
            _contentHigh = cell.defaultCellHigh;
            return cell;
        }
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            THNTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lightTitleCellId];
            cell = [[THNTitleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:lightTitleCellId];
            return cell;
        } else if (indexPath.row == 2) {
            THNMoreDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
            cell = [[THNMoreDesTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:moreCellId];
            if (self.infoModel) {
                cell.nav = self.navigationController;
                cell.infoModel = self.infoModel;
            }
            return cell;
        } else {
            THNLightspotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lightspotCellId];
            cell = [[THNLightspotTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:lightspotCellId];
            if (self.infoModel.brightSpot.count) {
                [cell thn_setBrightSpotData:self.infoModel.brightSpot];
                _lightTextHeight = cell.viewHeiight;
            }
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 180;
        } else if (indexPath.row == 1) {
            return 0.01;
        } else if (indexPath.row == 2) {
            return _contentHigh;
        }
    
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            if (self.infoModel.brightSpot.count) {
                return _lightTextHeight;
            } else
                return 0.01;
        }
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 判断上／下滑状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.domainInfoTable) {
        NSInteger contentOffset = scrollView.contentOffset.y;
        NSInteger scrollHeight = scrollView.contentSize.height - (SCREEN_HEIGHT - 64);
        if (contentOffset >= scrollHeight + 1 || contentOffset == scrollHeight) {
            _onFooterView = YES;
        } else {
            _onFooterView = NO;
        }
        [self.footerView thn_tableViewStartRolling:_onFooterView];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.baseTable = self.domainInfoTable;
    self.delegate = self;
    [self thn_addBarItemRightBarButton:@"" image:@"shouye_share_white"];
    [self.view addSubview:self.favoriteButton];
    self.favoriteButton.selected = NO;
}

- (void)thn_rightBarItemSelected {
    if (self.infoModel) {
        [self thn_networkShareInfoData];
    }
}

#pragma mark - 创建分享消息对象
- (UMSocialMessageObject *)shareMessageObject {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.infoModel.title descr:self.infoModel.des thumImage:self.infoModel.avatarUrl];
    shareObject.webpageUrl = self.infoModel.viewUrl;
    messageObject.shareObject = shareObject;
    return messageObject;
}

#pragma mark - 收藏按钮
- (UIButton *)favoriteButton {
    if (!_favoriteButton) {
        _favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 18, 44, 44)];
        [_favoriteButton setImage:[UIImage imageNamed:@"icon_favorite"] forState:(UIControlStateNormal)];
        [_favoriteButton setImage:[UIImage imageNamed:@"icon_favorite_seleted"] forState:(UIControlStateSelected)];
        [_favoriteButton addTarget:self action:@selector(favoriteButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _favoriteButton;
}

- (void)favoriteButtonClick:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
    } else if (button.selected == YES){
        button.selected = NO;
    }
    
    if (_domainId.length) {
        if ([self isUserLogin]) {
            [self thn_networkFavoriteDomain:button.selected];
        } else {
            [self openUserLoginVC];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tableOnHeader" object:nil];
}

@end
