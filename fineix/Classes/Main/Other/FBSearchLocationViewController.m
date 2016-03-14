//
//  LocationViewController.m
//  BaDuMapTest1
//
//  Created by THN-Dong on 16/3/9.
//  Copyright © 2016年 Dong. All rights reserved.
//

#import "FBSearchLocationViewController.h"
#import "AFNetworking.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "MBProgressHUD.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MJRefresh.h"


@interface FBSearchLocationViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate>

{
    
    BMKGeoCodeSearch *_searcher;//正向地理编码对象
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;//反向地理编码
    
    MBProgressHUD *_hud;
    NSString *_address;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (nonatomic, strong) BMKLocationService *locationSevice;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic, strong) BMKGeoCodeSearch *codeSearch;//地理位置搜索对象（地理位置坐标编码）
@end

@implementation FBSearchLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __block int m = 1;
    _dataAry = [NSMutableArray array];
    _dataAry3 = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
    
    _searchTF.delegate = self;
    
    
    
    _tableV.dataSource = self;
    _tableV.delegate = self;
    
    
    NSLog(@"%d",_dataAry.count);
    
    //创建定为服务对象
    self.locationSevice = [[BMKLocationService alloc] init];
    //设置定位服务对象代理
    self.locationSevice.delegate = self;
    self.locationSevice.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //设置再次定位的最小距离
    
    //设置再次定位的时间
    
    //创建地理位置搜索对象
    self.codeSearch = [[BMKGeoCodeSearch alloc] init];
    //设置地理位置搜索对象代理
    self.codeSearch.delegate = self;
    
    
    self.tableV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=yO2KX6h4Gy5Tv4MYNrZFZLzN&output=json&query=%@&page_size=10&page_num=%d&scope=1&region=%@",_address,m,@"全国"];
        m = m + 1;
        NSString * urlstr = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL * URL = [NSURL URLWithString:urlstr];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                
                
                [self performSelectorOnMainThread:@selector(getDataList2:)
                                       withObject:responseObject // 将局部变量dataList作为参数传出去
                                    waitUntilDone:YES];
                
                
            }
        }];
        [dataTask resume];
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    //开始定位
    [self startLocation];
}

-(void)getDataList2:(id)sender{
    [_hud hideAnimated:YES];
    NSArray *resultAry = [sender valueForKey:@"results"];
    
    
    for (int i = 0; i<resultAry.count; i++) {
        NSDictionary *resultDict = resultAry[i];
        
        NSString *name = [resultDict valueForKey:@"name"];
        
        [_dataAry addObject:name];
        NSString *district = [resultDict valueForKey:@"address"];
        [_dataAry3 addObject:district];
        
    }
    [_tableV reloadData];
    
    
}

#pragma mark -开始定位
-(void)startLocation{
    //1，开启定位服务
    [self.locationSevice startUserLocationService];
    //2，在地图上显示用户的位置
    
    
}

#pragma mark -BMKLocationServiceDelegate
-(void)willStartLocatingUser{
    NSLog(@"开始定位");
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败%@",error);
    [_hud hideAnimated:YES];
}

//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //发起反向地理编码检索
    //CLLocationCoordinate2D pt = (CLLocationCoordinate2D){39.915, 116.404};
    _reverseGeoCodeSearchOption = [[
                                    BMKReverseGeoCodeOption alloc]init];
    _reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [self.codeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    if(flag)
    {
        //NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    //定义大头针标注
    
    //设置标注的位置坐标
    
    //NSLog(@"纬度%f,经度%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.locationSevice.delegate = nil;
    self.codeSearch.delegate = nil;
    _searcher.delegate = nil;
}

#pragma mark -BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error{
    if (searcher == self.codeSearch) {
        if (error == BMK_SEARCH_NO_ERROR) {
            
            _address = result.address;
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/search?ak=yO2KX6h4Gy5Tv4MYNrZFZLzN&output=json&query=%@&page_size=10&page_num=0&scope=1&region=%@",result.address,@"全国"];
            
            NSString * urlstr = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
            NSURL * URL = [NSURL URLWithString:urlstr];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                if (error) {
                    NSLog(@"Error: %@", error);
                } else {
                    
                    
                    [self performSelectorOnMainThread:@selector(getDataList:)
                                           withObject:responseObject // 将局部变量dataList作为参数传出去
                                        waitUntilDone:YES];
                    
                    
                }
            }];
            [dataTask resume];
        }
        else {
            NSLog(@"抱歉，未找到结果");
            [_dataAry addObject:@"抱歉，未找到结果"];
        }
    }
    
    
}


-(void)getDataList:(id)sender{
    [_hud hideAnimated:YES];
    NSArray *resultAry = [sender valueForKey:@"results"];
    
    [_dataAry removeAllObjects];
    [_dataAry3 removeAllObjects];
    for (int i = 0; i<resultAry.count; i++) {
        NSDictionary *resultDict = resultAry[i];
        
        NSString *name = [resultDict valueForKey:@"name"];
        
        [_dataAry addObject:name];
        NSString *district = [resultDict valueForKey:@"address"];
        [_dataAry3 addObject:district];
        
    }
    [_tableV reloadData];
    [self.locationSevice stopUserLocationService];
    
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
    NSLog(@"%d",_dataAry.count);
    cell.textLabel.text = _dataAry[indexPath.row];
    cell.detailTextLabel.text = _dataAry3[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 44;
    }
    return 70;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self starGeoCode];
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"Loading";
    return [textField resignFirstResponder];
    _address = textField.text;
}

-(void)starGeoCode{
    [_searchTF resignFirstResponder];
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = _searchTF.text;
    BOOL flag = [_searcher geoCode:geoCodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
}
//实现Deleage处理回调结果
//接收正向编码结果

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/place/v2/suggestion?query=%@&region=131&output=json&ak=yO2KX6h4Gy5Tv4MYNrZFZLzN",_searchTF.text];
        
        NSString * urlstr = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSURL * URL = [NSURL URLWithString:urlstr];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                
                
                
                [self performSelectorOnMainThread:@selector(getDataList1:)
                                       withObject:responseObject // 将局部变量dataList作为参数传出去
                                    waitUntilDone:YES];
                NSLog(@"%@",responseObject);
            }
        }];
        [dataTask resume];
        
        

        
    }
    else {
        NSLog(@"抱歉，未找到结果");
        [_dataAry addObject:@"抱歉，未找到结果"];
        [_hud hideAnimated:YES];
        [_tableV reloadData];
    }
}




-(void)getDataList1:(id)sender{
    
    [_hud hideAnimated:YES];
    [_dataAry removeAllObjects];
    [_dataAry3 removeAllObjects];
    NSArray *resultAry = [sender valueForKey:@"result"];
    for (int i = 0; i<resultAry.count; i++) {
        NSDictionary *resultDict = resultAry[i];
        
        NSString *name = [resultDict valueForKey:@"name"];
        
        [_dataAry addObject:name];
        NSString *district = [resultDict valueForKey:@"district"];
        [_dataAry3 addObject:district];
        
    }
    [_tableV reloadData];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchTF resignFirstResponder];
    
    [_daleget getAddress:_dataAry[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    _searchTF.text = @"";
    [_dataAry removeAllObjects];
    [_dataAry3 removeAllObjects];
    [_tableV reloadData];
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
