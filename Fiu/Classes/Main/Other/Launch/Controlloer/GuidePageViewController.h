//
//  GuidePageViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Fiu.h"

@interface GuidePageViewController : UIViewController

-(instancetype)initWithPicArr:(NSArray*)picArr andRootVC:(UIViewController*)controller;

@pro_strong AVPlayer    *   player;

@end
