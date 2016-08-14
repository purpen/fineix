//
//  FBKeyboradToolbar.h
//  Fiu
//
//  Created by FLYang on 16/8/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol FBKeyboradToolbarDelegate <NSObject>

@optional
- (void)thn_keyboardLeftBarItemAction;
- (void)thn_keyboardRightBarItemAction:(NSString *)text;

@end

@interface FBKeyboradToolbar : UIToolbar

@pro_strong UIButton *leftBarItem;
@pro_strong UIButton *rightBarItem;
@pro_weak id <FBKeyboradToolbarDelegate> thn_delegate;

- (void)thn_setRightBarItemContent:(NSString *)content;

@end
