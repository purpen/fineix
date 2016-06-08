//
//  HistoryBonusViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "HistoryBonusViewController.h"
#import "SVProgressHUD.h"
#import "BonusModel.h"
#import "InvalidBonusCell.h"

#define HeaderFooterHeight 50

@interface HistoryBonusViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView * _footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *bonusTableView;
@property (nonatomic,strong) NSMutableArray *bonusAry;
@end

static NSString *const BonusURL = @"/my/bonus";
static NSString *const InvalidBonusCellIdentifier = @"invalidBonusCell";

@implementation HistoryBonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navViewTitle.text = @"过期红包";
    self.bonusTableView.rowHeight = 122;
    
    self.bonusTableView.delegate = self;
    self.bonusTableView.dataSource = self;
    
    //表尾视图
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderFooterHeight)];
    _footerView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
    UILabel * noMoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 55, 0, 110, HeaderFooterHeight)];
    noMoreLbl.text = @"暂无过期红包";
    noMoreLbl.textAlignment = NSTextAlignmentCenter;
    noMoreLbl.textColor = [UIColor colorWithHexString:@"#888888"];
    noMoreLbl.font = [UIFont systemFontOfSize:13];
    [_footerView addSubview:noMoreLbl];
    
    self.bonusTableView.tableFooterView = _footerView;
 
    [self.bonusTableView registerNib:[UINib nibWithNibName:@"InvalidBonusCell" bundle:nil] forCellReuseIdentifier:InvalidBonusCellIdentifier];
    
    [self requestDataForBonus];
}

#pragma mark - Network
//请求过期红包信息
- (void)requestDataForBonus
{
    NSDictionary * params = @{@"used": @0, @"is_expired": @2, @"page": @1, @"size": @100, @"sort": @0};
    FBRequest * request = [FBAPI postWithUrlString:BonusURL requestDictionary:params delegate:self];
    request.flag = BonusURL;
    [request startRequest];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

#pragma mark - FBRequest Delegate
- (void)requestSucess:(FBRequest *)request result:(id)result
{
    NSString * message = result[@"message"];
    if ([request.flag isEqualToString:BonusURL]) {
        if ([[result objectForKey:@"success"] isEqualToNumber:@1]) {
            
            self.bonusAry = [NSMutableArray array];
            NSDictionary * dataDic = [result objectForKey:@"data"];
            NSArray * rowsAry = [dataDic objectForKey:@"rows"];
            
            for (NSDictionary * bonusDic in rowsAry) {
                BonusModel * bonus = [[BonusModel alloc] initWithDictionary:bonusDic];
                [self.bonusAry addObject:bonus];
            }
            _footerView.hidden = self.bonusAry.count != 0;
            [self.bonusTableView reloadData];
            
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showInfoWithStatus:message];
        }
    }
    request = nil;
}


- (void)requestFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (void)userCanceledFailed:(FBRequest *)request error:(NSError *)error
{
    [SVProgressHUD dismiss];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.bonusAry.count) {
        return self.bonusAry.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvalidBonusCell * bonusCell = [tableView dequeueReusableCellWithIdentifier:InvalidBonusCellIdentifier forIndexPath:indexPath];
    if (self.bonusAry.count != 0) {
        bonusCell.bonus = self.bonusAry[indexPath.row];
    }
    return bonusCell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return false;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
