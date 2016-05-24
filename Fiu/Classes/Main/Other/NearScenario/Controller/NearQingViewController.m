//
//  NearQingViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "NearQingViewController.h"
#import "SceneInfoData.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NearQingViewController ()<BMKMapViewDelegate>
{
    float _latitude;
    float _longitude;
    int _n;
}
@property(nonatomic,strong) BMKMapView *mapView;
@pro_strong NSMutableArray      *   idMarr;         //  附近情景的ID
@pro_strong NSMutableArray      *   titleMarr;      //  标题
@pro_strong NSMutableArray      *   addressMarr;    //  地址
@pro_strong NSMutableArray      *   locationMarr;   //  位置
@pro_strong NSMutableArray      *   coverUrlMary;   //  图片

@end

@implementation NearQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _longitude = [self.baseInfo.location.coordinates[0] floatValue];
    _latitude = [self.baseInfo.location.coordinates[1] floatValue];
    [self requestDataForOderList];
    // Do any additional setup after loading the view from its nib.
    self.navViewTitle.text = self.baseInfo.address;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)requestDataForOderList
{
    [self.idMarr removeAllObjects];
    [self.titleMarr removeAllObjects];
    [self.addressMarr removeAllObjects];
    [self.locationMarr removeAllObjects];
    [self.coverUrlMary removeAllObjects];
    
    [self requestDataForOderListOperation];
    [self.view addSubview:self.mapView];
}

- (void)requestDataForOderListOperation
{
    [SVProgressHUD show];
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_sight/" requestDictionary:@{
                                                                                       @"page":@1,
                                                                                       @"size":@10,
                                                                                       @"dis":@5000,
                                                                                       @"lng":self.baseInfo.location.coordinates[0],
                                                                                       @"lat":self.baseInfo.location.coordinates[1]
                                                                                       } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"附近的场景   %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = dataDict[@"rows"];
        for (NSDictionary *rowsDict in rowsAry) {
            [_idMarr addObject:rowsDict[@"_id"]];
            [_titleMarr addObject:rowsDict[@"title"]];
            [_coverUrlMary addObject:rowsDict[@"cover_url"]];
            [_addressMarr addObject:rowsDict[@"address"]];
            [_locationMarr addObject:rowsDict[@"location"][@"coordinates"]];
        }
        
        for (NSArray *locaAry in _locationMarr) {
            
            double la = [[NSString stringWithFormat:@"%.4f",[locaAry[1] doubleValue]] doubleValue];
            double lo = [[NSString stringWithFormat:@"%.4f",[locaAry[0] doubleValue]] doubleValue];
            NSLog(@"经度   %.4f",la);
            // 添加一个PointAnnotation
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = la;
            coor.longitude = lo;
            annotation.coordinate = coor;
            [self.mapView addAnnotation:annotation];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    [SVProgressHUD dismiss];
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        if (_n == 0) {
            [newAnnotationView setSelected:YES animated:YES];
        }
        //[self.listMary addObject:newAnnotationView];
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
    NSLog(@"数组个数  %zi",self.coverUrlMary.count);
    if (_n < self.coverUrlMary.count) {
        [image sd_setImageWithURL:[NSURL URLWithString:self.coverUrlMary[_n]]];
        [self setLabel:CGRectMake(50, 6, 100, 10) andText:self.titleMarr[_n] andFont:13 andView:imgV andtextColor:[UIColor blackColor]];
        [self setLabel:CGRectMake(50, 22, 100, 10) andText:self.addressMarr[_n] andFont:10 andView:imgV andtextColor:[UIColor grayColor]];
    }
    
    [imgV addSubview:image];
    
    _n++;
}

-(void)setLabel:(CGRect)frame andText:(NSString*)title andFont:(int)font andView:(UIView *)view andtextColor:(UIColor*)color{
    UILabel *titlelabel = [[UILabel alloc] initWithFrame:frame];
    titlelabel.text = title;
    titlelabel.font = [UIFont systemFontOfSize:font];
    titlelabel.textColor = color;
    [view addSubview:titlelabel];
    view.userInteractionEnabled = YES;
    //[view addGestureRecognizer:[self singleRecognizer]];
    
}



#pragma mark -
- (NSMutableArray *)idMarr {
    if (!_idMarr) {
        _idMarr = [NSMutableArray array];
    }
    return _idMarr;
}

- (NSMutableArray *)titleMarr {
    if (!_titleMarr) {
        _titleMarr = [NSMutableArray array];
    }
    return _titleMarr;
}

- (NSMutableArray *)addressMarr {
    if (!_addressMarr) {
        _addressMarr = [NSMutableArray array];
    }
    return _addressMarr;
}

- (NSMutableArray *)locationMarr {
    if (!_locationMarr) {
        _locationMarr = [NSMutableArray array];
    }
    return _locationMarr;
}


-(NSMutableArray *)coverUrlMary{
    if (!_coverUrlMary) {
        _coverUrlMary = [NSMutableArray array];
    }
    return _coverUrlMary;
}



-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _mapView.delegate = self;
        _mapView.zoomLevel = 18;
        _mapView.centerCoordinate = {_latitude,_longitude};
        
        [_mapView addSubview:self.positioningBtn];
        [_positioningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.left.mas_equalTo(_mapView.mas_left).with.offset(12);
            make.bottom.mas_equalTo(_mapView.mas_bottom).with.offset(-55);
        }];
        
        [_mapView addSubview:self.searchBtn];
        [_searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(105, 30));
            make.right.mas_equalTo(_mapView.mas_right).with.offset(-5);
            make.top.mas_equalTo(_mapView.mas_top).with.offset(10);
        }];
    }
    return _mapView;
}

-(UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[UIButton alloc] init];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = 2;
        [_searchBtn setTitle:@"重新搜索该区域" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _searchBtn.backgroundColor = [UIColor whiteColor];
        //[_searchBtn addTarget:self action:@selector(clickSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

//-(void)clickSearchBtn:(UIButton*)sender{
//    _n = 0;
//    for (int i = 0; i<_mapView.subviews.count; i++) {
//        if ([_mapView.subviews isKindOfClass:[BMKPointAnnotation class]]) {
//            [_mapView.subviews[i] removeFromSuperview];
//        }
//    }
//    [self requestDataForOderList];
//}

-(UIButton *)positioningBtn{
    if (!_positioningBtn) {
        _positioningBtn = [[UIButton alloc] init];
        [_positioningBtn setImage:[UIImage imageNamed:@"positionIcon"] forState:UIControlStateNormal];
        [_positioningBtn addTarget:self action:@selector(clickPositionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _positioningBtn;
}

-(void)clickPositionBtn:(UIButton*)sender{
    _mapView.centerCoordinate = {_latitude,_longitude};
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _mapView.delegate = nil;
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
