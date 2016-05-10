//
//  AddUrlViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddUrlViewController.h"
#import "TaoBaoGoodsResult.h"
#import "JDGoodsListproductbaseResult.h"

static NSString *const URLTaobaoGoods = @"/scene_product/tb_view";
static NSString *const URLJDGoods = @"/scene_product/jd_view";
static NSString *const URLUserAddGoods = @"/scene_product/add";

static NSString *const TaoBao = @"http://s.m.taobao.com/h5?q=";
static NSString *const JD = @"http://m.jd.com/ware/search.action?keyword=";
static NSString *const Tmall = @"https://s.m.tmall.com/m/search.htm?q=";

@interface AddUrlViewController () {
    NSInteger   _type;
}

@pro_strong TaoBaoGoodsResult               *   taobaoGoodsData;
@pro_strong JDGoodsListproductbaseResult    *   JDGoodsData;

@end

@implementation AddUrlViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setAddUrlVcUI];
}

#pragma mark - 网络请求
#pragma mark 获取商品信息
- (void)networkSearchGoodsData:(NSInteger)type {
    [SVProgressHUD show];
    if (type == 1 || type == 2) {
        self.findGoodsRequest = [FBAPI getWithUrlString:URLTaobaoGoods requestDictionary:@{@"ids":self.goodsId} delegate:self];
        [self.findGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
            self.taobaoGoodsData = [[TaoBaoGoodsResult alloc] initWithDictionary:[[result valueForKey:@"data"] valueForKey:@"results"]];
            [self.findGoodsView setFindGoodsViewData:self.taobaoGoodsData];
            [SVProgressHUD dismiss];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];

    } else if (type == 0) {
        self.findGoodsRequest = [FBAPI getWithUrlString:URLJDGoods requestDictionary:@{@"ids":self.goodsId} delegate:self];
        [self.findGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
            self.JDGoodsData = [[JDGoodsListproductbaseResult alloc] initWithDictionary:[[result valueForKey:@"data"] valueForKey:@"listproductbase_result"][0]];
            [self.findGoodsView setJDGoodsViewData:self.JDGoodsData];
            [SVProgressHUD dismiss];
            
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
        }];

    }
    
}

#pragma mark 用户确认添加产品的保存信息
- (void)networkUserAddGoodsData:(NSString *)type {
    // type: 2.淘宝；3.天猫；4.京东
    if (_type == 0) {
        type = @"4";
    } else if (_type == 1) {
        type = @"2";
    } else if (_type == 2) {
        type = @"3";
    }
    
    [SVProgressHUD show];
    self.userAddGoodsRequest = [FBAPI postWithUrlString:URLUserAddGoods requestDictionary:@{@"attrbute":type, @"oid":self.goodsId} delegate:self];
    [self.userAddGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝ %@", result);
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 设置视图UI
- (void)setAddUrlVcUI {
    [self.view addSubview:self.searchGoods];
    
    [self.view addSubview:self.addUrlView];
}

#pragma mark - 添加搜索框视图
- (FBSearchView *)searchGoods {
    if (!_searchGoods) {
        _searchGoods = [[FBSearchView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 44)];
        _searchGoods.searchInputBox.placeholder = NSLocalizedString(@"searchGoods", nil);
        _searchGoods.delegate = self;
    }
    return _searchGoods;
}

#pragma mark - 搜索产品
- (void)beginSearch:(NSString *)searchKeyword {
    [self searchWebGoods:searchKeyword withSite:TaoBao];
    _type = 1;
}

#pragma mark 搜索
- (void)searchWebGoods:(NSString *)searchKeyword withSite:(NSString *)site {
    [self.view addSubview:self.searchGoodsView];
    //  搜索的汉字转换URL编码
    NSString * urlStr = [searchKeyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.goodsUrl = [NSString stringWithFormat:@"%@%@", site,urlStr];
    //  加载搜索商品web
    [self.searchGoodsView.goodsWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsUrl]]];
    [self.searchGoods.searchInputBox resignFirstResponder];
}

#pragma mark - 购物网站按钮所在的视图
- (AddUrlView *)addUrlView {
    if (!_addUrlView) {
        _addUrlView = [[AddUrlView alloc] initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, 100)];
        _addUrlView.delegate = self;
    }
    return _addUrlView;
}

#pragma mark - 点击购物网站
- (void)webBtnSelectedSearchGoods:(NSInteger)index {
    NSString * key = self.searchGoods.searchInputBox.text;
    if (index == 0) {
        [self searchWebGoods:key withSite:JD];
        _type = 0;
    } else if (index == 1) {
        [self searchWebGoods:key withSite:TaoBao];
        _type = 1;
    } else if (index == 2) {
        [self searchWebGoods:key withSite:Tmall];
        _type = 2;
    }
}

#pragma mark - 搜索商品视图
- (SearchGoodsView *)searchGoodsView {
    if (!_searchGoodsView) {
        _searchGoodsView = [[SearchGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_searchGoodsView.findDoneBtn addTarget:self action:@selector(findDoneBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_searchGoodsView.closeBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [_searchGoodsView.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _searchGoodsView;
}

- (void)findDoneBtnClick {
    if (self.searchGoodsView.findGoodsId.length > 0) {
        self.goodsId = self.searchGoodsView.findGoodsId;
        NSLog(@"找到的商品ID：%@, 链接：%@", self.goodsId, self.searchGoodsView.findGoodsUrl);
        
        [self networkSearchGoodsData:_type];
        [self.view addSubview:self.findGoodsView];
    }
}

#pragma mark - 找到结果视图
- (FindGoodsView *)findGoodsView {
    if (!_findGoodsView) {
        _findGoodsView = [[FindGoodsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_findGoodsView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _findGoodsView;
}

#pragma mark - 确认添加
- (void)sureBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.findGodosBlock(self.findGoodsView.goodsTitle.text, self.findGoodsView.goodsPrice.text);
}

#pragma mark - 设置导航视图
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"addUrl", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    [self addCancelButton:@"icon_cancel_black"];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self addLine];
}

//  关闭
- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//  返回
- (void)backBtnClick {
    [self.searchGoodsView removeFromSuperview];
    [SVProgressHUD dismiss];
}

@end
