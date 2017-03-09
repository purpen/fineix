//
//  THNInfoTitleTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/3/9.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNInfoTitleTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIImageView *infoImageView;

- (void)thn_setInfoTitleLeftText:(NSString *)leftText andRightText:(NSString *)rightText;

- (void)thn_showImage:(NSString *)imageUrl;

- (void)thn_hiddenNextIcon:(BOOL)hidden;

- (void)thn_showLeftButton;

@end
