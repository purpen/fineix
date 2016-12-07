//
//  THNLogisticTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2016/12/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNLogisticTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *stationLab;
@property (nonatomic, strong) UILabel *lineBall;

- (void)thn_setLogisticData:(NSDictionary *)dict index:(NSInteger)index;

@end
