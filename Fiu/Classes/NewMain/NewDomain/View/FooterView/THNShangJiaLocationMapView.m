//
//  THNShangJiaLocationMapView.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/21.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNShangJiaLocationMapView.h"
#import "Masonry.h"
#import "THNShangPinWeiZhiMapViewController.h"

@interface THNShangJiaLocationMapView ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

/**  */
@property (nonatomic, strong) UIButton *tapBtn;

@end

@implementation THNShangJiaLocationMapView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.zoomLevel = 15;
        self.tapBtn = [[UIButton alloc] init];
        [self addSubview:self.tapBtn];
        [self.tapBtn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        [_tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(self).mas_offset(0);
        }];
    }
    return self;
}

-(void)tapClick{
    THNShangPinWeiZhiMapViewController *vc = [[THNShangPinWeiZhiMapViewController alloc] init];
    vc.model = self.model;
    [self.nav pushViewController:vc animated:YES];
}

-(void)setPoint{
    [self addPointAnnotation:self.latitude andLongitude:self.longitude];
    self.centerCoordinate = CLLocationCoordinate2DMake((double)self.latitude, (double)self.longitude);
}

// 添加一个PointAnnotation
-(void)addPointAnnotation:(float)latitude andLongitude:(float)longitude{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    
    
    [self addAnnotation:annotation];
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        [newAnnotationView setSelected:YES animated:YES];
        newAnnotationView.image = [UIImage imageNamed:@"icon_map_dark"];
        return newAnnotationView;
    }
    return nil;
}

@end
