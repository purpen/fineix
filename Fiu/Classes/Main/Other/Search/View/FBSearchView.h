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

@optional
- (void)beginSearch:(NSString *)searchKeyword;
- (void)cancelSearch;
- (void)clearSearchKeyword;

@end

@interface FBSearchView : UIView <UITextFieldDelegate>

@property (nonatomic, strong) UIView              *   bgView;              //  背景
@property (nonatomic, strong) UIImageView         *   searchIcon;          //  搜索图标
@property (nonatomic, strong) UITextField         *   searchInputBox;      //  搜索输入框
@property (nonatomic, strong) UIButton            *   cancelBtn;           //  取消按钮

@property (nonatomic, weak) id <FBSearchDelegate> delegate;

@end
