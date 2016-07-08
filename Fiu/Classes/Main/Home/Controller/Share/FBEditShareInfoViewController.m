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

static NSString *const URLShareText = @"/search/getlist";

@interface FBEditShareInfoViewController ()

@pro_strong NSMutableArray      *   searchList;
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
    
//    [self networkReShareTextData];
    
    [self setEditInfoVcUI];
}

#pragma mark - 网络请求
#pragma mark 搜索分享文字
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
            [self networkSearchData:self.searchView.text];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 设置界面UI
- (void)setEditInfoVcUI {
    [self.view addSubview:self.bgImgView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.shareTextTable];
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

#pragma mark 搜索文字
- (UITableView *)shareTextTable {
    if (!_shareTextTable) {
        _shareTextTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, SCREEN_HEIGHT - 94) style:(UITableViewStylePlain)];
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
    return self.shareTextList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * shareTextListCellID = @"ShareTextListCellID";
    ShareSearchTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:shareTextListCellID];
    if (!cell) {
        cell = [[ShareSearchTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:shareTextListCellID];
    }
    if (self.shareTextList.count) {
        [cell setShareTextData:self.shareTextList[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShareInfoRow * shareInfoRow = self.shareTextList[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        self.getEdtiShareText(shareInfoRow.title , shareInfoRow.des);
    }];
}

#pragma mark - 添加搜索框视图
- (UITextField *)searchView {
    if (!_searchView) {
        _searchView = [[UITextField alloc] initWithFrame:CGRectMake(10, 54, SCREEN_WIDTH - 20, 26.4)];
        _searchView.delegate = self;
        _searchView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchView.font = [UIFont systemFontOfSize:13];
        _searchView.returnKeyType = UIReturnKeySearch;
        _searchView.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        _searchView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索文字" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:.8]}];
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = YES;
        
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26.4)];
        [icon setImage:[UIImage imageNamed:@"icon_search_white"] forState:(UIControlStateNormal)];
        _searchView.leftView = icon;
        _searchView.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchView;
}

#pragma mark - 搜索文字
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchView) {
        [_searchView resignFirstResponder];
        if ([self.searchView.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"关键词不能为空"];
        
        } else {
            [self.shareTextList removeAllObjects];
            self.currentpageNum = 0;
            [self networkSearchData:textField.text];
        }
    }
    return YES;
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

#pragma mark -
- (NSMutableArray *)searchList {
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (NSMutableArray *)shareTextList {
    if (!_shareTextList) {
        _shareTextList = [NSMutableArray array];
    }
    return _shareTextList;
}

@end
