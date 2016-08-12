//
//  PictureToolViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PictureToolViewController.h"
#import "CreateViewController.h"
#import "CropImageViewController.h"
#import "FiltersViewController.h"
#import "ReleaseViewController.h"

@interface PictureToolViewController () {
    CreateViewController *_createVC;
}

@end

@implementation PictureToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    _createVC = [[CreateViewController alloc] init];
    _createVC.fSceneId = self.fSceneId;
    _createVC.fSceneTitle = self.fSceneTitle;
    [self addChildViewController:_createVC];
}


@end
