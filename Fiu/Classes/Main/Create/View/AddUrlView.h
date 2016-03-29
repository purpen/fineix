//
//  AddUrlView.h
//  fineix
//
//  Created by FLYang on 16/3/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol WebBtnSelectedDelegate <NSObject>

- (void)webBtnSelectedSearchGoods:(NSInteger)index;

@end

@interface AddUrlView : UIView

@pro_strong NSMutableArray      *   webTitle;       //  购物网站的标题
@pro_strong UIView              *   webBtnView;     //  购物网站的按钮

@pro_weak   id <WebBtnSelectedDelegate> delegate;

@end
