//
//  THNWriteLightViewController.m
//  Fiu
//
//  Created by FLYang on 2017/3/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNWriteLightViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface THNWriteLightViewController ()

@end

@implementation THNWriteLightViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;
}

- (void)thn_setBrightSpotData:(NSArray *)model {
    NSMutableArray *totalTextMarr = [NSMutableArray array];
    
    for (NSString *str in model) {
        //  文字内容
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
            [totalTextMarr addObject:textStr];
        }
        
        //  图片内容
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
            [totalTextMarr addObject:imageStr];
        }
    }
    
    NSString *totalText = [totalTextMarr componentsJoinedByString:@""];
    
    if (self.imageMarr.count > 0) {
        for (NSString *imageUrl in self.imageMarr) {
            NSInteger imageLocation = [totalText rangeOfString:imageUrl].location;
            [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", imageLocation]];
            totalText = [totalText stringByReplacingOccurrencesOfString:imageUrl withString:@""];
        }
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = @"亮点";
}

@end
