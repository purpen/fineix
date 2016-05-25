//
//  ShareSearchTextTableViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "ShareInfoRow.h"

@interface ShareSearchTextTableViewCell : UITableViewCell

@pro_strong UILabel     *   title;
@pro_strong UILabel     *   des;

- (void)setShareTextData:(ShareInfoRow *)model;

@end
