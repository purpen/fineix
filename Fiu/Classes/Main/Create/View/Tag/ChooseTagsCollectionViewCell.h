//
//  ChooseTagsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "UIImage+Helper.h"

@interface ChooseTagsCollectionViewCell : UICollectionViewCell

@pro_strong UIButton            *   tagBtn;     //  标签
@pro_assign BOOL                    isSelected;

- (void)updateCellState:(BOOL)select;

@end
