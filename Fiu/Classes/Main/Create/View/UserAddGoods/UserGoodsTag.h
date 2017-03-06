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

@property (nonatomic, weak) id <FBUserGoodsTagDelegaet> delegate;
@property (nonatomic, assign) NSInteger       index;
@property (nonatomic, strong) UIButton    *   bgBtn;
@property (nonatomic, strong) UIButton    *   dele;
@property (nonatomic, strong) UILabel     *   title;
@property (nonatomic, strong) UILabel     *   price;
@property (nonatomic, assign) BOOL            isMove;
@property (nonatomic, strong) NSString    *   goodsId;
@property (nonatomic, strong) UIView      *   posPoint;
@property (nonatomic, assign) BOOL            isFlip;

- (void)userTag_SetGoodsInfo:(NSString *)text;

- (void)thn_setSceneImageUserGoodsTagLoc:(NSInteger)loc;

@end
