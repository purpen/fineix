//
//  SelectSceneViewController.m
//  fineix
//
//  Created by FLYang on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SelectSceneViewController.h"
#import "SelectAllFSceneViewController.h"
#import "SelectHotFSceneTableViewCell.h"
#import "FiuSceneInfoData.h"
#import "MapTableViewCell.h"
#import "AllNearbyScenarioViewController.h"
#import "FiuSceneTableViewCell.h"
#import "FiuSceneRow.h"

static NSString *const URLFSceneList = @"/scene_scene/";

@interface SelectSceneViewController ()

@pro_strong NSMutableArray      *   idMarr;         //  附近情景的ID
@pro_strong NSMutableArray      *   titleMarr;      //  标题
@pro_strong NSMutableArray      *   fiuInfoData;    //  情景数据
@pro_strong NSMutableArray      *   fiuIdMarr;      //  情景id
@pro_strong NSMutableArray      *   fiuTitleMarr;   //  情景标题
@pro_strong NSMutableArray      *   fiuSceneList;

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
        NSArray * fiuSceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * fiuSceneDic in fiuSceneArr) {
            FiuSceneRow * fiuSceneModel = [[FiuSceneRow alloc] initWithDictionary:fiuSceneDic];
            [self.fiuSceneList addObject:fiuSceneModel];
            [self.idMarr addObject:[NSString stringWithFormat:@"%zi", fiuSceneModel.idField]];
            [self.titleMarr addObject:fiuSceneModel.title];
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
    [self.view addSubview:self.selectTable];
}

#pragma mark - 
- (UITableView *)selectTable {
    if (!_selectTable) {
        _selectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:(UITableViewStyleGrouped)];
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
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString * fiuSceneCellId = @"fiuSceneCellId";
        FiuSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneCellId];
        if (!cell) {
            cell = [[FiuSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneCellId];
        }
        [cell setFiuSceneList:self.fiuSceneList idMarr:self.idMarr];
        return cell;
    
    } else if (indexPath.section == 1) {
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
        return 266.5;
        
    } else if (indexPath.section == 1) {
        SelectHotFSceneTableViewCell * cell = [[SelectHotFSceneTableViewCell alloc] init];
        [cell getCellHeiht:self.fiuInfoData];
        return cell.cellHeight;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self addHeaderView:NSLocalizedString(@"nearFiuScene", nil) withType:1];
    } else if (section == 1) {
        return [self addHeaderView:NSLocalizedString(@"reFiuScene", nil) withType:2];
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
    [btn setTitle:NSLocalizedString(@"lookAll", nil) forState:(UIControlStateNormal)];
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
- (NSMutableArray *)fiuSceneList {
    if (!_fiuSceneList) {
        _fiuSceneList = [NSMutableArray array];
    }
    return _fiuSceneList;
}

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
