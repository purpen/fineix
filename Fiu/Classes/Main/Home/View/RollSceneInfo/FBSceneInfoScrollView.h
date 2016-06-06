//
//  FBSceneInfoScrollView.h
//  Fiu
//
//  Created by FLYang on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBSceneInfoScrollView : UIView <UIScrollViewDelegate>

@pro_strong UIImage                 *   backgroundImage;
@pro_strong UIImage                 *   blurredBackgroundImage;
@pro_assign CGFloat                     viewDistanceFromBottom;
@pro_strong UIView                  *   foregroundView;
@pro_strong_readonly UIScrollView   *   foregroundScrollView;

- (id)initWithFrame:(CGRect)frame BackgroundImage:(UIImage *)backgroundImage blurredImage:(UIImage *)blurredImage viewDistanceFromBottom:(CGFloat)viewDistanceFromBottom foregroundView:(UIView *)foregroundView;

- (void)scrollVerticallyToOffset:(CGFloat)offsetY;

@end
