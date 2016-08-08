//
//  THNHomeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeViewController.h"
#import "SearchViewController.h"
#import "SceneSubscribeViewController.h"

#import "HomeThemeTableViewCell.h"

static NSString *const themeCellId = @"ThemeCellId";
static NSString *const contentCellId = @"ContentCellId";
static NSString *const URLBannerSlide = @"/gateway/slide";

@interface THNHomeViewController ()

@pro_strong NSMutableArray *rollList;

@end

@implementation THNHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setFirstAppStart];
    [self thn_setNavigationViewUI];
    [self thn_setHomeViewUI];
    [self thn_networkRollImgData];
    
}

#pragma mark - 网络请求
#pragma mark 轮播图
- (void)thn_networkRollImgData {
    self.rollImgRequest = [FBAPI getWithUrlString:URLBannerSlide requestDictionary:@{@"name":@"app_fiu_product_index_slide", @"size":@"5"} delegate:self];
    [self.rollImgRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * rollArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * rollDic in rollArr) {
            RollImageRow * rollModel = [[RollImageRow alloc] initWithDictionary:rollDic];
            [self.rollList addObject:rollModel];
        }
        [self.homerollView setRollimageView:self.rollList];
        [self.homeTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {

        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 初始化数据
- (NSMutableArray *)rollList {
    if (!_rollList) {
        _rollList = [NSMutableArray array];
    }
    return _rollList;
}

#pragma mark - 设置视图UI
- (void)thn_setHomeViewUI {
    [self.view addSubview:self.homeTable];
}

- (FBRollImages *)homerollView {
    if (!_homerollView) {
        _homerollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BANNER_HEIGHT)];
        _homerollView.navVC = self.navigationController;
    }
    return _homerollView;
}

#pragma mark tableView
- (UITableView *)homeTable {
    if (!_homeTable) {
        _homeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStyleGrouped)];
        _homeTable.delegate = self;
        _homeTable.dataSource = self;
        _homeTable.tableHeaderView = self.homerollView;
        _homeTable.showsVerticalScrollIndicator = NO;
        _homeTable.backgroundColor = [UIColor colorWithHexString:@"#F1F1F1" alpha:1];
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self addMJRefresh:_homeTable];
    }
    return _homeTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomeThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellId];
        cell = [[HomeThemeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:themeCellId];
        return cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellId];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:contentCellId];
        cell.backgroundColor = [UIColor orangeColor];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return 400;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.nav = self.navigationController;
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_Brand"
                                      withTitle:NSLocalizedString(@"Home_Theme", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:2];
    } else if (section ==1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_goods"
                                      withTitle:NSLocalizedString(@"Home_Scene", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:0];
    }
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self thn_addNavLogoImage];
    [self thn_addQRBtn];
    [self thn_addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self thn_addBarItemRightBarButton:@"" image:@"Nav_Concern"];
}

- (void)thn_leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 0;
    searchVC.beginSearch = YES;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    SceneSubscribeViewController * sceneSubVC = [[SceneSubscribeViewController alloc] init];
    [self.navigationController pushViewController:sceneSubVC animated:YES];
}

#pragma mark - 首次打开加载指示图
- (void)thn_setFirstAppStart {
    if(![USERDEFAULT boolForKey:@"homeLaunch"]){
        [USERDEFAULT setBool:YES forKey:@"homeLaunch"];
        [self thn_setMoreGuideImgForVC:@[@"guide_home",@"Guide_index",@"guide-fiu",@"guide-personal"]];
    }
}

@end
