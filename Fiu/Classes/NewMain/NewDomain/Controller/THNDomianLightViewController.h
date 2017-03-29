//
//  THNDomianLightViewController.h
//  Fiu
//
//  Created by FLYang on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNDomianLightViewController : THNViewController <
    THNNavigationBarItemsDelegate
>

@property (nonatomic, strong) UITextView *contentInputBox;
@property (nonatomic, strong) NSMutableArray *textMarr;
@property (nonatomic, strong) NSMutableArray *imageMarr;

/**
 记录改变字体的样式
 */
@property (nonatomic, strong) NSMutableAttributedString *contentAttributed;

/**
 图片插入的位置
 */
@property (nonatomic, strong) NSMutableArray *imageLocationMarr;

- (void)thn_setBrightSpotData:(NSArray *)model;

@end
