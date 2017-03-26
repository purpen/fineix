//
//  THNAccessoryView.h
//  Fiu
//
//  Created by FLYang on 2017/3/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@protocol THNAccessoryViewDelegate <NSObject>

@optional
- (void)thn_writeInputBoxResignFirstResponder;
- (void)thn_writeInputBoxInsertImage;

@end


@interface THNAccessoryView : UIView

@property (nonatomic, weak) id <THNAccessoryViewDelegate> delegate;

/**
 插入图片
 */
@property (nonatomic, strong) UIButton *insertImage;

/**
 关闭键盘
 */
@property (nonatomic, strong) UIButton *closeKeybord;

/**
 正在上传
 */
@property (nonatomic, strong) UILabel *uploadState;

/**
 加载等待
 */
@property (nonatomic, strong) UIActivityIndicatorView *uploadActivity;

/**
 正在上传提示

 @param hidden 是否显示
 */
- (void)thn_hiddenUploadImage:(BOOL)hidden;

@end
