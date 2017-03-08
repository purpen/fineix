//
//  FBPopupView.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"
#import "HomeSceneListRow.h"

@interface FBPopupView : UIView

@property (nonatomic, strong) UIViewController    *vc;
@property (nonatomic, strong) NSString            *sceneId;

- (void)showPopupViewOnWindowStyleOne:(NSString *)text;

- (void)showPopupViewOnWindowStyleTwo:(NSString *)text withAddJifen:(NSInteger)num;

@end
