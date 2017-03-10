//
//  THNDomainEditViewController.h
//  Fiu
//
//  Created by FLYang on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"
#import "THNDomainManageInfoData.h"

typedef NS_ENUM(NSInteger , DomainSetInfoType) {
    DomainSetInfoTypeTitle = 1,
    DomainSetInfoTypeSubTitle,
    DomainSetInfoTypeCategory,
    DomainSetInfoTypeTags,
    DomainSetInfoTypeAddress,
    DomainSetInfoTypePhoneNum,
    DomainSetInfoTypeOpenTime,
    DomainSetInfoTypeDes,
};

@interface THNDomainEditViewController : THNViewController <
    THNNavigationBarItemsDelegate,
    UITextFieldDelegate,
    UITextViewDelegate
>

/**
 地盘数据
 */
@property (nonatomic, strong) THNDomainManageInfoData *infoData;

/**
 控制器类型
 */
@property (nonatomic, assign) NSInteger setInfoType;

/**
 编辑标题信息等
 */
@property (nonatomic, strong) UITextField *editInputBox;

/**
 填写简介
 */
@property (nonatomic, strong) UITextView *writeBox;
@property (nonatomic, strong) UILabel *textCountLabel;

/**
 地盘分类
 */
@property (nonatomic, strong) FBRequest *categoryRequest;
@property (nonatomic, strong) NSMutableArray *titleMarr;
@property (nonatomic, strong) NSMutableArray *idMarr;

/**
 当前所选地盘的分类按钮
 */
@property (nonatomic, strong) UIButton *nowCategoryBtn;

/**
 提示文字信息
 */
@property (nonatomic, strong) UILabel *hintLabel;

@end
