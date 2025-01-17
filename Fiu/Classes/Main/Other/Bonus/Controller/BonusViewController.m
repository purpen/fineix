//
//  BonusViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/5/5.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "BonusViewController.h"
#import "Fiu.h"
#import "HistoryBonusViewController.h"
#import "SVProgressHUD.h"
#import "BonusModel.h"
#import "BonusCell.h"

#define HeaderFooterHeight 50

@interface BonusViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_footerView;
}
@property (weak, nonatomic) IBOutlet UITableView *bonusTableView;
@property (nonatomic,strong) NSMutableArray *bonusAry;
@pro_assign BOOL                        rollDown;               //  是否下拉
@pro_assign CGFloat                     lastContentOffset;      //  滚动的方向
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bonusTableViewTopSpace;
@end

static NSString *const BonusURL = @"/my/bonus";
static NSString *const BonusCellIdentifier = @"bonusCell";

@implementation BonusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (SCREEN_HEIGHT == 812) {
        self.bonusTableViewTopSpace.constant = 88;
    } else {
        self.bonusTableViewTopSpace.constant = 64;
    }
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"我的红包";
    self.bonusTableView.delegate = self;
    self.bonusTableView.dataSource = self;
    self.bonusTableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    self.bonusTableView.rowHeight = 122;
    
//    //表头视图
//    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HeaderFooterHeight)];
//    //    UIButton * ruleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    ruleBtn.frame = CGRectMake(View_Width - 100, 0, 100, HeaderFooterHeight);
//    //    [ruleBtn setImage:[UIImage imageNamed:@"rule"] forState:UIControlStateNormal];
//    //    [ruleBtn setTitle:@"使用规则" forState:UIControlStateNormal];
//    //    [ruleBtn setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
//    //    ruleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size: 13];
//    //    [ruleBtn addTarget:self action:@selector(ruleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    //    [headerView addSubview:ruleBtn];
//    self.bonusTableView.tableHeaderView = headerView;
    
    //表尾视图
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-HeaderFooterHeight, SCREEN_WIDTH, HeaderFooterHeight)];
    _footerView.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
    
    UILabel * noMoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 110, 0, 110, HeaderFooterHeight)];
    noMoreLbl.text = @"没有更多可用红包";
    noMoreLbl.textColor = [UIColor colorWithHexString:@"#888888"];
    if (IS_iOS9) {
        noMoreLbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    } else {
        noMoreLbl.font = [UIFont systemFontOfSize:13];
    }
    [_footerView addSubview:noMoreLbl];
    
    UIButton * historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = CGRectMake(SCREEN_WIDTH / 2, 0, 110, HeaderFooterHeight);
    [historyBtn setTitle:@"查看过期红包>>" forState:UIControlStateNormal];
    [historyBtn setTitleColor:[UIColor colorWithHexString:fineixColor] forState:UIControlStateNormal];
    if (IS_iOS9) {
        historyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:13];
    } else {
        historyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    [historyBtn addTarget:self action:@selector(historyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:historyBtn];
//    self.bonusTableView.tableFooterView = footerView;
    [self.view addSubview:_footerView];
    [self.bonusTableView registerNib:[UINib nibWithNibName:@"BonusCell" bundle:nil] forCellReuseIdentifier:BonusCellIdentifier];
    
    [self requestDataForBonus];
}

#pragma mark - 判断上／下滑状态，显示/隐藏Nav/tabBar
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView == self.bonusTableView) {
        _lastContentOffset = scrollView.contentOffset.y;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.bonusTableView) {
        if (_lastContentOffset < scrollView.contentOffset.y) {
            self.rollDown = YES;
        }else{
            self.rollDown = NO;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.bonusTableView) {
        CGRect tabBarRect = _footerView.frame;
        
        if (self.rollDown == YES) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT + 20, SCREEN_WIDTH, HeaderFooterHeight);
            [UIView animateWithDuration:.4 animations:^{
                _footerView.frame = tabBarRect;
            }];
            
        } else if (self.rollDown == NO) {
            tabBarRect = CGRectMake(0, SCREEN_HEIGHT - HeaderFooterHeight, SCREEN_WIDTH, HeaderFooterHeight);
            [UIView animateWithDuration:.4 animations:^{
                _footerView.frame = tabBarRect;
            }];
        }
    }
}


#pragma mark - Network
//请求我的红包信息
- (void)requestDataForBonus
{
    NSDictionary * params = @{@"used": @1, @"is_expired": @1, @"page": @1, @"size": @100, @"sort": @0};
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


- (void)historyBtnAction:(UIButton *)historyBtn
{
    HistoryBonusViewController * historyBonusVC = [[HistoryBonusViewController alloc] initWithNibName:@"HistoryBonusViewController" bundle:nil];
    [self.navigationController pushViewController:historyBonusVC animated:YES];
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
    BonusCell * bonusCell = [tableView dequeueReusableCellWithIdentifier:BonusCellIdentifier forIndexPath:indexPath];
    if (self.bonusAry.count) {
        bonusCell.bonus = self.bonusAry[indexPath.row];
    }
    bonusCell.clickBtn.tag = indexPath.row;
    [bonusCell.clickBtn addTarget:self action:@selector(clikTipBtn:) forControlEvents:UIControlEventTouchUpInside];
    return bonusCell;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return false;
}

-(void)clikTipBtn:(UIButton*)sender{
    if (self.rid) {
        BonusModel *model = self.bonusAry[sender.tag];
        
        FBRequest *request = [FBAPI postWithUrlString:@"/shopping/use_bonus" requestDictionary:@{@"rid":self.rid,@"code":model.code} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                if ([self.bounsDelegate respondsToSelector:@selector(getBounsCode:andBounsNum:)]) {
                    [self.bounsDelegate getBounsCode:model.code andBounsNum:model.amount];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:@"此红包不适用"];
            }
            
        } failure:^(FBRequest *request, NSError *error) {
        }];
    }

}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (self.rid) {
//        BonusModel *model = self.bonusAry[indexPath.row];
//        FBRequest *request = [FBAPI postWithUrlString:@"/shopping/use_bonus" requestDictionary:@{@"rid":self.rid,@"code":model.code} delegate:self];
//        [request startRequestSuccess:^(FBRequest *request, id result) {
//            if ([self.bounsDelegate respondsToSelector:@selector(getBounsCode:andBounsNum:)]) {
//                [self.bounsDelegate getBounsCode:model.code andBounsNum:model.amount];
//            }
//            
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(FBRequest *request, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"此红包不适用"];
//            
//        }];
//    }
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
