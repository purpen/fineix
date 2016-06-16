//
//  SelectSceneViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectSceneViewController.h"
#import "SearchFSceneViewController.h"
#import "SelectAllFSceneViewController.h"
#import "SelectHotFSceneTableViewCell.h"
#import "FiuSceneInfoData.h"
#import "MapTableViewCell.h"
#import "AllNearbyScenarioViewController.h"

static NSString *const URLFSceneList = @"/scene_scene/";

@interface SelectSceneViewController ()

@pro_strong NSMutableArray      *   idMarr;         //  附近情景的ID
@pro_strong NSMutableArray      *   titleMarr;      //  标题
@pro_strong NSMutableArray      *   addressMarr;    //  地址
@pro_strong NSMutableArray      *   locationMarr;   //  位置
@pro_strong NSMutableArray      *   fiuInfoData;    //  情景数据
@pro_strong NSMutableArray      *   fiuIdMarr;      //  情景id
@pro_strong NSMutableArray      *   fiuTitleMarr;   //  情景标题

@end

@implementation SelectSceneViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavViewUI];
    [self getLocation];
    
    //  from: "SelectHotFSceneTableViewCell.h"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSelectId:) name:@"getSelectId" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self networkSearchSceneData];
    [self networkHotFSceneData];

}

//  获取选择的情景ID
- (void)getSelectId:(NSNotification *)idx {
    self.fSceneId = self.fiuIdMarr[[[idx object] integerValue]];
    self.fSceneTitle = self.fiuTitleMarr[[[idx object] integerValue]];
}

#pragma mark - 网络请求
#pragma mark 附近的情景
- (void)networkSearchSceneData {
    [SVProgressHUD show];
    self.fSceneRequest = [FBAPI getWithUrlString:URLFSceneList requestDictionary:@{@"lng":@(longitude), @"lat":@(latitude), @"dis":@(5000), @"page":@"1", @"size":@"3"} delegate:self];
    [self.fSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self setSelectFSceneVcUI];
        NSArray * dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * dataDic in dataArr) {
            [self.idMarr addObject:[NSString stringWithFormat:@"%@", [dataDic valueForKey:@"_id"]]];
            [self.titleMarr addObject:[dataDic valueForKey:@"title"]];
            [self.addressMarr addObject:[dataDic valueForKey:@"address"]];
            [self.locationMarr addObject:[dataDic valueForKey:@"location"]];
        }
        
        [self.selectTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 推荐的情景
- (void)networkHotFSceneData {
    [SVProgressHUD show];
    self.hotFSceneRequest = [FBAPI getWithUrlString:URLFSceneList requestDictionary:@{@"sort":@"1",@"page":@"1",@"size":@"10"} delegate:self];
    [self.hotFSceneRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * dataArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in dataArr) {
            FiuSceneInfoData * allFiuScene = [[FiuSceneInfoData alloc] initWithDictionary:sceneDic];
            [self.fiuInfoData addObject:allFiuScene];
            [self.fiuIdMarr addObject:[NSString stringWithFormat:@"%zi", allFiuScene.idField]];
            [self.fiuTitleMarr addObject:allFiuScene.title];
        }
        [self.selectTable reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图
- (void)setSelectFSceneVcUI {
    [self.view addSubview:self.beginSearchBtn];
    
    [self.view addSubview:self.selectTable];
}

#pragma mark - 
- (UITableView *)selectTable {
    if (!_selectTable) {
        _selectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_HEIGHT - 100) style:(UITableViewStyleGrouped)];
        _selectTable.delegate = self;
        _selectTable.dataSource = self;
        _selectTable.sectionFooterHeight = 0.01f;
        _selectTable.backgroundColor = [UIColor whiteColor];
        _selectTable.showsVerticalScrollIndicator = NO;
        _selectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _selectTable.tableFooterView = [UIView new];
    }
    return _selectTable;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.titleMarr.count;
    } else if (section == 2) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *mapCellId = @"mapCellId";
        MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mapCellId];
        if (cell == nil) {
            cell = [[MapTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mapCellId];
        }
        cell.ary = self.locationMarr;
        [cell setUIWithAry:self.locationMarr];
        return cell;
    }
    if (indexPath.section == 1) {
        static NSString * nearbyFSceneCellId = @"NearbyFSceneCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:nearbyFSceneCellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:nearbyFSceneCellId];
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
    
    } else if (indexPath.section == 2) {
        static NSString * selectHotFsceneCellId = @"SelectHotFsceneCellId";
        SelectHotFSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:selectHotFsceneCellId];
        if (!cell) {
            cell = [[SelectHotFSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:selectHotFsceneCellId];
        }
        [cell setSelectHotFSceneData:self.fiuInfoData];
        return cell;
    }
    
    static NSString * CellId = @"CellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:CellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 145;
    } else if (indexPath.section == 1) {
        return 60;
    } else if (indexPath.section == 2) {
        SelectHotFSceneTableViewCell * cell = [[SelectHotFSceneTableViewCell alloc] init];
        [cell getCellHeiht:self.fiuInfoData];
        return cell.cellHeight + 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return [self addHeaderView:@"附近的情景" withType:1];
    } else if (section == 2) {
        return [self addHeaderView:@"推荐情景" withType:2];
    }
    return nil;
}

- (UIView *)addHeaderView:(NSString *)title withType:(NSInteger)type {
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    
    UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 200, 22)];
    lab.font = [UIFont systemFontOfSize:16];
    lab.textColor = [UIColor colorWithHexString:@"#000000"];
    lab.text = title;
    [view addSubview:lab];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, 0, 60, 40)];
    [btn setTitle:@"查看全部" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    if (type == 2) {
        [btn addTarget:self action:@selector(lookAllFScene) forControlEvents:(UIControlEventTouchUpInside)];
    } else if (type == 1) {
        [btn addTarget:self action:@selector(lookNearbyFScene) forControlEvents:(UIControlEventTouchUpInside)];
    }
    [view addSubview:btn];
    
    return view;
}

#pragma mark - 查看全部情景
- (void)lookAllFScene {
    SelectAllFSceneViewController * allFSceneVC = [[SelectAllFSceneViewController alloc] init];
    allFSceneVC.type = self.type;
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController pushViewController:allFSceneVC animated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        allFSceneVC.dismissVC = ^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:allFSceneVC animated:YES completion:nil];
    }
}

#pragma mark - 查看全部附近的情景
- (void)lookNearbyFScene {
    AllNearbyScenarioViewController * nearFiuSceneVC = [[AllNearbyScenarioViewController alloc] init];
    nearFiuSceneVC.type = self.type;
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController pushViewController:nearFiuSceneVC animated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        nearFiuSceneVC.dismissVC = ^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:nearFiuSceneVC animated:YES completion:nil];
    }
}

#pragma mark - 选中附近的情景
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.getIdxAndTitltBlock(self.idMarr[indexPath.row], self.titleMarr[indexPath.row]);
        if ([self.type isEqualToString:@"release"]) {
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([self.type isEqualToString:@"edit"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - 获取当前位置坐标
- (void)getLocation {
    //  判断是否开启GPS定位
    if ([CLLocationManager locationServicesEnabled]) {
        [self initBMKService];
        
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"openGPS", nil)];
    }
}

#pragma mark - 初始化百度地图服务
- (void)initBMKService {
    _locationSearch = [[BMKLocationService alloc] init];
    
    //  开始定位
    [_locationSearch startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    latitude = _locationSearch.userLocation.location.coordinate.latitude;
    longitude = _locationSearch.userLocation.location.coordinate.longitude;
    
    [_locationSearch stopUserLocationService];
}

#pragma mark - 搜索情境按钮
- (UIButton *)beginSearchBtn {
    if (!_beginSearchBtn) {
        _beginSearchBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 57, SCREEN_WIDTH - 30, 32)];
        _beginSearchBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
        _beginSearchBtn.layer.borderWidth = 0.5f;
        _beginSearchBtn.layer.cornerRadius = 4;
        _beginSearchBtn.layer.masksToBounds = YES;
        [_beginSearchBtn setTitle:NSLocalizedString(@"searchFScene", nil) forState:(UIControlStateNormal)];
        [_beginSearchBtn setTitleColor:[UIColor colorWithHexString:titleColor] forState:(UIControlStateNormal)];
        _beginSearchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_beginSearchBtn setImage:[UIImage imageNamed:@"Search"] forState:(UIControlStateNormal)];
        [_beginSearchBtn setImageEdgeInsets:(UIEdgeInsetsMake(0, -10, 0, 0))];
        [_beginSearchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _beginSearchBtn;
}

#pragma mark - 跳转搜索情境
- (void)searchBtnClick {
    SearchFSceneViewController * searchFSceneVC = [[SearchFSceneViewController alloc] init];
    searchFSceneVC.type = self.type;
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController pushViewController:searchFSceneVC animated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        searchFSceneVC.dismissVC = ^ {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        [self presentViewController:searchFSceneVC animated:YES completion:nil];
    }
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:NSLocalizedString(@"chooseSceneVcTitle", nil)];
    self.navTitle.textColor = [UIColor blackColor];
    if ([self.type isEqualToString:@"release"]) {
        [self addBackButton:@"icon_back"];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self addCloseBtn];
    }
    [self addLine];
    [self.navView addSubview:self.sureBtn];
}

#pragma mark - 确定按钮
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:Font_ControllerTitle];
        [_sureBtn setTitle:NSLocalizedString(@"sure", nil) forState:(UIControlStateNormal)];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureBtn;
}

#pragma mark - 选择情景返回
- (void)sureBtnClick {
    self.getIdxAndTitltBlock(self.fSceneId, self.fSceneTitle);
    if ([self.type isEqualToString:@"release"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([self.type isEqualToString:@"edit"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getSelectId" object:nil];
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

- (NSMutableArray *)fiuInfoData {
    if (!_fiuInfoData) {
        _fiuInfoData = [NSMutableArray array];
    }
    return _fiuInfoData;
}

- (NSMutableArray *)fiuIdMarr {
    if (!_fiuIdMarr) {
        _fiuIdMarr = [NSMutableArray array];
    }
    return _fiuIdMarr;
}

- (NSMutableArray *)fiuTitleMarr {
    if (!_fiuTitleMarr) {
        _fiuTitleMarr = [NSMutableArray array];
    }
    return _fiuTitleMarr;
}

@end
