//
//  THNHotActionCollectionReusableView.h
//  Fiu
//
//  Created by FLYang on 16/8/30.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"
#import "THNMallSubjectModelRow.h"

@interface THNHotActionCollectionReusableView : UICollectionReusableView

@pro_strong UINavigationController *nav;
@pro_strong UIImageView *bannerImage;
@pro_strong UILabel *title;
@pro_strong UILabel *suTitle;
@pro_strong UIButton *bannerBot;
@pro_strong UILabel *botLine;
@pro_strong UIView *bannerBg;
@pro_strong UIImageView *typeImage;

- (void)thn_setSubjectModel:(THNMallSubjectModelRow *)model;

@end
