//
//  THNChooseCityViewController.m
//  Fiu
//
//  Created by FLYang on 2016/10/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNChooseCityViewController.h"
#import "THNProvinceModel.h"

static NSString *const URLChinaCity = @"/shopping/fetch_china_city";
static NSString *const addressCell = @"addressCellCellId";

@interface THNChooseCityViewController () {
    NSInteger _nowSelectType;
}

@end

@implementation THNChooseCityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navView.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nowSelectType = 0;
    [self thn_setViewUI];
    
    [self thn_networkGetProvinceData];
}

#pragma mark - 请求地址网络数据
#pragma mark 获取省份
- (void)thn_networkGetProvinceData {
    self.provinceRequest = [FBAPI getWithUrlString:URLChinaCity requestDictionary:@{@"pid":@"0", @"layer":@"1"} delegate:self];
    [self.provinceRequest startRequestSuccess:^(FBRequest *request, id result) {

        [self thn_getNetworkDataResult:result city:self.provinceMarr cityId:self.provinceIdMarr];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 获取城市
- (void)thn_networkGetCityData:(NSInteger)index {
    NSString *province_id = self.provinceIdMarr[index];
    [self.addressIdMarr addObject:province_id];
    NSString *province_name = self.provinceMarr[index];
    [self.addressNameMarr addObject:province_name];
    
    self.cityRequest = [FBAPI getWithUrlString:URLChinaCity requestDictionary:@{@"pid":province_id, @"layer":@"2"} delegate:self];
    [self.cityRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        [self thn_getNetworkDataResult:result city:self.cityMarr cityId:self.cityIdMarr];

    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 获取地区
- (void)thn_networkGetCountyData:(NSInteger)index {
    NSString *city_id = self.cityIdMarr[index];
    [self.addressIdMarr addObject:city_id];
    NSString *city_name = self.cityMarr[index];
    [self.addressNameMarr addObject:city_name];
    
    self.countyRequest = [FBAPI getWithUrlString:URLChinaCity requestDictionary:@{@"pid":city_id, @"layer":@"3"} delegate:self];
    [self.countyRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        [self thn_getNetworkDataResult:result city:self.countyMarr cityId:self.countyIdMarr];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 获取街道
- (void)thn_networkGetStreetData:(NSInteger)index {
    NSString *county_id = self.countyIdMarr[index];
    [self.addressIdMarr addObject:county_id];
    NSString *county_name = self.countyMarr[index];
    [self.addressNameMarr addObject:county_name];
    
    self.streetRequest = [FBAPI getWithUrlString:URLChinaCity requestDictionary:@{@"pid":county_id, @"layer":@"4"} delegate:self];
    [self.streetRequest startRequestSuccess:^(FBRequest *request, id result) {
        [self thn_getNetworkDataResult:result city:self.streetMarr cityId:self.streetIdMarr];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark 街道获取完成
- (void)thn_networkGetAddressIdDone:(NSInteger)index {
    NSString *street_id = self.streetIdMarr[index];
    [self.addressIdMarr addObject:street_id];
    NSString *street_name = self.streetMarr[index];
    [self.addressNameMarr addObject:street_name];
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.getChooseAddressId(self.addressIdMarr[0],
                                self.addressIdMarr[1],
                                self.addressIdMarr[2],
                                self.addressIdMarr[3]);
        
        self.getChooseAddressName(self.addressNameMarr[0],
                                  self.addressNameMarr[1],
                                  self.addressNameMarr[2],
                                  self.addressNameMarr[3]);
    }];
}

/**
 保存地址数据

 @param result 地址数据
 @param city   地址名称
 @param cityId 地址id
 */
- (void)thn_getNetworkDataResult:(id)result city:(NSMutableArray *)city cityId:(NSMutableArray *)cityId {
    if (city.count) {
        [city removeAllObjects];
        [cityId removeAllObjects];
    }
    _nowSelectType += 1;
    if (_nowSelectType > 1) {
        self.backButton.hidden = NO;
    }
    NSArray *modelArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
    if (modelArr.count == 0) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.getChooseAddressId(self.addressIdMarr[0],
                                    self.addressIdMarr[1],
                                    self.addressIdMarr[2],
                                    @"0");
            
            self.getChooseAddressName(self.addressNameMarr[0],
                                      self.addressNameMarr[1],
                                      self.addressNameMarr[2],
                                      @"");
        }];
        
    } else {
        for (NSDictionary *modelDict in modelArr) {
            THNProvinceModel *model = [[THNProvinceModel alloc] initWithDictionary:modelDict];
            [city addObject:model.cityName];
            [cityId addObject:model.oid];
        }
        [self.chooseCityTable reloadData];
    }
}

#pragma mark - 设置视图
- (void)thn_setViewUI {
    [self.view addSubview:self.chooseCityTable];
    [self.view addSubview:self.promptView];
}

#pragma mark - init
- (UIView *)promptView {
    if (!_promptView) {
        _promptView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 340, SCREEN_WIDTH, 40)];
        _promptView.backgroundColor = [UIColor whiteColor];
        [_promptView addSubview:self.backButton];
        [_promptView addSubview:self.textLable];
        UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
        lineLab.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
        [_promptView addSubview:lineLab];
    }
    return _promptView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [_backButton setImage:[UIImage imageNamed:@"icon_back_black"] forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _backButton.hidden = YES;
    }
    return _backButton;
}

- (void)backButtonClick:(UIButton *)button {
    _nowSelectType -= 1;
    [self.addressIdMarr removeLastObject];
    [self.addressNameMarr removeLastObject];
    if (_nowSelectType <= 1) {
        self.backButton.hidden = YES;
        [self.addressIdMarr removeAllObjects];
        [self.addressNameMarr removeAllObjects];
    }
    [self.chooseCityTable reloadData];
}

- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH - 80, 40)];
        _textLable.font = [UIFont systemFontOfSize:12];
        _textLable.textColor = [UIColor colorWithHexString:@"#666666"];
        _textLable.text = NSLocalizedString(@"pleastChooseCity", nil);
        _textLable.textAlignment = NSTextAlignmentCenter;
    }
    return _textLable;
}

- (UITableView *)chooseCityTable {
    if (!_chooseCityTable) {
        _chooseCityTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 300) style:(UITableViewStylePlain)];
        _chooseCityTable.delegate = self;
        _chooseCityTable.dataSource = self;
        _chooseCityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chooseCityTable.backgroundColor = [UIColor whiteColor];
    }
    return _chooseCityTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_nowSelectType) {
        case 1:
            return self.provinceMarr.count;
            break;
        case 2:
            return self.cityMarr.count;
            break;
        case 3:
            return self.countyMarr.count;
            break;
        case 4:
            return self.streetMarr.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:addressCell];
    }
    switch (_nowSelectType) {
        case 1:
            cell.textLabel.text = self.provinceMarr[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.cityMarr[indexPath.row];
            break;
        case 3:
            cell.textLabel.text = self.countyMarr[indexPath.row];
            break;
        case 4:
            cell.textLabel.text = self.streetMarr[indexPath.row];
            break;
            
        default:
            break;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#222222"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (_nowSelectType) {
        case 1:
            [self thn_networkGetCityData:indexPath.row];
            break;
        case 2:
            [self thn_networkGetCountyData:indexPath.row];
            break;
        case 3:
            [self thn_networkGetStreetData:indexPath.row];
            break;
        case 4:
            [self thn_networkGetAddressIdDone:indexPath.row];
            break;
            
        default:
            break;
    }
}

#pragma mark - NSMutableMarrInit
- (NSMutableArray *)provinceMarr {
    if (!_provinceMarr) {
        _provinceMarr = [NSMutableArray array];
    }
    return _provinceMarr;
}

- (NSMutableArray *)provinceIdMarr {
    if (!_provinceIdMarr) {
        _provinceIdMarr = [NSMutableArray array];
    }
    return _provinceIdMarr;
}

- (NSMutableArray *)cityMarr {
    if (!_cityMarr) {
        _cityMarr = [NSMutableArray array];
    }
    return _cityMarr;
}

- (NSMutableArray *)cityIdMarr {
    if (!_cityIdMarr) {
        _cityIdMarr = [NSMutableArray array];
    }
    return _cityIdMarr;
}

- (NSMutableArray *)countyMarr {
    if (!_countyMarr) {
        _countyMarr = [NSMutableArray array];
    }
    return _countyMarr;
}

- (NSMutableArray *)countyIdMarr {
    if (!_countyIdMarr) {
        _countyIdMarr = [NSMutableArray array];
    }
    return _countyIdMarr;
}

- (NSMutableArray *)streetMarr {
    if (!_streetMarr) {
        _streetMarr = [NSMutableArray array];
    }
    return _streetMarr;
}

- (NSMutableArray *)streetIdMarr {
    if (!_streetIdMarr) {
        _streetIdMarr = [NSMutableArray array];
    }
    return _streetIdMarr;
}

- (NSMutableArray *)addressIdMarr {
    if (!_addressIdMarr) {
        _addressIdMarr = [NSMutableArray array];
    }
    return _addressIdMarr;
}

- (NSMutableArray *)addressNameMarr {
    if (!_addressNameMarr) {
        _addressNameMarr = [NSMutableArray array];
    }
    return _addressNameMarr;
}

#pragma mark - 触摸消失
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.promptView]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
