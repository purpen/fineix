//
//  THNStateHeaderView.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

typedef NS_ENUM(NSUInteger, RefundStage) {
    RefundWait  = 1,    //  进行中
    RefundDone,         //  已完成
    RefundRefuse,       //  拒绝
};

 
@interface THNStateHeaderView : UIView

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *stageLab;    //  状态文字
@property (nonatomic, strong) UILabel *summaryLab;  //  拒绝说明


/**
 退款详情说明

 @param stage 退款状态
 @param summary 拒绝退款说明
 @param type 1:退款／2:退货
 */
- (void)thn_setRefundStage:(RefundStage)stage withSummary:(NSString *)summary type:(NSInteger)type;

@end
