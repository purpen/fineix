//
//  THNLightspotTableViewCell.h
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNLightspotTableViewCell : UITableViewCell

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *textMarr;
@property (nonatomic, strong) NSMutableArray *imageMarr;
@property (nonatomic, strong) NSMutableArray *imageIndexMarr;
@property (nonatomic, assign) CGFloat viewHeiight;

- (void)thn_setBrightSpotData:(NSArray *)model;

@end
