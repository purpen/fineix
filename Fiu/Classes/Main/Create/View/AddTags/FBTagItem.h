//
//  FBTagItem.h
//  Fiu
//
//  Created by FLYang on 16/7/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBTagView.h"

@interface FBTagItem : UIView

@property(nonatomic, strong) FBTagLabel *label;
@property(nonatomic, assign) FBTagStyle style;
@property(nonatomic) UIEdgeInsets padding;
@property(nonatomic, assign) id<FBTagViewDelegate> tagviewDelegate;
@property(nonatomic, copy) NSString *text;

@end

@interface FBTagLabel : UITextField<UITextFieldDelegate>

@property(nonatomic, assign) FBTagStyle style;
@property(nonatomic) UIEdgeInsets padding;
@property(nonatomic, assign) id<FBTagViewDelegate> tagviewDelegate;
- (void)deleteMe:(id)sender;

@end

@interface FBTabView : UIView

@end
