//
//  THNAddGoodsBtn.h
//  Fiu
//
//  Created by FLYang on 16/8/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNAddGoodsBtn : UIButton

@pro_strong UIButton *icon;
@pro_strong UILabel *add;
@pro_strong UILabel *name;

/**
 *  type
 *  1:品牌 ／ 2:商品
 */
- (void)setAddGoodsOrBrandInfo:(NSInteger)type withText:(NSString *)text;

@end
