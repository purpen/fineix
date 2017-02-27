//
//  FBEditCarItemTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "CarGoodsModelItem.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface FBEditCarItemTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton        *   chooseBtn;      //  选择按钮
@property (nonatomic, strong) UIImageView     *   goodsImg;       //  商品图片
@property (nonatomic, strong) UILabel         *   goodsColor;     //  商品颜色
@property (nonatomic, strong) UILabel         *   goodsNum;       //  商品数量
@property (nonatomic, strong) UIButton        *   addNumBtn;      //  增加数量
@property (nonatomic, strong) UIButton        *   subNumBtn;      //  减少数量
@property (nonatomic, strong) UILabel         *   numLab;         //  显示数量
@property (nonatomic, assign) NSInteger           nowNum;
@property (nonatomic, assign) NSInteger           stockNum;
@property (nonatomic, assign) NSInteger           newNum;

- (void)setEditCarItemData:(CarGoodsModelItem *)model withStock:(NSInteger)stock;

@end
