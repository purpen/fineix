//
//  AllNearbyScenarioViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/10.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "AllNearbyScenarioViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import "SVProgressHUD.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AllNearbyScenarioViewController ()<FBNavigationBarItemsDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,BMKLocationServiceDelegate,BMKMapViewDelegate>
{
    BMKLocationService *_locService;
    float _latitude;
    float _longitude;
    int _n;
}
@property (weak, nonatomic) IBOutlet UITableView *sceneListTableView;
@property (weak, nonatomic) IBOutlet UIView *sceneMapView;
@property(nonatomic,strong) BMKMapView *mapView;
@property(nonatomic,strong) FBRequest *fSceneRequest;
@pro_strong NSMutableArray      *   idMarr;         //  附近情景的ID
@pro_strong NSMutableArray      *   titleMarr;      //  标题
@pro_strong NSMutableArray      *   addressMarr;    //  地址
@pro_strong NSMutableArray      *   locationMarr;   //  位置
@pro_strong NSMutableArray      *   coverUrlMary;   //  图片
@pro_strong NSMutableArray      *   listMary;   //
@pro_strong UILabel             *   cellLine;
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;

@end

@implementation AllNearbyScenarioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _n = 0;
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"选择情景";
    [self addBarItemRightBarButton:@"确定" image:nil isTransparent:NO];
    [self getLocation];
    
    self.sceneListTableView.delegate = self;
    self.sceneListTableView.dataSource = self;
    self.sceneListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.sceneListTableView.showsVerticalScrollIndicator = NO;
    self.sceneListTableView.rowHeight = 60;
    
    //上拉加载更多
    self.sceneListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
            [self requestDataForOderListOperation];
        } else {
            [self.sceneListTableView.mj_footer endRefreshing];
        }
    }];
}

//上拉
- (void)requestDataForOderListOperation
{
    [SVProgressHUD show];
    self.fSceneRequest = [FBAPI getWithUrlString:@"/scene_scene/" requestDictionary:@{@"lng":@(_longitude), @"lat":@(_latitude), @"dis":@(5000), @"page":@(_currentPageNumber+1), @"size":@"1000"} delegate:self];
    [self.fSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"附近的情景  %@",result);
        NSArray * dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * dataDic in dataArr) {
            [self.idMarr addObject:[dataDic valueForKey:@"_id"]];
            [self.titleMarr addObject:[dataDic valueForKey:@"title"]];
            [self.addressMarr addObject:[dataDic valueForKey:@"address"]];
            [self.locationMarr addObject:[dataDic valueForKey:@"location"]];
            if (![[dataDic objectForKey:@"cover_url"] isKindOfClass:[NSNull class]]) {
                [self.coverUrlMary addObject:[dataDic objectForKey:@"cover_url"]];
            }
            
        }
        for (NSDictionary *logDict in self.locationMarr) {
            NSArray *logAry = logDict[@"coordinates"];
            double la = [logAry[1] doubleValue];
            double lo = [logAry[0] doubleValue];
            // 添加一个PointAnnotation
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = la;
            coor.longitude = lo;
            annotation.coordinate = coor;
            [self.mapView addAnnotation:annotation];
        }
        
        [self.sceneMapView addSubview:self.mapView];
        [self.sceneListTableView reloadData];
        [SVProgressHUD dismiss];
        
        

        NSDictionary *logDict = self.locationMarr[0];
        NSArray *logAry = logDict[@"coordinates"];
        double la = [logAry[1] doubleValue];
        double lo = [logAry[0] doubleValue];
        _mapView.centerCoordinate = {la,lo};
        
        
        _currentPageNumber = [[result valueForKey:@"data"][@"current_page"] integerValue];
        _totalPageNumber = [[result valueForKey:@"data"][@"total_page"] integerValue];
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.sceneListTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.sceneListTableView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            self.sceneListTableView.mj_footer.state = MJRefreshStateNoMoreData;
            self.sceneListTableView.mj_footer.hidden = true;
        }
        
        if ([self.sceneListTableView.mj_header isRefreshing]) {
            [self.sceneListTableView.mj_header endRefreshing];
        }
        if ([self.sceneListTableView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.sceneListTableView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.sceneListTableView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        //newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        if (_n == 0) {
            [newAnnotationView setSelected:YES animated:YES];
        }
        [self.listMary addObject:newAnnotationView];
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

#pragma mark - 获取当前位置坐标
- (void)getLocation {
    //  判断是否开启GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        [self startFixedPosition];
        
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"openGPS", nil)];
    }
}

#pragma mark - 初始化百度地图服务
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
    [_locService stopUserLocationService];
    // 添加一个PointAnnotation
    //[self addPointAnnotation:_latitude andLongitude:_longitude];
    [self requestDataForOderList];
}


- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.idMarr removeAllObjects];
    [self.titleMarr removeAllObjects];
    [self.addressMarr removeAllObjects];
    [self.locationMarr removeAllObjects];
    [self.coverUrlMary removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}



-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.sceneMapView.frame];
        _mapView.delegate = self;
        _mapView.zoomLevel = 15;
    }
    return _mapView;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.idMarr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * nearbyFSceneCellId = @"NearbyFSceneCellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nearbyFSceneCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:nearbyFSceneCellId];
    }
    if (cell.selected) {
        cell.selected = NO;
    }
    cell.textLabel.text = self.titleMarr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.text = self.addressMarr[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:titleColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellLine = [[UILabel alloc] initWithFrame:CGRectMake(15, 59, SCREEN_WIDTH - 15, 1)];
    self.cellLine.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    [cell.contentView addSubview:self.cellLine];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark - 选中附近的情景
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * array = [tableView visibleCells];
    for (UITableViewCell * cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    BMKPinAnnotationView *newAnnotationView = self.listMary[indexPath.row];
    [newAnnotationView setSelected:YES animated:YES];
    NSLog(@" 选中附近的情景： id－－－%@  标题 ＝＝＝ %@", self.idMarr[indexPath.row], self.titleMarr[indexPath.row]);
}

-(void)rightBarItemSelected{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    _locService.delegate = nil;
    self.mapView.delegate = nil;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
