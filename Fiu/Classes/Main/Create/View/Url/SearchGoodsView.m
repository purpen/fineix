//
//  SearchGoodsView.m
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SearchGoodsView.h"

@implementation SearchGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setViewUI];
    }
    return self;
}

#pragma mark - 设置视图
- (void)setViewUI {
    [self addSubview:self.backBtn];
    [self addSubview:self.closeBtn];
    
    [self addSubview:self.goodsWeb];
}


#pragma mark -
- (UIWebView *)goodsWeb {
    if (!_goodsWeb) {
        _goodsWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50)];
        _goodsWeb.delegate = self;
        _goodsWeb.scrollView.showsVerticalScrollIndicator = NO;
        _goodsWeb.scrollView.showsHorizontalScrollIndicator = NO;
        _goodsWeb.scrollView.bounces = NO;
        _goodsWeb.backgroundColor = [UIColor colorWithHexString:lineGrayColor alpha:1];
    }
    return _goodsWeb;
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    
    NSString * urlStr = webView.request.URL.absoluteString;
    NSLog(@"当前页面的链接：%@", urlStr);
    
    if ([urlStr containsString:@"id"]) {
        [self addSubview:self.findDoneBtn];
        NSRange range = [urlStr rangeOfString:@"id="];
        NSRange rrange = [urlStr rangeOfString:@"&"];
        NSInteger idLength = rrange.location - (range.location + 3);
        NSRange idRange = NSMakeRange(range.location + 3, idLength);
        self.findGoodsId = [urlStr substringWithRange:idRange];
        NSLog(@"搜素到的商品id === %@ ", self.findGoodsId);
    }
}

#pragma mark - 找到商品“按钮”
- (UIButton *)findDoneBtn {
    if (!_findDoneBtn) {
        _findDoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49)];
        _findDoneBtn.backgroundColor = [UIColor colorWithHexString:fineixColor];
        [_findDoneBtn setTitle:@"找到" forState:(UIControlStateNormal)];
        [_findDoneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _findDoneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
       
    }
    return _findDoneBtn;
}

#pragma mark - 返回按钮
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
    }
    return _backBtn;
}

#pragma mark - 关闭按钮
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
        [_closeBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_closeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _closeBtn;
}


@end
