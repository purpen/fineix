//
//  THNTFView.h
//  Fiu
//
//  Created by THN-Dong on 16/8/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THNTFView : UIView
/**
 *  输入回调
 */
@property (nonatomic, copy) void(^passwordBlock)(NSString *password);
/**
 *  用于存放所有的子输入框
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  密码框个数
 */
@property (nonatomic, assign) NSUInteger elementCount;
/**
 *  密码框颜色
 */
@property (nonatomic, strong) UIColor *elementColor;
/**
 *  密码框间距
 */
@property (nonatomic, assign) NSUInteger elementMargin;
/**
 *  父输入框
 */
@property(nonatomic, weak) UITextField *textField;
/**
 *  清除所有输入文字
 */
//- (void)clearText;
/**
 *  设置键盘输入是否明文可见
 */
-(void)setNoSecure;
@end
