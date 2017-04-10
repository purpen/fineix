//
//  SearchBrandViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchBrandViewController.h"
#import "BrandListModel.h"
#import "BrandsListTableViewCell.h"
#import "THNBrandInfoViewController.h"

static NSString *const URLSearchList = @"/search/getlist";
static NSString *const brandCellId = @"BrandCellId";

@interface SearchBrandViewController () {
    NSString *_keyword;
}

@end

@implementation SearchBrandViewController

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
    [self.brandListMarr removeAllObjects];
    [self.brandIdMarr removeAllObjects];
    self.currentpageNum = 0;
    [self networkSearchData:keyword];
}

- (void)networkSearchData:(NSString *)keyword {
    _keyword = keyword;
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLSearchList requestDictionary:@{@"evt":@"content",
                                                                                       @"size":@"8",
                                                                                       @"page":@(self.currentpageNum + 1),
                                                                                       @"t":@"13",
                                                                                       @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *brandArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * brandDic in brandArr) {
            BrandListModel *brandModel = [[BrandListModel alloc] initWithDictionary:brandDic];
            [self.brandListMarr addObject:brandModel];
            [self.brandIdMarr addObject:brandModel.brandId];
        }
        
        if (self.brandListMarr.count) {
            self.noneLab.hidden = YES;
            self.brandTable.hidden = NO;
        } else {
            self.noneLab.hidden = NO;
            self.brandTable.hidden = YES;
        }
        
        [self.brandTable reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.brandTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
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
    
    [self thn_setbrandListViewUI];
}

#pragma mark - 设置视图UI
- (void)thn_setbrandListViewUI {
    [self.view addSubview:self.brandTable];
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

- (UITableView *)brandTable {
    if (!_brandTable) {
        _brandTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStylePlain)];
        _brandTable.delegate = self;
        _brandTable.dataSource = self;
//        _brandTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _brandTable.tableFooterView = [UIView new];
        _brandTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _brandTable.showsVerticalScrollIndicator = NO;
    }
    return _brandTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.brandListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BrandsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:brandCellId];
    cell = [[BrandsListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandCellId];
    if (self.brandListMarr.count) {
        [cell setBrandListData:self.brandListMarr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THNBrandInfoViewController * goodsBrandVC = [[THNBrandInfoViewController alloc] init];
    goodsBrandVC.brandId = self.brandIdMarr[indexPath.row];
    [self.navigationController pushViewController:goodsBrandVC animated:YES];
}

#pragma mark -
- (NSMutableArray *)brandListMarr {
    if (!_brandListMarr) {
        _brandListMarr = [NSMutableArray array];
    }
    return _brandListMarr;
}

- (NSMutableArray *)brandIdMarr {
    if (!_brandIdMarr) {
        _brandIdMarr = [NSMutableArray array];
    }
    return _brandIdMarr;
}

@end
