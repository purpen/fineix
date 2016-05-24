//
//  MapLocatinViewController.m
//  BaDuMapTest1
//
//  Created by THN-Dong on 16/3/14.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FBMapLocatinViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface FBMapLocatinViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    float _latitude;
    float _longitude;
}
@end

@implementation FBMapLocatinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mapView];
    [self startFixedPosition];
    
}

-(void)mapView{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.view = _mapView;
}

-(void)startFixedPosition{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

#pragma mark -BMKLocationServiceDelegate
-(void)willStartLocatingUser{
    NSLog(@"开始定位");
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败%@",error);
    
}


//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //定义大头针标注
    
    //设置标注的位置坐标
    
    NSLog(@"纬度%f,经度%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;
    // 添加一个PointAnnotation
    [self addPointAnnotation:_latitude andLongitude:_longitude];
}

// 添加一个PointAnnotation
-(void)addPointAnnotation:(float)latitude andLongitude:(float)longitude{
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    annotation.coordinate = coor;
    
    
    [_mapView addAnnotation:annotation];
    [self stopFixedPosition];
    
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
    newAnnotationView.calloutOffset = CGPointMake(9, -5);
}

-(void)setpopView:(UIView*)popView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 154, 45)];
    view.backgroundColor = [UIColor clearColor];
    [self setViewView:view];
    [popView addSubview:view];
}

-(void)setViewView:(UIView*)view{
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:view.frame];
    imgV.image = [UIImage imageNamed:@"Group"];
    [view addSubview:imgV];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    image.image = [UIImage imageNamed:@"Search2"];
    [imgV addSubview:image];
    
    [self setLabel:CGRectMake(50, 6, 100, 10) andText:@"星巴克" andFont:13 andView:imgV andtextColor:[UIColor blackColor]];
    [self setLabel:CGRectMake(50, 22, 100, 10) andText:@"朝阳区，北京" andFont:10 andView:imgV andtextColor:[UIColor grayColor]];
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
    NSLog(@"aaa");
}

-(UIView*)creatPaopaoView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 154, 45)];
    view.backgroundColor = [UIColor redColor];
    return view;

}



-(void)stopFixedPosition{
    [_locService stopUserLocationService];
}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; //
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
