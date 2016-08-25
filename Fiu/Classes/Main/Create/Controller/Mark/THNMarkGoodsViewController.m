//
//  THNMarkGoodsViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMarkGoodsViewController.h"

static NSString *const URLGoodsList = @"/product/getlist";
static NSString *const goodsCellId = @"GoodsCellId";

@interface THNMarkGoodsViewController ()

@pro_strong NSMutableArray *goodsMarr;
@pro_strong NSMutableArray *goodsIdMarr;

@end

@implementation THNMarkGoodsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark 产品
- (void)networkBrandOfGoods:(NSString *)title {
    self.goodsRequest = [FBAPI getWithUrlString:URLGoodsList requestDictionary:@{@"title":title, @"kind":@"1", @"size":@"1000"} delegate:self];
    [self.goodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title"]];
        self.goodsIdMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"oid"]];
        if (self.goodsMarr.count) {
            self.addGoodBtn.hidden = YES;
            self.goodsList.hidden = NO;
            [self.goodsList reloadData];
        } else {
            self.addGoodBtn.hidden = NO;
            self.goodsList.hidden = YES;
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - 设置视图UI
- (void)setUI {
    [self.view addSubview:self.searchGoods];
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.addGoodBtn];
}

- (UITableView *)goodsList {
    if (!_goodsList) {
        _goodsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsList.tableFooterView = [UIView new];
    }
    return _goodsList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsCellId];
    if (self.goodsMarr.count) {
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = self.goodsMarr[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:^{
        self.getUserGoodsInfoBlock(self.goodsMarr[indexPath.row], [NSString stringWithFormat:@"%zi", [self.goodsIdMarr[indexPath.row] integerValue]]);
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.searchGoods.searchInputBox resignFirstResponder];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"pleaseWriteGoods", nil);
        _searchGoods.delegate = self;
        [_searchGoods.searchInputBox becomeFirstResponder];
        [_searchGoods.searchInputBox addTarget:self action:@selector(searchKeyword:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _searchGoods;
}

- (void)searchKeyword:(UITextField *)textField {
    [self.addGoodBtn setAddGoodsOrBrandInfo:2 withText:textField.text];
    if (![textField.text isEqualToString:@""]) {
        [self networkBrandOfGoods:textField.text];
    }
}

#pragma mark - 没有搜索结果时自定义添加
- (THNAddGoodsBtn *)addGoodBtn {
    if (!_addGoodBtn) {
        _addGoodBtn = [[THNAddGoodsBtn alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
        _addGoodBtn.hidden = YES;
        [_addGoodBtn addTarget:self action:@selector(addUserGoodsInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addGoodBtn;
}

- (void)addUserGoodsInfo:(THNAddGoodsBtn *)button {
    if (self.searchGoods.searchInputBox.text.length > 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.getUserGoodsInfoBlock(self.searchGoods.searchInputBox.text, @"");
        }];
    }
}

#pragma mark - 取消搜索
- (void)cancelSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navTitle.hidden = YES;
}

#pragma mark - NSMutableArray
- (NSMutableArray *)goodsMarr {
    if (!_goodsMarr) {
        _goodsMarr = [NSMutableArray array];
    }
    return _goodsMarr;
}

- (NSMutableArray *)goodsIdMarr {
    if (!_goodsIdMarr) {
        _goodsIdMarr = [NSMutableArray array];
    }
    return _goodsIdMarr;
}

@end
