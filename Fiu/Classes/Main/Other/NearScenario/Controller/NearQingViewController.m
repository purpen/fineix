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

@interface NearQingViewController ()<BMKMapViewDelegate>
{
    float _latitude;
    float _longitude;
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

- (void)requestDataForOderList
{
    [self.idMarr removeAllObjects];
    [self.titleMarr removeAllObjects];
    [self.addressMarr removeAllObjects];
    [self.locationMarr removeAllObjects];
    [self.coverUrlMary removeAllObjects];
    
    [self requestDataForOderListOperation];
}

- (void)requestDataForOderListOperation
{
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
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
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



//-(BMKMapView *)mapView{
//    if (!_mapView) {
//        _mapView = [[BMKMapView alloc] initWithFrame:self.sceneMapView.frame];
//        _mapView.delegate = self;
//        _mapView.zoomLevel = 15;
//    }
//    return _mapView;
//}

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
