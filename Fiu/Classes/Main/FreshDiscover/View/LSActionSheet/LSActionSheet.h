//
//  LSActionSheet.h
//  LSActionSheet
//
//  Created by 刘松 on 16/11/17.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import <UIKit/UIKit.h>


//按钮顺序index依次从上往下
typedef  void(^LSActionSheetBlock)(int index);


//按钮显示顺序 title 其他按钮 销毁按钮 取消按钮
@interface LSActionSheet : UIView

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *destructiveTitle;
@property(nonatomic,strong) NSArray *otherTitles;


@property (nonatomic,copy) LSActionSheetBlock  block;

+(void)showWithTitle:(NSString*)title  destructiveTitle:(NSString*)destructiveTitle  otherTitles:(NSArray*)otherTitles block:(LSActionSheetBlock)block;

-(void)showTwo;
-(void)zhangHuSheetShow;

@end
