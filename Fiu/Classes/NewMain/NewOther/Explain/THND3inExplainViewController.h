//
//  THND3inExplainViewController.h
//  Fiu
//
//  Created by FLYang on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THND3inExplainViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *webView;

@end
