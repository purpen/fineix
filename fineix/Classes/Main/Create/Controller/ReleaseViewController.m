//
//  ReleaseViewController.m
//  fineix
//
//  Created by FLYang on 16/3/2.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ReleaseViewController.h"

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavViewUI];
    
    CLGeocoder * img = [[CLGeocoder alloc] init];
    CLLocation * location = [[CLLocation alloc] initWithLatitude:39.982975 longitude:116.4924166666667];
    
    [img reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {

            /** CLPlacemark         地标
             *  location            位置对象
             *  addressDictionary   地址字典
             *  name                地址详情
             *  locality            城市
             */
            
            CLPlacemark * pl = [placemarks firstObject];
            NSLog(@"＝＝＝＝%@ %@",pl.locality, pl.name);
            
        } else {
            NSLog(@"获取地理位置出错");
        }
        
    }];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"创建场景"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
    [self addDoneButton];
    [self addLine];
}


@end
