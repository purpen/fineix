//
//  PictureToolViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PictureToolViewController.h"
#import "ReleaseViewController.h"
#import "ClipImageViewController.h"

@interface PictureToolViewController () {
    ClipImageViewController *_clipImageVC;
}

@end

@implementation PictureToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    _clipImageVC = [[ClipImageViewController alloc] init];
    _clipImageVC.actionId = self.actionId;
    _clipImageVC.activeTitle = self.activeTitle;
    [self addChildViewController:_clipImageVC];
}


@end
