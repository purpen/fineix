//
//  THNSceneInfoTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "HomeSceneListRow.h"
#import "TTTAttributedLabel.h"

@interface THNSceneInfoTableViewCell : UITableViewCell <
    TTTAttributedLabelDelegate
>

@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *graybackView;
@property (nonatomic, strong) TTTAttributedLabel *content;
@property (nonatomic, strong) UIButton *moreIcon;
@property (nonatomic, assign) CGFloat cellHigh;
@property (nonatomic, assign) CGFloat defaultCellHigh;

- (void)thn_setSceneContentData:(HomeSceneListRow *)contentModel;

@end
