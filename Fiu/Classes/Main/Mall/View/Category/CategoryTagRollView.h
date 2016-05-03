//
//  CategoryTagRollView.h
//  Fiu
//
//  Created by FLYang on 16/4/28.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@protocol CategotyTagBtnSelectedDelegate <NSObject>

- (void)tagBtnSelected:(NSInteger)index;

@end


@interface CategoryTagRollView : UIView

@pro_strong UIScrollView                        *   tagRollView;   //  应用的场景
@pro_strong UIButton                            *   selectedBtn;
@pro_weak id <CategotyTagBtnSelectedDelegate>       delegate;

- (void)setTagRollMarr:(NSArray *)title;

@end
