//
//  FBSearchView.h
//  fineix
//
//  Created by FLYang on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fineix.h"

@protocol FBSearchDelegate <NSObject>

- (void)beginSearch:(NSString *)searchKeyword;

@end

@interface FBSearchView : UIView <UITextFieldDelegate>

@pro_strong UIImageView         *   searchIcon;          //  搜索图标
@pro_strong UITextField         *   searchInputBox;      //  搜索输入框
@pro_strong UILabel             *   line;                //  视图分割线

@pro_weak id <FBSearchDelegate> delegate;

@end
