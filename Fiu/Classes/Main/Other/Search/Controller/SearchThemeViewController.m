//
//  SearchThemeViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchThemeViewController.h"
#import "ThemeModelRow.h"
#import "ThemeTableViewCell.h"

#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "THNProjectViewController.h"

static NSString *const URLSubjectView = @"/scene_subject/view";
static NSString *const URLSearchList = @"/search/getlist";
static NSString *const themeCellId = @"ThemeCellId";

@interface SearchThemeViewController () {
    NSString *_keyword;
    NSInteger _subjectType;
}

@end

@implementation SearchThemeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navView.hidden = YES;
    self.view.frame = CGRectMake(SCREEN_WIDTH * self.index, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
}

#pragma mark - 网络请求
- (void)searchAgain:(NSString *)keyword {
    [self.themeListMarr removeAllObjects];
    [self.themeIdMarr removeAllObjects];
    self.currentpageNum = 0;
    [self networkSearchData:keyword];
}

//  专题详情
- (void)thn_networkSubjectInfoData:(NSString *)idx {
    self.subjectInfoRequest = [FBAPI getWithUrlString:URLSubjectView requestDictionary:@{@"id":idx} delegate:self];
    [self.subjectInfoRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        if (![[[result valueForKey:@"data"] valueForKey:@"type"] isKindOfClass:[NSNull class]]) {
            _subjectType = [[[result valueForKey:@"data"] valueForKey:@"type"] integerValue];
            if (_subjectType == 1) {
                THNArticleDetalViewController *articleVC = [[THNArticleDetalViewController alloc] init];
                articleVC.articleDetalid = idx;
                [self.navigationController pushViewController:articleVC animated:YES];
                
            } else if (_subjectType == 2) {
                THNActiveDetalTwoViewController *activity = [[THNActiveDetalTwoViewController alloc] init];
                activity.activeDetalId = idx;
                [self.navigationController pushViewController:activity animated:YES];
                
            } else if (_subjectType == 3) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 1;
                [self.navigationController pushViewController:cuXiao animated:YES];
                
            } else if (_subjectType == 4) {
                THNXinPinDetalViewController *xinPin = [[THNXinPinDetalViewController alloc] init];
                xinPin.xinPinDetalId = idx;
                [self.navigationController pushViewController:xinPin animated:YES];
                
            } else if (_subjectType == 5) {
                THNCuXiaoDetalViewController *cuXiao = [[THNCuXiaoDetalViewController alloc] init];
                cuXiao.cuXiaoDetalId = idx;
                cuXiao.vcType = 2;
                [self.navigationController pushViewController:cuXiao animated:YES];
            }
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
}


- (void)networkSearchData:(NSString *)keyword {
    _keyword = keyword;
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"content",
                                                                                       @"size":@"8",
                                                                                       @"page":@(self.currentpageNum + 1),
                                                                                       @"t":@"12",
                                                                                       @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *themeArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * themeDic in themeArr) {
            ThemeModelRow *themeModel = [[ThemeModelRow alloc] initWithDictionary:themeDic];
            [self.themeListMarr addObject:themeModel];
            [self.themeIdMarr addObject:themeModel.idField];
        }
        
        if (self.themeListMarr.count) {
            self.noneLab.hidden = YES;
            self.themeTable.hidden = NO;
        } else {
            self.noneLab.hidden = NO;
            self.themeTable.hidden = YES;
        }
        
        [self.themeTable reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.themeTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)requestIsLastData:(UITableView *)tableView currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (tableView.mj_footer.state == MJRefreshStateNoMoreData) {
            [tableView.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        tableView.mj_footer.state = MJRefreshStateNoMoreData;
        tableView.mj_footer.hidden = true;
    }
    if ([tableView.mj_header isRefreshing]) {
        CGPoint tableY = tableView.contentOffset;
        tableY.y = 0;
        if (tableView.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                tableView.contentOffset = tableY;
            }];
        }
        [tableView.mj_header endRefreshing];
    }
    if ([tableView.mj_footer isRefreshing]) {
        if (isLastPage) {
            [tableView.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [tableView.mj_footer endRefreshing];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setThemeListViewUI];
}

#pragma mark - 设置视图UI
- (void)thn_setThemeListViewUI {
    [self.view addSubview:self.themeTable];
    [self.view addSubview:self.noneLab];
}

#pragma mark - init
#pragma mark - 没有搜索结果
- (UILabel *)noneLab {
    if (!_noneLab) {
        _noneLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 200)];
        _noneLab.textAlignment = NSTextAlignmentCenter;
        _noneLab.textColor = [UIColor colorWithHexString:titleColor];
        _noneLab.font = [UIFont systemFontOfSize:12];
        _noneLab.text = NSLocalizedString(@"noneSearch", nil);
    }
    return _noneLab;
}

- (UITableView *)themeTable {
    if (!_themeTable) {
        _themeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _themeTable.delegate = self;
        _themeTable.dataSource = self;
        _themeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _themeTable.tableFooterView = [UIView new];
        _themeTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _themeTable.showsVerticalScrollIndicator = NO;
    }
    return _themeTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.themeListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:themeCellId];
    cell = [[ThemeTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:themeCellId];
    if (self.themeListMarr.count) {
        [cell setthemeListData:self.themeListMarr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return BANNER_HEIGHT + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self thn_networkSubjectInfoData:self.themeIdMarr[indexPath.row]];
}

#pragma mark -
- (NSMutableArray *)themeListMarr {
    if (!_themeListMarr) {
        _themeListMarr = [NSMutableArray array];
    }
    return _themeListMarr;
}

- (NSMutableArray *)themeIdMarr {
    if (!_themeIdMarr) {
        _themeIdMarr = [NSMutableArray array];
    }
    return _themeIdMarr;
}


@end
