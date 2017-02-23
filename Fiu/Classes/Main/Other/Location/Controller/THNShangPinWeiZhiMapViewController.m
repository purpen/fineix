//
//  THNShangPinWeiZhiMapViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/2/23.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNShangPinWeiZhiMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "DominInfoData.h"
#import "UIImageView+WebCache.h"
#import "LSActionSheet.h"
#import<MapKit/MapKit.h>

@interface THNShangPinWeiZhiMapViewController () <THNNavigationBarItemsDelegate, BMKMapViewDelegate, BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
}
@end

@implementation THNShangPinWeiZhiMapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self thn_setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    self.delegate = self;
    self.navViewTitle.hidden = NO;
    self.navViewTitle.text = @"位置";
    [self thn_addBarItemLeftBarButton:@"" image:@"icon_back_white"];
}

-(void)thn_leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //定义大头针标注
    
    //设置标注的位置坐标
    
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;
    [_locService stopUserLocationService];
}

-(void)setModel:(DominInfoData *)model{
    _model = model;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    [self addPointAnnotation:[model.location.coordinates[1] floatValue] andLongitude:[model.location.coordinates[0] floatValue]];
}

// 添加一个PointAnnotation
-(void)addPointAnnotation:(float)latitude andLongitude:(float)longitude{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    [_mapView addAnnotation:annotation];
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        [newAnnotationView setSelected:YES animated:YES];
        [self setPaopaoview:newAnnotationView];
        return newAnnotationView;
    }
    return nil;
}


-(void)setPaopaoview:(BMKPinAnnotationView*)newAnnotationView{
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 154, 45)];
    popView.backgroundColor = [UIColor clearColor];
    [self setpopView:popView];
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.backgroundColor = [UIColor clearColor];
    pView.frame = popView.frame;
    newAnnotationView.paopaoView = nil;
    newAnnotationView.paopaoView = pView;
    newAnnotationView.calloutOffset = CGPointMake(-48, -5);
}

-(void)setpopView:(UIView*)popView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 47)];
    view.backgroundColor = [UIColor clearColor];
    [self setViewView:view];
    [popView addSubview:view];
}

-(void)setViewView:(UIView*)view{
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:view.frame];
    imgV.image = [UIImage imageNamed:@"Group"];
    [view addSubview:imgV];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [image sd_setImageWithURL:[NSURL URLWithString:self.model.avatarUrl]];
    [imgV addSubview:image];
    UIImageView *imgVV = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width-5 - 65, 5, 65, 30)];
    imgVV.image = [UIImage imageNamed:@"daoHangBtn"];
    [view addSubview:imgVV];
    
    [self setLabel:CGRectMake(50, 6, 100, 10) andText:self.model.title andFont:13 andView:imgV andtextColor:[UIColor blackColor]];
    [self setLabel:CGRectMake(50, 22, 100, 10) andText:[NSString stringWithFormat:@"%@%@",self.model.city,self.model.address] andFont:10 andView:imgV andtextColor:[UIColor grayColor]];
}

-(void)setLabel:(CGRect)frame andText:(NSString*)title andFont:(int)font andView:(UIView *)view andtextColor:(UIColor*)color{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:frame];
    titlelabel.text = title;
    titlelabel.font = [UIFont systemFontOfSize:font];
    titlelabel.textColor = color;
    [view addSubview:titlelabel];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[self singleRecognizer]];
}

-(UITapGestureRecognizer*)singleRecognizer{
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.numberOfTouchesRequired = 1;
    return singleRecognizer;
}

-(void)handleSingleTapFrom{
    [LSActionSheet showWithTitle:nil destructiveTitle:@"苹果地图" otherTitles:@[@"google地图",@"百度地图"] block:^(int index) {
        switch (index) {
            case 0:
            {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemapsurl://"]]) {
                    NSString *stringURL = [NSString stringWithFormat:@"comgooglemapsurl://map/direction?origin=%f,%f&destination=%f,%f&mode=driving",_latitude, _longitude,
                                           
                                           [self.model.location.coordinates[1] floatValue], [self.model.location.coordinates[0] floatValue]];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
                }
            }
                
                break;
            case 1:
            {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
                    NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%f,%f&destination=%f,%f&mode=driving",_latitude, _longitude,
                                           
                                           [self.model.location.coordinates[1] floatValue], [self.model.location.coordinates[0] floatValue]];
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringURL]];
                }
            }
                break;
            case 2:
            {
                CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake([self.model.location.coordinates[1] floatValue], [self.model.location.coordinates[0] floatValue]);
                
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
                
                toLocation.name = [NSString stringWithFormat:@"到 %@", self.model.title];
                
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                 
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }
                break;
                
            default:
                break;
        }
    }];
}

@end
