//
//  FBLocationViewController.m
//  BaDuMapTest1
//
//  Created by THN-Dong on 16/3/16.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FBLocationViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "MJRefresh.h"

@interface FBLocationViewController ()<UITextFieldDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,UITableViewDataSource,UITableViewDelegate,BMKGeoCodeSearchDelegate>
{
    float _la;
    float _lo;
    BMKPoiSearch *_poiSearcher;
    NSMutableArray *_dataAry;
    NSMutableArray *_detailsAry;
    __block int _m;
    BMKGeoCodeSearch *_searcher;//正向地理编码对象
}
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, strong) BMKLocationService *locationSevice;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@end

@implementation FBLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableV.dataSource = self;
    _tableV.delegate = self;
    
    [self TheLoadMore];
    //搜索输入
    _searchTF.delegate = self;
    _searchTF.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search2"]];
    
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
}


//退出后重置




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_dataAry removeAllObjects];
    [_detailsAry removeAllObjects];
    //POI搜索
    [self POIsearch:0 :textField.text];
    return [textField resignFirstResponder];
    
}

-(void)Geocoding:(NSString*)name{
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = name;
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
    }
    else
    {
    }

}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        
        
    }
    else {
    }
}

-(void)viewWillAppear:(BOOL)animated{
    _dataAry = [NSMutableArray array];
    _detailsAry = [NSMutableArray array];
    //[_hud hideAnimated:YES];
    [self ToLocate];
    _m = 1;
    _searchTF.text = @"";
    self.tableV.mj_footer.hidden = NO;
}

-(void)TheLoadMore{
    
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self POIsearch:_m :@"景点"];
        _m++;
        //self.tableV.mj_footer.hidden = YES;
        [self.tableV.mj_footer endRefreshing];
    }];
    
}

#pragma mark -BMKLocationServiceDelegate
-(void)willStartLocatingUser{
}

-(void)didFailToLocateUserWithError:(NSError *)error{
}

//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _la = userLocation.location.coordinate.latitude;
    _lo = userLocation.location.coordinate.longitude;
    
    [self POIsearch:0 :@"景点"];
    [_locationSevice stopUserLocationService];
}


-(void)ToLocate{
    //创建定为服务对象
    self.locationSevice = [[BMKLocationService alloc] init];
    //设置定位服务对象代理
    self.locationSevice.delegate = self;
    self.locationSevice.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //1，开启定位服务
    [self.locationSevice startUserLocationService];
}

-(void)POIsearch :(int) page :(NSString*)str{
    //初始化检索对象
    _poiSearcher =[[BMKPoiSearch alloc]init];
    _poiSearcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = page;
    option.pageCapacity = 20;
    option.radius = 1000;
    option.location = CLLocationCoordinate2DMake(_la , _lo);
    option.keyword = str;
    BOOL flag = [_poiSearcher poiSearchNearBy:option];
    if(flag)
    {
    }
    else
    {
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //数据展示
        for (int i = 0; i<poiResultList.poiInfoList.count; i++) {
            [_dataAry addObject:((BMKPoiInfo*)poiResultList.poiInfoList[i]).name];
            [_detailsAry addObject:((BMKPoiInfo*)poiResultList.poiInfoList[i]).address];
        }
        [_tableV reloadData];
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
    } else {
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataAry.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *str = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.backgroundColor = [UIColor colorWithRed:250/255.0 green:251/255.0 blue:253/255.0 alpha:1];
    cell.textLabel.text = _dataAry[indexPath.row];
    cell.detailTextLabel.text = _detailsAry[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchTF resignFirstResponder];
    [_daleget getAddress:_dataAry[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
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
