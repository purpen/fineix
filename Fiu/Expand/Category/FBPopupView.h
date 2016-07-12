//
//  FBPopupView.h
//  Fiu
//
//  Created by FLYang on 16/7/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fiu.h"

@interface FBPopupView : UIView

@pro_strong UIViewController    *   vc;

- (void)showPopupViewOnWindowStyleOne:(NSString *)text withSceneData:(NSDictionary *)data;

- (void)showPopupViewOnWindowStyleTwo:(NSString *)text;

@end
