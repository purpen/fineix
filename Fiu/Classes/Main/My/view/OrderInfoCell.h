//
//  OrderInfoCell.h
//  Fiu
//
//  Created by THN-Dong on 16/4/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *transactionStatus;//交易状态
@property (weak, nonatomic) IBOutlet UILabel *theFreightLabel;//运费
@property (weak, nonatomic) IBOutlet UILabel *theTotalPriceLabel;//总价
@property (weak, nonatomic) IBOutlet UILabel *theNumberLabel;//商品数量
@property (weak, nonatomic) IBOutlet UIButton *cancelTheOrderBtn;//取消订单按钮
@property (weak, nonatomic) IBOutlet UIButton *multiFunctionBtn;//多功能按钮
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;//商品颜色
@property (weak, nonatomic) IBOutlet UILabel *theNumLabelTwo;//商品展示上的商品数量
@property (weak, nonatomic) IBOutlet UILabel *theUnitPriceLabel;//商品单价


+(instancetype)getOrderInfoCell;
+(NSString*)getIdentifer;

@end
