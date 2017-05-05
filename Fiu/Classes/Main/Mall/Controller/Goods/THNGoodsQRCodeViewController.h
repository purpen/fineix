//
//  THNGoodsQRCodeViewController.h
//  Fiu
//
//  Created by FLYang on 2017/5/5.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNQRCodeView.h"

@interface THNGoodsQRCodeViewController : THNViewController

@property (nonatomic, strong) NSString *linkUrl;
@property (nonatomic, strong) THNQRCodeView *mainView;
@property (nonatomic, strong) UIButton *closeButton;

@end
