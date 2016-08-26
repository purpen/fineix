//
//  THNHotUserCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <pop/POP.h>
#import "THNMacro.h"
#import "HotUserListUser.h"

@interface THNHotUserCollectionViewCell : UICollectionViewCell

@pro_strong UIButton *close;
@pro_strong UIImageView *header;
@pro_strong UILabel *name;
@pro_strong UILabel *info;
@pro_strong UIButton *follow;

- (void)setHotUserListData:(HotUserListUser *)model;

@end
