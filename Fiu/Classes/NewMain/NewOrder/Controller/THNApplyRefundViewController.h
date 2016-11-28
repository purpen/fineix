//
//  THNApplyRefundViewController.h
//  Fiu
//
//  Created by FLYang on 2016/11/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNApplyRefundView.h"

@interface THNApplyRefundViewController : THNViewController <
    THNApplyRefundViewDelegate
>

@property (nonatomic, strong) THNApplyRefundView *applyView;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *skuId;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) UIButton *applyBtn;
@property (nonatomic, strong) FBRequest *refundRequest;
@property (nonatomic, strong) FBRequest *applyRequest;
@property (nonatomic, strong) NSMutableDictionary *applyDict;

@end
