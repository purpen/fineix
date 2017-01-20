//
//  THNAllianceInfoViewController.h
//  Fiu
//
//  Created by FLYang on 2017/1/20.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNAllianceInfoViewController : THNViewController <
    UIWebViewDelegate
>

@property (nonatomic, strong) FBRequest *infoRequest;
@property (nonatomic, strong) UITextView *infoText;
@property (nonatomic, strong) UIWebView *infoWebView;

@end
