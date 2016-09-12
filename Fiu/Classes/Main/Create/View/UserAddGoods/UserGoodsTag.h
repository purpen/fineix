//
//  UserGoodsTag.h
//  Fiu
//
//  Created by FLYang on 16/5/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@class UserGoodsTag;

@protocol FBUserGoodsTagDelegaet <NSObject>
@optional
- (void)delegateThisTagBtn:(UserGoodsTag *)tag;

@end

@interface UserGoodsTag : UIButton

@pro_weak id <FBUserGoodsTagDelegaet> delegate;
@pro_assign NSInteger       index;
@pro_strong UIButton    *   bgBtn;
@pro_strong UIButton    *   dele;
@pro_strong UILabel     *   title;
@pro_strong UILabel     *   price;
@pro_assign BOOL            isMove;
@pro_strong NSString    *   goodsId;
@pro_strong UIView      *   posPoint;
@pro_assign BOOL            isFlip;

- (void)userTag_SetGoodsInfo:(NSString *)text;

- (void)thn_setSceneImageUserGoodsTagLoc:(NSInteger)loc;

@end
