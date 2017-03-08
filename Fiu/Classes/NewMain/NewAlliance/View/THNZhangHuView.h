//
//  THNZhangHuView.h
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    //以下是枚举成员
    none = 0,
    zhiFuBao,
    YingHangKa
}ZhangHu;//枚举名称

@interface THNZhangHuView : UIView

/**  */
@property (nonatomic, assign) ZhangHu zhangHu;
/**  */
@property (nonatomic, strong) UINavigationController *nav;

@end
