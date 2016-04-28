//
//  FindeFriendViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FindeFriendViewController.h"
#import "FindeFriendTableViewCell.h"
#import "FriendTableViewCell.h"
#import "InvitationModel.h"
#import "QRCodeScanViewController.h"
#import "UMSocial.h"
#import "SVProgressHUD.h"
#import "LBAddressBookViewController.h"

@interface FindeFriendViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>

@end

static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";

@implementation FindeFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.

    
    
    //设置导航
    self.navViewTitle.text = @"发现好友";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    self.delegate = self;
    [self addBarItemRightBarButton:nil image:@"scanning" isTransparent:NO];
    [self.view addSubview:self.myTbaleView];
}

-(UITableView *)myTbaleView{
    if (!_myTbaleView) {
        _myTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _myTbaleView.delegate = self;
        _myTbaleView.dataSource = self;
        _myTbaleView.showsVerticalScrollIndicator = NO;
    }
    return _myTbaleView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 3;
    }
}

-(NSArray *)aryOne{
    if (!_aryOne) {
        InvitationModel *modelOne = [[InvitationModel alloc] initWithHeadStr:@"icon_wechat" :@"邀请微信好友" :@"分享给好友"];
        InvitationModel *modelTwo = [[InvitationModel alloc] initWithHeadStr:@"icon_weibo" :@"连接微博" :@"分享给好友"];
        InvitationModel *modelThree = [[InvitationModel alloc] initWithHeadStr:@"Circle + User" :@"连接通讯录" :@"关注你认识的好友"];
        _aryOne = [NSArray arrayWithObjects:modelOne,modelTwo,modelThree, nil];
    }
    return _aryOne;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *id = @"cellOne";
        FindeFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
        if (cell == nil) {
            cell = [[FindeFriendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
        }
        InvitationModel *model = self.aryOne[indexPath.row];
        [cell setUIWithModel:model];
        return cell;
    }else{
        static NSString *cellId = @"cellTwo";
        FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[FriendTableViewCell alloc] init];
        }
        
        [cell setUI];
        return cell;
    }
    return nil;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60/667.0*SCREEN_HEIGHT;
    }else{
        return 542*0.5/667.0*SCREEN_HEIGHT;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
    return 0.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //微信
            [UMSocialData defaultData].extConfig.wechatSessionData.url = ShareURL;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"太火鸟情景App" image:[UIImage imageNamed:@""] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
        }else if (indexPath.row == 1){
            //weibo
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"最火爆的智能硬件电商平台——太火鸟情景App%@", ShareURL] image:[UIImage imageNamed:@"icon_120"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
        }else if (indexPath.row == 2){
            //通讯录
            LBAddressBookViewController *vc = [[LBAddressBookViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    NSLog(@"扫一扫");
    QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

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
