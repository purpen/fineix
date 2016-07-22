//
//  AddCategoryView.h
//  Fiu
//
//  Created by FLYang on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface AddCategoryView : UIView

@pro_strong UIViewController    *   vc;
@pro_strong UIButton            *   addCategory;
@pro_strong NSString            *   categoryId;

- (void)getChooseFScene:(NSString *)title;

@end
