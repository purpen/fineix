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
    
    [self networkReShareTextData];
    
    [self setEditInfoVcUI];
}

#pragma mark - 网络请求
#pragma mark 推荐文字
- (void)networkReShareTextData {
    [SVProgressHUD show];
    self.shareTextRequest = [FBAPI getWithUrlString:URLShareText requestDictionary:@{@"evt":@"tag", @"size":@"30", @"sort":@"0", @"t":@"11", @"q":_sceneTags} delegate:self];
    [self.shareTextRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * listArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * listDict in listArr) {
            ShareInfoRow * listModel = [[ShareInfoRow alloc] initWithDictionary:listDict];
            [self.searchList addObject:listModel];
        }
        [self.searchListTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

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
    [self.view addSubview:self.editShareTextView];
    [self.view addSubview:self.textSearchView];
}

#pragma mark - 搜索文字列表
#pragma mark 推荐文字
- (UITableView *)searchListTable {
    if (!_searchListTable) {
        _searchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 264, SCREEN_WIDTH, SCREEN_HEIGHT - 264) style:(UITableViewStylePlain)];
        _searchListTable.delegate = self;
        _searchListTable.dataSource = self;
        _searchListTable.tableFooterView = [UIView new];
        _searchListTable.estimatedRowHeight = 100;
        _searchListTable.showsVerticalScrollIndicator = NO;
        _searchListTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    }
    return _searchListTable;
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
    if (tableView == self.searchListTable) {
        return self.searchList.count;
    } else if (tableView == self.shareTextTable) {
        return self.shareTextList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchListTable) {
        static NSString * searchTextListCellID = @"SearchTextListCellID";
        ShareSearchTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:searchTextListCellID];
        if (!cell) {
            cell = [[ShareSearchTextTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:searchTextListCellID];
        }
        if (self.searchList.count) {
            [cell setShareTextData:self.searchList[indexPath.row]];
        }
        return cell;
    
    } else if (tableView == self.shareTextTable) {
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchListTable) {
        if ([[self.searchList[indexPath.row] valueForKey:@"title"] length] > 0) {
            self.editTitle.text = [self.searchList[indexPath.row] valueForKey:@"title"];
            self.editDes.text = [self.searchList[indexPath.row] valueForKey:@"content"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                self.getEdtiShareText(self.editTitle.text, self.editDes.text, [self.searchList[indexPath.row] valueForKey:@"oid"]);
            }];
        }
        
    } else if (tableView == self.shareTextTable) {
        if ([[self.shareTextList[indexPath.row] valueForKey:@"title"] length] > 0) {
            self.editTitle.text = [self.shareTextList[indexPath.row] valueForKey:@"title"];
            self.editDes.text = [self.shareTextList[indexPath.row] valueForKey:@"content"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                self.getEdtiShareText(self.editTitle.text, self.editDes.text, [self.shareTextList[indexPath.row] valueForKey:@"oid"]);
            }];
        }
    }
}

#pragma mark - 编辑标题
- (UITextField *)editTitle {
    if (!_editTitle) {
        _editTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 44)];
        _editTitle.text = [NSString stringWithFormat:@"%@", self.afterTitle];
        _editTitle.font = [UIFont systemFontOfSize:14];
        _editTitle.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7];
        _editTitle.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        _editTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
        _editTitle.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        _editTitle.leftViewMode = UITextFieldViewModeAlways;
    }
    return _editTitle;
}

#pragma mark - 编辑内容描述
- (UITextView *)editDes {
    if (!_editDes) {
        _editDes = [[UITextView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, 88)];
        _editDes.text = [NSString stringWithFormat:@"%@", self.afterDes];
        _editDes.font = [UIFont systemFontOfSize:14];
        _editDes.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7];
        _editDes.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        [_editDes setTextContainerInset:(UIEdgeInsetsMake(5, 5, 5, 5))];
    }
    return _editDes;
}

#pragma mark - 搜索按钮
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 212, SCREEN_WIDTH - 20, 26.5)];
        _searchBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        _searchBtn.layer.cornerRadius = 5;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn addTarget:self action:@selector(openSearchView) forControlEvents:(UIControlEventTouchUpInside)];
        [_searchBtn setImage:[UIImage imageNamed:@"icon_search_white"] forState:(UIControlStateNormal)];
        [_searchBtn setTitle:@"搜索文字" forState:(UIControlStateNormal)];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:.7] forState:(UIControlStateNormal)];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _searchBtn;
}

- (void)openSearchView {
    CGRect searchViewRect = self.textSearchView.frame;
    searchViewRect.origin.x = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.textSearchView.frame = searchViewRect;
    }];
    
    CGRect editShareView = self.editShareTextView.frame;
    editShareView.origin.x = -SCREEN_WIDTH;
    [UIView animateWithDuration:.3 animations:^{
        self.editShareTextView.frame = editShareView;
    }];
    
    [self.searchView becomeFirstResponder];
}

#pragma mark - 添加搜索框视图
- (UITextField *)searchView {
    if (!_searchView) {
        _searchView = [[UITextField alloc] initWithFrame:CGRectMake(10, 54, SCREEN_WIDTH - 20, 26.5)];
        _searchView.delegate = self;
        _searchView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchView.font = [UIFont systemFontOfSize:13];
        _searchView.returnKeyType = UIReturnKeySearch;
        _searchView.textColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.7];
        _searchView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.4];
        _searchView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索文字" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF" alpha:.8]}];
        _searchView.layer.cornerRadius = 5;
        _searchView.layer.masksToBounds = YES;
        
        UIButton * icon = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 26.5)];
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

#pragma mark - 默认视图
- (UIView *)editShareTextView {
    if (!_editShareTextView) {
        _editShareTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        UILabel * lineBg = [[UILabel alloc] initWithFrame:CGRectMake(0, 259, SCREEN_WIDTH, 1)];
        lineBg.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:.5];
    
        [_editShareTextView addSubview:self.topView];
        [_editShareTextView addSubview:self.editTitle];
        [_editShareTextView addSubview:self.editDes];
        [_editShareTextView addSubview:lineBg];
        [_editShareTextView addSubview:self.searchBtn];
        [_editShareTextView addSubview:self.searchListTable];
    }
    return _editShareTextView;
}

#pragma mark - 搜索视图
- (UIView *)textSearchView {
    if (!_textSearchView) {
        _textSearchView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        UIView * top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        top.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:.5];
        
        UIButton * back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [back setImage:[UIImage imageNamed:@"return"] forState:(UIControlStateNormal)];
        [back addTarget:self action:@selector(backShareTextView) forControlEvents:(UIControlEventTouchUpInside)];
        [top addSubview:back];
        
        [_textSearchView addSubview:top];
        [_textSearchView addSubview:self.searchView];
        [_textSearchView addSubview:self.shareTextTable];
    }
    return _textSearchView;
}

- (void)backShareTextView {
    CGRect searchViewRect = self.textSearchView.frame;
    searchViewRect.origin.x = SCREEN_WIDTH;
    [UIView animateWithDuration:.3 animations:^{
        self.textSearchView.frame = searchViewRect;
    }];
    
    CGRect editShareView = self.editShareTextView.frame;
    editShareView.origin.x = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.editShareTextView.frame = editShareView;
    }];
    
    [self.searchView resignFirstResponder];
}

#pragma mark - 背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_bgImgView downloadImage:self.bgImg place:[UIImage imageNamed:@""]];
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        [_bgImgView addSubview:effectView];
        effectView.alpha = .5f;

        UIView * bgView = [[UIView alloc] initWithFrame:_bgImgView.bounds];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.4];
        [_bgImgView addSubview:bgView];
    }
    return _bgImgView;
}

#pragma mark - 顶部视图
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:.5];
        
        [_topView addSubview:self.shareBtn];
    }
    return _topView;
}

#pragma mark - 完成
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44)];
        [_shareBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_shareBtn setTitle:NSLocalizedString(@"Done", nil) forState:(UIControlStateNormal)];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_shareBtn addTarget:self action:@selector(doneItemSelected) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBtn;
}

- (void)doneItemSelected {
    [self dismissViewControllerAnimated:YES completion:^{
        self.getEdtiShareText(self.editTitle.text, self.editDes.text, @"");
    }];
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
