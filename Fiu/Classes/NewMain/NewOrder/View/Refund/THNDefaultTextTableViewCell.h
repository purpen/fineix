//
//  THNDefaultTextTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/11/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNDefaultTextTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *explain;
@property (nonatomic, strong) UILabel *dataLab;

- (void)thn_setExplainText:(NSInteger)index data:(NSString *)data;

@end
