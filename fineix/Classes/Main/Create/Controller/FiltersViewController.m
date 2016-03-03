//
//  FiltersViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
}

- (void)setNavViewUI {
    [self addNavViewTitle:@"工具"];
    [self addBackButton];
    [self addNextButton];
    
//    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
}

- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, (SCREEN_WIDTH - 60), (SCREEN_HEIGHT - 100))];
        
    }
    return _filtersImageView;
}

@end
