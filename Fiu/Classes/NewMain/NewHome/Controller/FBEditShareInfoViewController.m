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
#import "THNAddTagViewController.h"

static NSInteger const MAXTitle = 20;
static NSString *const URLCategroy = @"/category/getlist";
static NSString *const URLShareText = @"/search/getlist";
static NSString *const URLListText = @"/scene_context/getlist";
static NSString *const URLActionTags = @"/scene_sight/stick_active_tags";

@interface FBEditShareInfoViewController () {
    NSString *_categoryId;
    NSString *_actionTag;
    NSString *_actionTagId;
}

@pro_strong NSMutableArray *categoryTitleMarr;
@pro_strong NSMutableArray *categoryIdMarr;
@pro_strong NSMutableArray *listMarr;
@pro_strong NSMutableArray *shareTextList;
@pro_strong NSMutableArray *userAddTagMarr;

@end

@implementation FBEditShareInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavViewUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.titleText resignFirstResponder];
    [self.desText resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkActionTagData];
    [self networkSceneContentCategory];
    _categoryId = @"0";
    self.listCurrentpageNum = 0;
    [self networkContentList:_categoryId];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.0f];
    [self.view addSubview:self.bgView];
    [self setEditInfoVcUI];
}

#pragma mark -  设置导航栏
- (void)setNavViewUI {
    self.delegate = self;
    [self addNavViewTitle:NSLocalizedString(@"addSceneInfoVC", nil)];
    [self addCloseBtn:@"icon_cancel"];
    [self addSureButton];
}

- (void)thn_sureButtonAction {
    self.getEdtiShareText(self.titleText.text, self.desText.text, self.userAddTagMarr);
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

#pragma mark 活动标签
- (void)networkActionTagData {
    self.actionTagRequest = [FBAPI getWithUrlString:URLActionTags requestDictionary:@{@"type":@"1"} delegate:self];
    [self.actionTagRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *tagArr = [[result valueForKey:@"data"] valueForKey:@"items"][0];
        if (tagArr.count) {
            _actionTag = tagArr[0];
            _actionTagId = tagArr[1];
            [self.keyboardToolbar thn_setRightBarItemContent:_actionTag];
        }
    
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
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
    [self.view addSubview:self.listView];
    [self.view addSubview:self.searchView];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleDark)];
        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffect.frame = self.view.frame;
        [_bgView addSubview:visualEffect];
    }
    return _bgView;
}

#pragma mark - 背景图片
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgImgView.image = self.bgImg;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImgView.clipsToBounds = YES;
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView * effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = _bgImgView.bounds;
        [_bgImgView addSubview:effectView];
        
        UIView * bgView = [[UIView alloc] initWithFrame:_bgImgView.bounds];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:.4];
        [_bgImgView addSubview:bgView];
    }
    return _bgImgView;
}

#pragma mark - 输入标题
- (UITextField *)titleText {
    if (!_titleText) {
        _titleText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _titleText.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.25f];
        _titleText.delegate = self;
        _titleText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"addTitleText", nil)
                                                                           attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#CCCCCC"]}];
        _titleText.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
        _titleText.leftViewMode = UITextFieldViewModeAlways;
        _titleText.font = [UIFont systemFontOfSize:12];
        _titleText.clearButtonMode = UITextFieldViewModeAlways;
        _titleText.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [_titleText addTarget:self action:@selector(maxTitleText:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _titleText;
}

- (void)maxTitleText:(UITextField *)titleText {
    if (titleText.text.length >= MAXTitle) {
        [SVProgressHUD showInfoWithStatus:@"标题不能超过20字"];
//        titleText.text = [titleText.text substringToIndex:MAXTitle];
    }
}

#pragma mark - 输入描述
- (UITextView *)desText {
    if (!_desText) {
        _desText = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 80)];
        _desText.delegate = self;
        _desText.font = [UIFont systemFontOfSize:12];
        _desText.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _desText.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.25f];
        _desText.inputAccessoryView = self.keyboardToolbar;
        _desText.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10);
    }
    return _desText;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.desText) {
        if ([textView.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
            textView.text = @"";
        }
        return YES;
    }
    return NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView == self.desText) {
        if ([textView.text isEqualToString:@""]) {
            textView.text = NSLocalizedString(@"addDescription", nil);
        }
        return YES;
    }
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.desText) {
        if (![textView.text isEqualToString:@""]) {
            NSString *desIdentify = [textView.text substringToIndex:textView.selectedRange.location];
            NSString *isTag = [desIdentify substringFromIndex:desIdentify.length - 1];
            
            if ([isTag isEqualToString:@"#"]) {
                THNAddTagViewController * tagVC = [[THNAddTagViewController alloc] init];
                [self presentViewController:tagVC animated:YES completion:^{
                    tagVC.getAddTagsDataBlock = ^(NSString *tags, NSString *tagsId) {
                        self.actionTag = tagsId;
                        if ([self.desText.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
                            self.desText.text = @"";
                        }
                        NSMutableString *desText = [[NSMutableString alloc] initWithString:self.desText.text];
                        [desText insertString:tags atIndex:self.desText.selectedRange.location];
                        self.desText.text = desText;
                        [self.userAddTagMarr addObject:tags];
                    };
                }];
            }

        }
    }
}

#pragma mark - 键盘工具栏
- (FBKeyboradToolbar *)keyboardToolbar {
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[FBKeyboradToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _keyboardToolbar.thn_delegate = self;
    }
    return _keyboardToolbar;
}

- (void)thn_keyboardLeftBarItemAction {
    THNAddTagViewController *tagVC = [[THNAddTagViewController alloc] init];
    [self presentViewController:tagVC animated:YES completion:^{
        tagVC.getAddTagsDataBlock = ^(NSString *tags, NSString *tagsId) {
            self.actionTag = tagsId;
            if ([self.desText.text isEqualToString:NSLocalizedString(@"addDescription", nil)]) {
                self.desText.text = @"";
            }
            NSMutableString *desText = [[NSMutableString alloc] initWithString:self.desText.text];
            [desText insertString:[NSString stringWithFormat:@"#%@", tags] atIndex:self.desText.selectedRange.location];
            self.desText.text = desText;
            [self.userAddTagMarr addObject:tags];
        };
    }];
}

- (void)thn_keyboardRightBarItemAction:(NSString *)text {
    NSMutableString *desStr = [[NSMutableString alloc] initWithString:self.desText.text];
    [desStr appendString:text];
    self.desText.text = desStr;
}

#pragma mark - 分类列表视图
- (UIView *)listView {
    if (!_listView) {
        _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _listView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        [_listView addSubview:self.titleText];
        [_listView addSubview:self.desText];
        [_listView addSubview:self.searchBtn];
        [_listView addSubview:self.listTable];
    }
    return _listView;
}

#pragma mark - 搜索语境按钮
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 132, SCREEN_WIDTH - 30, 32)];
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
        _categoryMenuView = [[FBMenuView alloc] initWithFrame:CGRectMake(0, 167, SCREEN_WIDTH, 54)];
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
        _listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 218, SCREEN_WIDTH, SCREEN_HEIGHT - 222)];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.tableFooterView = [UIView new];
        _listTable.estimatedRowHeight = 100;
        _listTable.showsVerticalScrollIndicator = NO;
        _listTable.separatorColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0.5f];
        _listTable.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
        _listTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.listCurrentpageNum < self.listTotalPageNum) {
                [self networkContentList:_categoryId];
            } else {
                [_listTable.mj_footer endRefreshing];
            }
        }];
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
    if (textField == self.titleText) {
        
    } else {
        CGRect searchFildRect = CGRectMake(10, 10, SCREEN_WIDTH - 60, 26.4);
        [UIView animateWithDuration:0.3 animations:^{
            self.searchField.frame = searchFildRect;
            self.cancelSearchBtn.alpha = 1;
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.titleText) {
        if (textField.text.length >= MAXTitle) {
            [SVProgressHUD showInfoWithStatus:@"标题不能超过20字"];
        }
        
    } else {
        CGRect searchFildRect = CGRectMake(10, 10, SCREEN_WIDTH - 20, 26.4);
        [UIView animateWithDuration:0.3 animations:^{
            self.searchField.frame = searchFildRect;
            self.cancelSearchBtn.alpha = 0;
        }];
    }
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
        [SVProgressHUD show];
        ShareInfoRow * shareInfoRow = self.shareTextList[indexPath.row];
        [self dismissViewControllerAnimated:YES completion:^{
            self.getEdtiShareText(shareInfoRow.title , shareInfoRow.des, [NSMutableArray arrayWithArray:shareInfoRow.tags]);
            [SVProgressHUD dismiss];
        }];
        
    } else if (tableView == self.listTable) {
        ShareInfoRow *listInfoRow = self.listMarr[indexPath.row];
        self.desText.text = listInfoRow.des;
        self.titleText.text = listInfoRow.title;
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

- (NSMutableArray *)userAddTagMarr {
    if (!_userAddTagMarr) {
        _userAddTagMarr = [NSMutableArray array];
    }
    return _userAddTagMarr;
}

@end
