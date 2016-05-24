//
//  UserGoodsTag.h
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol FBUserGoodsTagDelegaet <NSObject>
@optional
- (void)delegateThisTagBtn:(NSInteger)index;

@end

@interface UserGoodsTag : UIButton

@pro_weak id <FBUserGoodsTagDelegaet> delegate;
@pro_assign NSInteger       index;
@pro_strong UIButton    *   dele;
@pro_strong UILabel     *   title;
@pro_strong UILabel     *   price;
@pro_assign BOOL            isMove;

@end
