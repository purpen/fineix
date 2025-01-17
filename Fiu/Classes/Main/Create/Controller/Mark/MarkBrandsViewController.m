//
//  MarkBrandsViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MarkBrandsViewController.h"
#import "THNSearchBrandTableViewCell.h"
#import "THNSearchGoodsTableViewCell.h"
#import "FiuBrandRow.h"
#import "GoodsRow.h"

static NSString *const URLBrandList = @"/search/getlist";
static NSString *const URLGoodsList = @"/product/getlist";

static NSString *const brandCellId = @"BrandCellId";
static NSString *const goodsCellId = @"GoodsCellId";

@interface MarkBrandsViewController () {
    NSString *_chooseBrandTitle;
    NSString *_chooseBrandId;
}

@property (nonatomic, strong) NSMutableArray *brandMarr;
@property (nonatomic, strong) NSMutableArray *brandTitleMarr;
@property (nonatomic, strong) NSMutableArray *brandIdMarr;
@property (nonatomic, strong) NSMutableArray *goodsMarr;
@property (nonatomic, strong) NSMutableArray *goodsIdMarr;

@end

@implementation MarkBrandsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

#pragma mark - 网络请求
#pragma mark 品牌列表
- (void)networkSearchBrand:(NSString *)keyword {
    [self.brandMarr removeAllObjects];
    [self.brandIdMarr removeAllObjects];
    
    self.brandRequest = [FBAPI getWithUrlString:URLBrandList requestDictionary:@{@"q":keyword, @"t":@"13", @"evt":@"content", @"size":@"1000"} delegate:self];
    [self.brandRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.brandTitleMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title"]];
        self.brandIdMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"]];
        self.brandMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"cover_url"]];
        if (self.brandTitleMarr.count) {
            self.brandList.hidden = NO;
            self.addGoodBtn.hidden = YES;
            [self.brandList reloadData];
            
        } else {
            self.brandList.hidden = YES;
            [self.addGoodBtn setAddGoodsOrBrandInfo:1 withText:self.searchGoods.searchInputBox.text];
            self.addGoodBtn.hidden = NO;
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 产品
- (void)networkBrandOfGoods:(NSString *)brandId {
    self.goodsRequest = [FBAPI getWithUrlString:URLGoodsList requestDictionary:@{@"brand_id":brandId, @"size":@"1000", @"stage":@"9,16"} delegate:self];
    [self.goodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.goodsMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"title"]];
        self.goodsIdMarr = [NSMutableArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"rows"] valueForKey:@"_id"]];
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
    [self.view addSubview:self.brandList];
    [self.view addSubview:self.goodsList];
    [self.view addSubview:self.addGoodBtn];
}

- (UITableView *)goodsList {
    if (!_goodsList) {
        _goodsList = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame))];
        _goodsList.delegate = self;
        _goodsList.dataSource = self;
        _goodsList.showsVerticalScrollIndicator = NO;
        _goodsList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _goodsList.tableFooterView = [UIView new];
    }
    return _goodsList;
}

- (UITableView *)brandList {
    if (!_brandList) {
        _brandList = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame))];
        _brandList.delegate = self;
        _brandList.dataSource = self;
        _brandList.showsVerticalScrollIndicator = NO;
        _brandList.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _brandList.tableFooterView = [UIView new];
    }
    return _brandList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.brandList) {
        return self.brandTitleMarr.count;
    } else if (tableView == self.goodsList) {
        return self.goodsMarr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.brandList) {
        THNSearchBrandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:brandCellId];
        cell = [[THNSearchBrandTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:brandCellId];
        if (self.brandTitleMarr.count) {
            [cell setBrandDataWithTitle:self.brandTitleMarr[indexPath.row] withImage:self.brandMarr[indexPath.row]];
        }
        return cell;
    
    } else if (tableView == self.goodsList) {
        THNSearchGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
        cell = [[THNSearchGoodsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:goodsCellId];
        if (self.goodsMarr.count) {
            [cell setGoodsInfo:_chooseBrandTitle withGoods:self.goodsMarr[indexPath.row]];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.brandList) {
        return 80;
    } else if (tableView == self.goodsList) {
        return 44;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.brandList) {
        if (self.brandIdMarr.count) {
            _chooseBrandTitle = self.brandTitleMarr[indexPath.row];
            _chooseBrandId = self.brandIdMarr[indexPath.row];
            [self setBrandName:_chooseBrandTitle type:1];
            [self networkBrandOfGoods:self.brandIdMarr[indexPath.row]];
        }
        
    } else if (tableView == self.goodsList) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.getBrandAndGoodsInfoBlock(_chooseBrandTitle,
                                           _chooseBrandId,
                                           self.goodsMarr[indexPath.row],
                                           [NSString stringWithFormat:@"%zi", [self.goodsIdMarr[indexPath.row] integerValue]]);
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.searchGoods.searchInputBox resignFirstResponder];
}

#pragma mark - 搜索框固定品牌名称
- (void)setBrandName:(NSString *)title type:(NSInteger)type {
    CGSize width = [title boundingRectWithSize:CGSizeMake(320, 0)
                                       options:(NSStringDrawingUsesFontLeading)
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                       context:nil].size;
    
    self.brandNameBtn.frame = CGRectMake(0, 0, width.width * 1.3, 30);
    [self.brandNameBtn setTitle:title forState:(UIControlStateNormal)];
    self.searchGoods.searchInputBox.leftViewMode = UITextFieldViewModeAlways;
    
    self.searchGoods.searchInputBox.text = @"";
    self.searchGoods.searchInputBox.placeholder = NSLocalizedString(@"pleaseWriteGoods", nil);
    [self.searchGoods.searchInputBox becomeFirstResponder];
    
    
    CGRect goodsListFrame = CGRectMake(0, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame));
    CGRect brandListFrame = CGRectMake(-SCREEN_WIDTH, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame));
    self.goodsList.frame = goodsListFrame;
    self.brandList.frame = brandListFrame;
    
    if (type == 1) {
        [self.addGoodBtn setAddGoodsOrBrandInfo:2 withText:@""];
    } else if (type == 2) {
        [self.addGoodBtn setAddGoodsOrBrandInfo:1 withText:@""];
    }
}

- (UIButton *)brandNameBtn {
    if (!_brandNameBtn) {
        _brandNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
        _brandNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_brandNameBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:(UIControlStateNormal)];
    }
    return _brandNameBtn;
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        CGFloat searchGoodsHeight = Is_iPhoneX ? 88 : 64;
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, searchGoodsHeight)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"pleaseWriteBrand", nil);
        _searchGoods.delegate = self;
        [_searchGoods.searchInputBox becomeFirstResponder];
        _searchGoods.searchInputBox.returnKeyType = UIReturnKeyDone;
        _searchGoods.searchInputBox.leftView = self.brandNameBtn;
        _searchGoods.searchInputBox.leftViewMode = UITextFieldViewModeAlways;
        [_searchGoods.searchInputBox addTarget:self action:@selector(searchKeyword:) forControlEvents:(UIControlEventEditingChanged)];
    }
    return _searchGoods;
}

- (void)searchKeyword:(UITextField *)textField {
    if (self.brandNameBtn.titleLabel.text.length == 0 && ![textField.text isEqualToString:@""]) {
        [self networkSearchBrand:textField.text];
        
    } else {
        self.addGoodBtn.hidden = NO;
        self.goodsList.hidden = YES;
        [self.addGoodBtn setAddGoodsOrBrandInfo:2 withText:textField.text];
    }
}

#pragma mark - 取消搜索
- (void)cancelSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 没有搜索结果时自定义添加
- (THNAddGoodsBtn *)addGoodBtn {
    if (!_addGoodBtn) {
        _addGoodBtn = [[THNAddGoodsBtn alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, 44)];
        _addGoodBtn.hidden = YES;
        [_addGoodBtn addTarget:self action:@selector(addUserGoodsInfo:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _addGoodBtn;
}

- (void)addUserGoodsInfo:(THNAddGoodsBtn *)button {
    if (self.brandNameBtn.titleLabel.text.length == 0) {
        [self setBrandName:button.name.text type:2];
        [button setAddGoodsOrBrandInfo:2 withText:@""];
        CGRect goodsListFrame = CGRectMake(0, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame));
        CGRect brandListFrame = CGRectMake(-SCREEN_WIDTH, CGRectGetHeight(self.searchGoods.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.searchGoods.frame));
        self.goodsList.frame = goodsListFrame;
        self.brandList.frame = brandListFrame;
        
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            self.getBrandAndGoodsInfoBlock(self.brandNameBtn.titleLabel.text, _chooseBrandId, button.name.text, @"");
        }];
    }
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navTitle.hidden = YES;
}

#pragma mark - NSMutablerArray
- (NSMutableArray *)brandMarr {
    if (!_brandMarr) {
        _brandMarr = [NSMutableArray array];
    }
    return _brandMarr;
}

- (NSMutableArray *)brandIdMarr {
    if (!_brandIdMarr) {
        _brandIdMarr = [NSMutableArray array];
    }
    return _brandIdMarr;
}

- (NSMutableArray *)brandTitleMarr {
    if (!_brandTitleMarr) {
        _brandTitleMarr = [NSMutableArray array];
    }
    return _brandTitleMarr;
}

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
