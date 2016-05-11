//
//  CounterModel.h
//  Fiu
//
//  Created by dys on 16/4/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CounterModel : NSObject

@property(nonatomic,strong) NSNumber *message_count;
@property(nonatomic,strong) NSNumber *fiu_comment_count;
@property(nonatomic,strong) NSNumber *fiu_notice_count;
@property(nonatomic,strong) NSNumber *sight_love_count;
@property(nonatomic,strong) NSNumber *message_total_count;
@property(nonatomic,strong) NSNumber *order_wait_payment;
@property(nonatomic,strong) NSNumber *order_ready_goods;
@property(nonatomic,strong) NSNumber *order_sended_goods;
@property(nonatomic,strong) NSNumber *order_evaluate;
@property(nonatomic,strong) NSNumber *order_total_count;
@property(nonatomic,strong) NSNumber *fans_count;
@property(nonatomic,strong) NSNumber *subscription_count;
@property(nonatomic,strong) NSNumber *alert_count;
@property(nonatomic,strong) NSNumber *fiu_alert_count;

@end
