//
//  THNEditLightViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/22.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"
#import "THNAccessoryView.h"

@interface THNEditLightViewController : THNViewController <
    UITextViewDelegate,
    THNAccessoryViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

@property (nonatomic, strong) THNDomainManageInfoData *infoData;

@property (nonatomic, strong) FBRequest *uploadRequest;
@property (nonatomic, strong) FBRequest *saveRequest;

/**
 键盘工具栏
 */
@property (nonatomic, strong) THNAccessoryView *accessoryView;

/**
 正文内容输入框
 */
@property (nonatomic, strong) UITextView *contentInputBox;
@property (nonatomic, strong) UILabel *contentPlaceholder;

/**
 记录改变字体的样式
 */
@property (nonatomic, strong) NSMutableAttributedString *contentAttributed;

/**
 发布按钮
 */
@property (nonatomic, strong) UIButton *doneButton;

/**
 设置默认亮点内容
 */
- (void)thn_setBrightSpotData:(NSArray *)model;
@property (nonatomic, strong) NSMutableArray *textMarr;
@property (nonatomic, strong) NSMutableArray *imageMarr;
@property (nonatomic, strong) NSMutableArray *imageIndexMarr;

@end
