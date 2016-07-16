//
//  FBEditShareInfoViewController.m
//  Fiu
//
//  Created by FLYang on 16/5/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBEditShareInfoViewController.h"
#import "ShareInfoRow.h"
#import "ShareSearchTextTableViewCell.h"
#import "CatagoryFiuSceneModel.h"

static NSString *const URLCategroy = @"/category/getlist";
static NSString *const URLShareText = @"/search/getlist";
static NSString *const URLListText = @"/scene_context/getlist";

@interface FBEditShareInfoViewController () {
    NSString * _categoryId;
}

@pro_strong NSMutableArray      *   categoryTitleMarr;
@pro_strong NSMutableArray      *   categoryIdMarr;
@pro_strong NSMutableArray      *   listMarr;
@pro_strong NSMutableArray      *   shareTextList;

@end

@implementation FBEditShareInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navView.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkSceneContentCategory];
    _categoryId = @"0";
    self.listCurrentpageNum = 0;
    [self networkContentList:_categoryId];
    
    [self setEditInfoVcUI];
}

#pragma mark - 网络请求
#pragma mark 语境分类
- (void)networkSceneContentCategory {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategroy requestDictionary:@{@"domain":@"11", @"show_all":@"1"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * categoryArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * categoryDic in categoryArr) {
            CatagoryFiuSceneModel * categoryModel = [[CatagoryFiuSceneModel alloc] initWithDictionary:categoryDic];
            [self.categoryTitleMarr addObject:categoryModel.categoryTitle];
            [self.categoryIdMarr addObject:[NSString stringWithFormat:@"%zi", categoryModel.categoryId]];
        }
        
        if (self.categoryTitleMarr.count) {
            [self.listView addSubview:self.categoryMenuView];
        }

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 语境列表
- (void)networkContentList:(NSString *)categoryId {
    [SVProgressHUD show];
    self.listRequest = [FBAPI getWithUrlString:URLListText requestDictionary:@{@"category_id":categoryId, @"size":@"10", @"sort":@"1", @"page":@(self.listCurrentpageNum + 1)} delegate:self];
    [self.listRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        NSArray * listArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * listDict in listArr) {
            ShareInfoRow * listModel = [[ShareInfoRow alloc] initWithDictionary:listDict];
            [self.listMarr addObject:listModel];
        }
        [self.listTable reloadData];
        
        self.listCurrentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.listTotalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.listTable currentPage:self.listCurrentpageNum withTotalPage:self.listTotalPageNum];
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 搜索选择语境
- (void)networkSearchData:(NSString *)keyword {
    [SVProgressHUD show];
    self.searchListRequest = [FBAPI getWithUrlString:URLShareText requestDictionary:@{@"evt":@"content", @"size":@"10", @"sort":@"0", @"page":@(self.currentpageNum + 1), @"t":@"11", @"q":keyword} delegate:self];
    [self.searchListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * listArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * listDict in listArr) {
            ShareInfoRow * listModel = [[ShareInfoRow alloc] initWithDictionary:listDict];
            [self.shareTextList addObject:listModel];
        }
        [self.shareTextTable reloadData];
        
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.shareTextTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark 上拉加载
- (void)addMJRefresh:(UITableView *)table {
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkSearchData:self.searchField.text];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置界面UI
- (void)setEditInfoVcUI {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.listView];
    [self.view addSubview:self.searchView];
}

#pragma mark - 背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImg;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        [_bgImgView addSubview:effectView];
        
        UIView * bgView = [[UIView alloc] initWithFrame:_bgImgView.bounds];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.4];
        [_bgImgView addSubview:bgView];
    }
    return _bgImgView;
}

#pragma mark - 分类列表视图
- (UIView *)listView {
    if (!_listView) {
        _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _listView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        
        [_listView addSubview:self.searchBtn];
        [_listView addSubview:self.listTable];
    }
    return _listView;
}

#pragma mark - 搜索语境按钮
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 32)];
        _searchBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _searchBtn.layer.borderWidth = 0.5f;
        _searchBtn.layer.cornerRadius = 4;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn setTitle:NSLocalizedString(@"SearchContent", nil) forState:(UIControlStateNormal)];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:0.8] forState:(UIControlStateNormal)];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchBtn setImage:[UIImage imageNamed:@"Search"] forState:(UIControlStateNormal)];
        [_searchBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _searchBtn;
}

#pragma mark - 跳转搜索语境视图
- (void)searchBtnClick {
    CGRect changeListRect = CGRectMake(-SCREEN_WIDTH, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [UIView animateWithDuration:.3 animations:^{
        self.listView.frame = changeListRect;
    }];
    
    CGRect changeSearchRect = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [UIView animateWithDuration:.3 animations:^{
        self.searchView.frame = changeSearchRect;
    }];
    [self.searchField becomeFirstResponder];
}

#pragma mark - 滑动导航栏
- (FBMenuView *)categoryMenuView {
    if (!_categoryMenuView) {
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH, 54)];
        _categoryMenuView.delegate = self;
        _categoryMenuView.menuTitle = self.categoryTitleMarr;
        _categoryMenuView.backgroundColor = [UIColor clearColor];
        _categoryMenuView.defaultColor = @"#FFFFFF";
        _categoryMenuView.viewLine.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.3];
        [_categoryMenuView updateMenuButtonData];
        [_categoryMenuView updateMenuBtnState:0];
    }
    return _categoryMenuView;
}

#pragma mark - 点击导航
- (void)menuItemSelectedWithIndex:(NSInteger)index {
    _categoryId = self.categoryIdMarr[index];
    [self.listMarr removeAllObjects];
    self.listCurrentpageNum = 0;
    [self networkContentList:_categoryId];
}

#pragma mark - 分类语境列表
- (UITableView *)listTable {
    if (!_listTable) {
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, SCREEN_WIDTH, SCREEN_HEIGHT - 95)];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.tableFooterView = [UIView new];
        _listTable.estimatedRowHeight = 100;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        
        if (self.listCurrentpageNum < self.listTotalPageNum) {
            [self networkContentList:_categoryId];
        } else {
            [_listTable.mj_footer endRefreshing];
        }
    }
    return _listTable;
}

#pragma mark - 搜索列表视图
- (UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        
        [_searchView addSubview:self.searchField];
        [_searchView addSubview:self.cancelSearchBtn];
        [_searchView addSubview:self.shareTextTable];
    }
    return _searchView;
}

#pragma mark - 顶部Nav条
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.3];
        [_topView addSubview:self.clooseBtn];
    }
    return _topView;
}

#pragma mark -  关闭
- (UIButton *)clooseBtn {
    if (!_clooseBtn) {
        _clooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_clooseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_clooseBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_clooseBtn addTarget:self action:@selector(clooseBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _clooseBtn;
}

- (void)clooseBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 添加搜索框视图
- (UITextField *)searchField {
    if (!_searchField) {
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 26.4)];
        _searchField.delegate = self;
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchField.font = [UIFont systemFontOfSize:13];
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7];
        _searchField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        _searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"SearchContent", nil) attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:.8]}];
        _searchField.layer.cornerRadius = 5;
        _searchField.layer.masksToBounds = YES;
        
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26.4)];
        [icon setImage:[UIImage imageNamed:@"icon_search_white"] forState:(UIControlStateNormal)];
        _searchField.leftView = icon;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect searchFildRect = CGRectMake(10, 10, SCREEN_WIDTH - 60, 26.4);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchField.frame = searchFildRect;
        self.cancelSearchBtn.alpha = 1;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect searchFildRect = CGRectMake(10, 10, SCREEN_WIDTH - 20, 26.4);
    [UIView animateWithDuration:0.3 animations:^{
        self.searchField.frame = searchFildRect;
        self.cancelSearchBtn.alpha = 0;
    }];
}

#pragma mark - 搜索文字
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchField) {
        [_searchField resignFirstResponder];
        if ([self.searchField.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"noKeyword", nil)];
            
        } else {
            [self.shareTextList removeAllObjects];
            self.currentpageNum = 0;
            [self networkSearchData:textField.text];
        }
    }
    return YES;
}

#pragma mark 取消搜索
- (UIButton *)cancelSearchBtn {
    if (!_cancelSearchBtn) {
        _cancelSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 40, 26)];
        _cancelSearchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelSearchBtn setTitle:NSLocalizedString(@"cancel", nil) forState:(UIControlStateNormal)];
        [_cancelSearchBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:.7] forState:(UIControlStateNormal)];
        _cancelSearchBtn.alpha = 0;
        [_cancelSearchBtn addTarget:self action:@selector(cancelSearchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelSearchBtn;
}

- (void)cancelSearchBtnClick {
    [self.searchField resignFirstResponder];
    CGRect changeListRect = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [UIView animateWithDuration:.3 animations:^{
        self.listView.frame = changeListRect;
    }];
    
    CGRect changeSearchRect = CGRectMake(SCREEN_WIDTH, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    [UIView animateWithDuration:.3 animations:^{
        self.searchView.frame = changeSearchRect;
    }];
}

#pragma mark 搜索文字结果列表
- (UITableView *)shareTextTable {
    if (!_shareTextTable) {
        _shareTextTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, SCREEN_WIDTH, SCREEN_HEIGHT - 90) style:(UITableViewStylePlain)];
        _shareTextTable.delegate = self;
        _shareTextTable.dataSource = self;
        _shareTextTable.tableFooterView = [UIView new];
        _shareTextTable.estimatedRowHeight = 100;
        _shareTextTable.showsVerticalScrollIndicator = NO;
        _shareTextTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        [self addMJRefresh:_shareTextTable];
    }
    return _shareTextTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.listTable) {
        return self.listMarr.count;
    } else if (tableView == self.shareTextTable) {
        return self.shareTextList.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.shareTextTable) {
        static NSString * shareTextListCellID = @"ShareTextListCellID";
        ShareSearchTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:shareTextListCellID];
        if (!cell) {
            cell = [[ShareSearchTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:shareTextListCellID];
        }
        if (self.shareTextList.count) {
            [cell setShareTextData:self.shareTextList[indexPath.row]];
        }
        return cell;
    
    } else if (tableView == self.listTable) {
        static NSString * shareTextListCellID = @"ShareTextListCellID";
        ShareSearchTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:shareTextListCellID];
        if (!cell) {
            cell = [[ShareSearchTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:shareTextListCellID];
        }
        if (self.listMarr.count) {
            [cell setShareTextData:self.listMarr[indexPath.row]];
        }
        return cell;
    }
    return nil;
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.shareTextTable) {
        ShareInfoRow * shareInfoRow = self.shareTextList[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:^{
            self.getEdtiShareText(shareInfoRow.title , shareInfoRow.des, shareInfoRow.tags);
        }];
    } else if (tableView == self.listTable) {
        ShareInfoRow * listInfoRow = self.listMarr[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:^{
            self.getEdtiShareText(listInfoRow.title , listInfoRow.des, listInfoRow.tags);
        }];
    }
}

#pragma mark -
- (NSMutableArray *)listMarr {
    if (!_listMarr) {
        _listMarr = [NSMutableArray array];
    }
    return _listMarr;
}

- (NSMutableArray *)shareTextList {
    if (!_shareTextList) {
        _shareTextList = [NSMutableArray array];
    }
    return _shareTextList;
}

- (NSMutableArray *)categoryTitleMarr {
    if (!_categoryTitleMarr) {
        _categoryTitleMarr = [NSMutableArray array];
    }
    return _categoryTitleMarr;
}

- (NSMutableArray *)categoryIdMarr {
    if (!_categoryIdMarr) {
        _categoryIdMarr = [NSMutableArray array];
    }
    return _categoryIdMarr;
}


@end
