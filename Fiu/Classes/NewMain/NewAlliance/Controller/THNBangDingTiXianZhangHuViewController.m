//
//  THNBangDingTiXianZhangHuViewController.m
//  Fiu
//
//  Created by THN-Dong on 2017/3/7.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNBangDingTiXianZhangHuViewController.h"
#import "Fiu.h"
#import "LSActionSheet.h"
#import "THNZhiFuXinXiViewController.h"
#import "THNZhangHuModel.h"
#import "MJExtension.h"
#import "THNZhangHuTableViewCell.h"

@interface THNBangDingTiXianZhangHuViewController () <THNNavigationBarItemsDelegate, UITableViewDelegate, UITableViewDataSource>

/**  */
@property (nonatomic, strong) UIView *addView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
/**  */
@property (nonatomic, strong) UITableView *tabelView;

@end

@implementation THNBangDingTiXianZhangHuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
    [self.view addSubview:self.tabelView];
    FBRequest *request = [FBAPI postWithUrlString:@"/payment_card/getlist" requestDictionary:@{
                                                                                               @"page" : @"1",
                                                                                               @"size" : @"8",
                                                                                               @"sort" : @"0"
                                                                                               } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dict = result[@"data"];
        NSArray *ary = dict[@"rows"];
        self.modelAry = [THNZhangHuModel mj_objectArrayWithKeyValuesArray:ary];
        [self.tabelView reloadData];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.rowHeight = 60;
        _tabelView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        [_tabelView registerClass:[THNZhangHuTableViewCell class] forCellReuseIdentifier:THNZHANGHuTableViewCell];
    }
    return _tabelView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelAry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    THNZhangHuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:THNZHANGHuTableViewCell];
    THNZhangHuModel *model = self.modelAry[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navViewTitle.text = @"绑定提现账户";
    [self thn_addBarItemRightBarButton:@"管理" image:nil];
    self.delegate = self;
}

-(void)thn_rightBarItemSelected{
    NSLog(@"管理");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.addView];
    [_addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(44);
    }];
}

-(UIView *)addView{
    if (!_addView) {
        _addView = [[UIView alloc] init];
        _addView.backgroundColor = [UIColor whiteColor];
        UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_yellow"]];
        [_addView addSubview:addImageView];
        [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_addView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_addView.mas_left).mas_offset(251/2*SCREEN_HEIGHT/667.0);
        }];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:fineixColor];
        label.text = @"添加提现账户";
        [_addView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_addView.mas_centerY);
            make.left.mas_equalTo(addImageView.mas_right).mas_offset(15);
        }];
        _addView.userInteractionEnabled = YES;
        [_addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addZhangHu)]];
    }
    return _addView;
}

-(void)addZhangHu{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    LSActionSheet *sheet=[[LSActionSheet alloc]init];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    sheet.frame=window.bounds;
    sheet.title=@"选择绑定账户";
    sheet.destructiveTitle=nil;
    sheet.otherTitles=@[@"绑定银行卡号",@"绑定支付宝号"];
    sheet.block=^(int index) {
        switch (index) {
            case 0:
            {
                //银行卡
            }
            
            break;
            case 1:
            {
                //支付宝
                THNZhiFuXinXiViewController *vc = [[THNZhiFuXinXiViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
            
            default:
            break;
        }
    };
    [sheet showTwo];
    [window addSubview:sheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
