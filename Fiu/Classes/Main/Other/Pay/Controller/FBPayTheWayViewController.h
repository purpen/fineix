//
//  FBPayTheWayViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/5/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@class OrderInfoModel;
@interface FBPayTheWayViewController : FBViewController

@property (nonatomic, strong) OrderInfoModel * orderInfo;

@property (strong, nonatomic) UIView                *       payTheWayView;
@property (strong, nonatomic) UIButton              *       wayBtnSelected;
@property (strong, nonatomic) UIButton              *       chooseWeChatBtn;
@property (strong, nonatomic) UIButton              *       chooseAliPayBtn;
/** jd支付按钮 */
@property (nonatomic, strong) UIButton              *       chooseJDPayBtn;
@property (strong, nonatomic) UIButton              *       okPayBtn;
@property (strong, nonatomic) UIView                *       payWayView;
@property (strong, nonatomic) UILabel               *       payWayTitleView;
@property (strong, nonatomic) UILabel               *       payPrice;
@property (strong, nonatomic) UIButton              *       cancelPayBtn;
@property (strong, nonatomic) UIButton              *       goodsCarBtn;    //  购物车按钮
@property (strong, nonatomic) UIButton              *       searchBtn;      //  搜索按钮
@property (strong, nonatomic) UILabel               *       carNumLab;      //  显示购物车数量
@end
