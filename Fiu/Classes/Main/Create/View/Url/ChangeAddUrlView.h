//
//  ChangeAddUrlView.h
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface ChangeAddUrlView : UIView

@pro_strong UIView          *   bgView;
@pro_strong UILabel         *   title;          //  标题
@pro_strong UIButton        *   cancel;         //  取消
@pro_strong UIButton        *   sure;           //  确定
@pro_strong UIButton        *   url;            //  修改链接
@pro_strong UIButton        *   dele;           //  删除
@pro_strong UIImageView     *   goodsImg;       //  商品图片
@pro_strong UITextField     *   goodsTitle;     //  商品标题
@pro_strong UITextField     *   goodsPrice;     //  商品价格

@end
