//
//  THNYinHangXuanZeViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/10.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNYinHangXuanZeViewController.h"
#import "THNYinHangModel.h"
#import "MJExtension.h"
#import "THNBankTableViewCell.h"

@interface THNYinHangXuanZeViewController () <UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UITableView *tableView;
/**  */
@property (nonatomic, strong) NSArray *dataAry;

@end

@implementation THNYinHangXuanZeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"选择银行";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    FBRequest *request = [FBAPI postWithUrlString:@"/gateway/bank_options" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        self.dataAry = [THNYinHangModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"banks"]];
        [self.tableView reloadData];
    } failure:nil];
}

-(UITableView *)tableView{
    if (!_tableView) {
        if (Is_iPhoneX) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStylePlain];
        }else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44;
        [_tableView registerClass:[THNBankTableViewCell class] forCellReuseIdentifier:THNBANKTableViewCell];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    THNBankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THNBANKTableViewCell];
    THNYinHangModel *model = self.dataAry[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    THNBankTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.bankDelegate respondsToSelector:@selector(setSelectedBank:)]) {
        [self.bankDelegate setSelectedBank:cell.model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
