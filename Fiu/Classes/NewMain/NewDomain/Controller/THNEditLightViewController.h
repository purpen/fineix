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
    THNNavigationBarItemsDelegate,
    UITextViewDelegate,
    THNAccessoryViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate
>

@property (nonatomic, strong) THNDomainManageInfoData *infoData;

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
 保存插入图片的数组
 */
@property (nonatomic, strong) NSMutableArray *imageAttachmentMarr;

/**
 记录改变字体的样式
 */
@property (nonatomic, strong) NSMutableAttributedString *contentAttributed;

@end
