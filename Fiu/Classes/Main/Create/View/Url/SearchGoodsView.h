//
//  SearchGoodsView.h
//  Fiu
//
//  Created by FLYang on 16/5/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SearchGoodsView : UIView <UIWebViewDelegate>

@pro_strong UIButton          *   backBtn;          //  返回
@pro_strong UIButton          *   closeBtn;         //  关闭
@pro_strong UIButton          *   findDoneBtn;      //  找到商品
@pro_strong UIWebView         *   goodsWeb;         //  搜索商品网页
@pro_strong NSString          *   goodsUrl;         //  搜索链接

@pro_strong NSString          *   findGoodsId;      //  找到的商品id
@pro_strong NSString          *   findGoodsUrl;     //  商品的链接

@end
