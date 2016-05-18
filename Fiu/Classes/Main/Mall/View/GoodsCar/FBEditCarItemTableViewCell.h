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

@pro_strong UIButton        *   chooseBtn;      //  选择按钮
@pro_strong UIImageView     *   goodsImg;       //  商品图片
@pro_strong UILabel         *   goodsColor;     //  商品颜色
@pro_strong UILabel         *   goodsNum;       //  商品数量
@pro_strong UIButton        *   addNumBtn;      //  增加数量
@pro_strong UIButton        *   subNumBtn;      //  减少数量
@pro_strong UILabel         *   numLab;         //  显示数量
@pro_assign NSInteger           nowNum;
@pro_assign NSInteger           stockNum;
@pro_assign NSInteger           newNum;

- (void)setEditCarItemData:(CarGoodsModelItem *)model withStock:(NSInteger)stock;

@end
