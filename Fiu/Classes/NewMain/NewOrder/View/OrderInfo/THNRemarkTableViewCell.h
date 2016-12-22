//
//  THNRemarkTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/12/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "OrderInfoModel.h"

@interface THNRemarkTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *remarkLab;   //  备注
@property (nonatomic, strong) UILabel *content;     //  备注内容

- (void)thn_setRemarkContentData:(OrderInfoModel *)model;

- (CGFloat)thn_getRemarkContentHeight:(NSString *)content;

@end
