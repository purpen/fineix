//
//  AddUrlViewController.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AddUrlViewController.h"
#import "TaoBaoGoodsResult.h"

static NSString *const URLTaobaoGoods = @"/scene_product/tb_view";

@interface AddUrlViewController ()

@pro_strong TaoBaoGoodsResult     *   taobaoGoodsData;

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
- (void)networkSearchGoodsData {
    [SVProgressHUD show];
    self.findGoodsRequest = [FBAPI getWithUrlString:URLTaobaoGoods requestDictionary:@{@"ids":self.goodsId} delegate:self];
    [self.findGoodsRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.taobaoGoodsData = [[TaoBaoGoodsResult alloc] initWithDictionary:[[result valueForKey:@"data"] valueForKey:@"results"]];
        [self.findGoodsView setFindGoodsViewData:self.taobaoGoodsData];
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
    [self.view addSubview:self.searchGoodsView];

    //  搜索的汉字转换URL编码
    NSString * urlStr = [searchKeyword stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.goodsUrl = [NSString stringWithFormat:@"http://s.m.taobao.com/h5?q=%@", urlStr];
    //  加载搜索商品web
    [self.searchGoodsView.goodsWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsUrl]]];
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
    NSLog(@"点击了第＝＝＝＝ %zi ＝＝＝＝＝", index);
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
        [self networkSearchGoodsData];
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
    NSLog(@"商品标题：%@ --- 价格：%@", self.findGoodsView.goodsTitle.text, self.findGoodsView.goodsPrice.text);
    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"%@--%@",self.findGoodsView.goodsTitle.text, self.findGoodsView.goodsPrice.text]];
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
