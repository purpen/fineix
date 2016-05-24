//
//  FBSearchView.h
//  fineix
//
//  Created by FLYang on 16/3/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol FBSearchDelegate <NSObject>

- (void)beginSearch:(NSString *)searchKeyword;
@optional
- (void)cancelSearch;

@end

@interface FBSearchView : UIView <UITextFieldDelegate>

@pro_strong UIView              *   bgView;              //  背景
@pro_strong UIImageView         *   searchIcon;          //  搜索图标
@pro_strong UITextField         *   searchInputBox;      //  搜索输入框
@pro_strong UILabel             *   line;                //  视图分割线
@pro_strong UIButton            *   cancelBtn;           //  取消按钮

@pro_weak id <FBSearchDelegate> delegate;

@end
