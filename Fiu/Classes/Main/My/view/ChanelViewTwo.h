//
//  ChanelViewTwo.h
//  Fiu
//
//  Created by THN-Dong on 16/3/31.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChanelViewTwo : UIView

@property (weak, nonatomic) IBOutlet UIButton *orderBtn;//订单按钮
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;//消息按钮
@property (weak, nonatomic) IBOutlet UIButton *subscribeBtn;//订阅按钮
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;//赞过按钮
@property (weak, nonatomic) IBOutlet UIButton *integralBtn;//积分按钮
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;//礼券按钮
@property (weak, nonatomic) IBOutlet UIButton *shippingAddressBtn;//收货地址按钮
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;//服务条款按钮
@property (weak, nonatomic) IBOutlet UIButton *accountManagementBtn;//账户管理按钮






+(instancetype)getChanelViewTwo;

@end
