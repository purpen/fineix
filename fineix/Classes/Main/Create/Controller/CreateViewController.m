//
//  CreateViewController.m
//  fineix
//
//  Created by FLYang on 16/2/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CreateViewController.h"
#import "FBFootView.h"

@interface CreateViewController () <FBFootViewDelegate>

@pro_strong FBFootView      *   footView;

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCancelBtn];
    
    [self addPhotoAlbumBtn];
    
    [self addNextBtn];
    
    [self setCreateControllerUI];
}

- (void)setCreateControllerUI {
    [self.view addSubview:self.footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 55));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.centerX.equalTo(self.view);
    }];
}

- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:@"相册", @"照片", nil];
        
        _footView = [[FBFootView alloc] init];
        _footView.titleArr = arr;
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
        
    }
    return _footView;
}

- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    NSLog(@"点击了第 %zi 个按钮", index);
}

@end
