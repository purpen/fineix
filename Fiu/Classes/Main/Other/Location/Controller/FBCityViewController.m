//
//  FBCityViewController.m
//  Fiu
//
//  Created by FLYang on 16/4/27.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBCityViewController.h"
#import "Fiu.h"
#import "CityTwoTableViewCell.h"
#import "CityTableViewCell.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "CityModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface FBCityViewController ()<UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;//反向地理编码对象
    NSMutableArray *_modelAry;
    float _la;
    float _lo;
    BOOL _isHave;
}
@property (nonatomic, strong) BMKLocationService *locationSevice;
@property (nonatomic, strong) BMKGeoCodeSearch *codeSearch;//地理位置搜索对象（地理位置坐标编码）
@end

static NSString *cityListStr = @"/estore/get_city_list";

@implementation FBCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    [self.view addSubview:self.myTableView];
    
    FBRequest *request = [FBAPI postWithUrlString:cityListStr requestDictionary:@{@"type":@"scene"} delegate:self];
    request.flag = cityListStr;
    [request startRequest];
}

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isHave) {
        
        if (indexPath.row == 0) {
            static NSString *cellOne = @"cellOne";
            CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellOne];
            if (cell == nil) {
                cell = [[CityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellOne];
            }
            CityModel *model = _modelAry[indexPath.row];
            NSLog(@"model%@",model.name);
            [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
            cell.locationLabel.text = [NSString stringWithFormat:@"当前位置：%@",model.name];
            return cell;
        }
        
        static NSString *cellTwo = @"cellTwo";
        CityTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTwo];
        if (cell == nil) {
            cell = [[CityTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        }
        CityModel *model = _modelAry[indexPath.row];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
        cell.locationLabel.text = model.name;
        return cell;
    }else{
        CityModel *model = _modelAry[indexPath.row];
        static NSString *cellTwo = @"cellTwo";
        CityTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTwo];
        if (cell == nil) {
            cell = [[CityTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellTwo];
        }
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
        cell.locationLabel.text = model.name;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 184/667.0*SCREEN_HEIGHT;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _modelAry = [NSMutableArray array];
    _isHave = NO;
}

-(void)requestSucess:(FBRequest *)request result:(id)result{
    if ([request.flag isEqualToString:cityListStr]) {
        if ([result objectForKey:@"success"]) {
            NSArray *dataAry = [result objectForKey:@"data"];
            for (NSDictionary *dataDict in dataAry) {
                CityModel *model = [[CityModel alloc] init];
                model.name = dataDict[@"name"];
                model.image_url = dataDict[@"image_url"];
                model.lng = dataDict[@"lng"];
                model.lat = dataDict[@"lat"];
                [_modelAry addObject:model];
            }
        }
        
        //创建定为服务对象
        self.locationSevice = [[BMKLocationService alloc] init];
        //设置定位服务对象代理
        self.locationSevice.delegate = self;
        self.locationSevice.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        //1，开启定位服务
        [self.locationSevice startUserLocationService];
        
        
        [self.myTableView reloadData];
    }
}

#pragma mark -BMKLocationServiceDelegate
-(void)willStartLocatingUser{
    NSLog(@"开始定位");
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"定位失败%@",error);
    //[_hud hideAnimated:YES];
}

//定位成功，再次定位
-(void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _la = userLocation.location.coordinate.latitude;
    _lo = userLocation.location.coordinate.longitude;
    
    NSLog(@"定位成功");
    [_locationSevice stopUserLocationService];
    
    //发起反向地理编码检索
    //创建地理位置搜索对象
    self.codeSearch = [[BMKGeoCodeSearch alloc] init];
    //设置地理位置搜索对象代理
    self.codeSearch.delegate = self;
        _reverseGeoCodeSearchOption = [[
                                        BMKReverseGeoCodeOption alloc]init];
        _reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [self.codeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
        if(flag)
        {
            NSLog(@"反geo检索发送成功");
        }
        else
        {
            NSLog(@"反geo检索发送失败");
        }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      NSLog(@"%@",result.address);
      for (CityModel *model in _modelAry) {
          if ([result.address rangeOfString:model.name].location != NSNotFound) {
              NSLog(@"model %@",model.name);
              NSUInteger i = [_modelAry indexOfObject:model];
              [_modelAry exchangeObjectAtIndex:i withObjectAtIndex:0];
              _isHave = YES;
              [self.myTableView reloadData];
              return;
          }
      }
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    self.navViewTitle.text = NSLocalizedString(@"CityVcTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemRightBarButton:@"全部城市" image:@"icon_map" isTransparent:NO];
}

@end
