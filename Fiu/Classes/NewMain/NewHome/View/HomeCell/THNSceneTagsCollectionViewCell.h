//
//  THNSceneTagsCollectionViewCell.h
//  Fiu
//
//  Created by FLYang on 16/8/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNSceneTagsCollectionViewCell : UICollectionViewCell

@pro_strong UILabel *sceneTag;

- (void)thn_setSceneTagsData:(NSString *)tagText;

@end
