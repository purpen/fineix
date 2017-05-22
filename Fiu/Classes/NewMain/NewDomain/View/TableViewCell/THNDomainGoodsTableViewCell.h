//
//  THNDomainGoodsTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/5/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsRow.h"
#import "THNMacro.h"

@interface THNDomainGoodsTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImg;       //  商品图片
@property (nonatomic, strong) UILabel *titleLabel;         //  商品标题
@property (nonatomic, strong) UILabel *priceLabel;         //  价格
@property (nonatomic, strong) UILabel *commissionLabel;    //  佣金
@property (nonatomic, strong) UIButton *chooseBtn;         //  添加按钮
@property (nonatomic, strong) UIButton *linkBtn;           //  链接按钮
@property (nonatomic, strong) FBRequest *addGoodsRequest;
@property (nonatomic, strong) FBRequest *shareRequest;

/**
 绑定商品数据

 @param model 商品model
 @param hidden 是否显示“添加商品”按钮
 @param dominId 地盘id
 */
- (void)thn_setGoodsItemData:(GoodsRow *)model chooseHidden:(BOOL)hidden domainId:(NSString *)dominId;
    
@end
