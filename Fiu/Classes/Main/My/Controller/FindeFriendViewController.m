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
#import "FBAPI.h"
#import "FBRequest.h"
#import "FindFriendModel.h"
#import "FindSceneModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyFansActionSheetViewController.h"
#import "HomePageViewController.h"
#import "MyQrCodeViewController.h"
#import "MyQrCodeView.h"
#import "UMSocial.h"
#import "SearchView.h"
#import "SearchTF.h"
#import "UIView+FSExtension.h"
#import "SearchPepoleTableViewCell.h"

static NSString *const ShareURlText = @"我在Fiu浮游™寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！来吧，去Fiu一下 >>> http://m.taihuoniao.com/fiu";

@interface FindeFriendViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate,UITextFieldDelegate>
{
    NSMutableArray *_userAry;
    NSMutableArray *_scenceAry;
}

/**  */
@property (nonatomic, strong) UIWindow *window;
/**  */
@property (nonatomic, strong) SearchView *searchView;

/**  */
@property (nonatomic, strong) UITableView *searchTableView;

@end

static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";

@implementation FindeFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userAry = [NSMutableArray array];
    _scenceAry = [NSMutableArray array];
    //self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view.

    
    
    //设置导航
    self.navViewTitle.text = NSLocalizedString(@"findFriend", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    self.delegate = self;
    [self addBarItemRightBarButton:nil image:@"scanning" isTransparent:NO];
    [self.view addSubview:self.myTbaleView];
    //网络请求
    [self netGetData];
}

-(void)netGetData{
    [SVProgressHUD show];
    FBRequest *request = [FBAPI postWithUrlString:@"/user/find_user" requestDictionary:@{@"page":@1,@"size":@15,@"type":@1,@"sight_count":@5,@"sort":@0} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        
        
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"users"];
        for (NSDictionary *rowsDict in rowsAry) {
            FindFriendModel *model = [[FindFriendModel alloc] init];
            model.userid = [rowsDict objectForKey:@"_id"];
            model.avatarUrl = rowsDict[@"medium_avatar_url"];
            model.nickName = rowsDict[@"nickname"];
            model.address = rowsDict[@"areas"];
            model.isLove = rowsDict[@"is_love"];
            model.summary = rowsDict[@"summary"];
            
            if(![rowsDict[@"label"] isKindOfClass:[NSNull class]]){
                model.label = rowsDict[@"label"];
            }
            model.expert_label = rowsDict[@"expert_label"];
            model.expert_info = rowsDict[@"expert_info"];
            model.rank_id = rowsDict[@"rank_id"];
            model.is_expert = rowsDict[@"identify"][@"is_expert"];
            NSArray *sceneAry = rowsDict[@"scene_sight"];
            //model.scene = [NSMutableArray array];
            for (NSDictionary *sceneDict in sceneAry) {
                FindSceneModel *model1 = [[FindSceneModel alloc] init];
                model1.id = sceneDict[@"_id"];
                model1.title = sceneDict[@"title"];
                model1.address = sceneDict[@"address"];
                model1.cober = sceneDict[@"cover_url"];
                [model.scene addObject:model1];
            }
            [_userAry addObject:model];
        }
        [self.myTbaleView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"request failed", nil)];
    }];
}

-(UITableView *)myTbaleView{
    if (!_myTbaleView) {
        _myTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        
        SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        searchView.searchTF.delegate = self;
        [searchView.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        searchView.cancelBtn.hidden = YES;
        self.searchView = searchView;
        
        
        _myTbaleView.tableHeaderView = searchView;
        
        
        _myTbaleView.delegate = self;
        _myTbaleView.dataSource = self;
        _myTbaleView.showsVerticalScrollIndicator = NO;
        _myTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTbaleView;
}

-(void)cancelBtn:(UIButton*)sender{
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view endEditing:YES];
        self.searchView.searchTF.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 40, 35);
        self.searchView.searchTF.searchIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40 -16, 9.5, 16, 16);
        self.window = nil;
        _myTbaleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        CGRect frame = self.searchView.searchTF.frame;
        frame.size.width = SCREEN_WIDTH - 15 * 2;
        self.searchView.searchTF.frame = frame;
        self.searchView.cancelBtn.hidden = YES;
        self.navView.y = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = window.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchTableView = tableView;
    self.searchTableView.delegate = self;
    self.searchTableView.tag = 10;
    [UIView animateWithDuration:0.25 animations:^{
        self.navView.y = -64;
        _myTbaleView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        
        CGRect frame = self.searchView.searchTF.frame;
        frame.size.width = SCREEN_WIDTH - 15 - 15 - 10 - 35;
        self.searchView.searchTF.frame = frame;
        
        self.searchView.cancelBtn.hidden = NO;
        
        window.hidden = NO;
        self.window = window;
        
        [self.window addSubview:self.searchTableView];
        
    } completion:^(BOOL finished) {
        
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    BOOL flag = [textField resignFirstResponder];
    self.searchView.searchTF.view.frame = CGRectMake(0, 0, 15 + 16, 35);
    self.searchView.searchTF.searchIcon.frame = CGRectMake(15, 9.5, 16, 16);
    return flag;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10) {
        return 1;
    }else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return 10;
    }else{
        if (section == 0) {
            return 3;
        }else{
            return _userAry.count;
        }
    }
}

-(NSArray *)aryOne{
    if (!_aryOne) {
        InvitationModel *modelOne = [[InvitationModel alloc] initWithHeadStr:@"icon_wechat" :NSLocalizedString(@"Invite WeChat friends", nil) :NSLocalizedString(@"Share with friends", nil)];
        InvitationModel *modelTwo = [[InvitationModel alloc] initWithHeadStr:@"icon_weibo" :NSLocalizedString(@"Connect the weibo", nil) :NSLocalizedString(@"Share with friends", nil)];
        InvitationModel *modelThree = [[InvitationModel alloc] initWithHeadStr:@"Circle + User" :NSLocalizedString(@"Connect the address book", nil) :NSLocalizedString(@"Focus on what you know", nil)];
        _aryOne = [NSArray arrayWithObjects:modelOne,modelTwo,modelThree, nil];
    }
    return _aryOne;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        static NSString *cellId = @"search";
        SearchPepoleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[SearchPepoleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        return cell;
    }else{
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
            FindFriendModel *model = _userAry[indexPath.row];
            cell.focusBtn.tag = indexPath.row;
            if ([model.isLove isEqualToNumber:@0]) {
                cell.focusBtn.selected = NO;
            }else if ([model.isLove isEqualToNumber:@1]){
                cell.focusBtn.selected = YES;
            }
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]placeholderImage:[UIImage imageNamed:@"default_head"]];
            cell.nameLbael.text = model.nickName;
            
            //        NSArray *tagsAry = [NSArray arrayWithObjects:@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer", nil];
            if ([model.is_expert isEqual:@(1)]) {
                cell.levelLabel.text = [NSString stringWithFormat:@"%@ | %@",model.expert_label,model.expert_info];
                cell.userLevelLabel.hidden = YES;
                //            cell.idTagsImageView.hidden = NO;
                //            int n = (int)[tagsAry indexOfObject:model.expert_label];
                //            cell.idTagsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tags%d",n+1]];
            }else{
                if (model.label.length == 0) {
                    if (model.summary.length == 0) {
                        
                    }else{
                        cell.levelLabel.text = [NSString stringWithFormat:@"%@",model.summary];
                    }
                }else{
                    if (model.summary.length == 0) {
                        cell.levelLabel.text = [NSString stringWithFormat:@"%@",model.label];
                    }else{
                        cell.levelLabel.text = [NSString stringWithFormat:@"%@ | %@",model.label,model.summary];
                    }
                }
            }
            //        if (model.address.firstObject && model.address.lastObject) {
            //            cell.deressLabel.text = [NSString stringWithFormat:@"%@ %@",model.address.firstObject,model.address.lastObject];
            //        }
            cell.sceneAry = model.scene;
            [cell.focusBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    return nil;
}

-(void)clickFocusBtn:(UIButton*)sender{
     FindFriendModel *model = _userAry[sender.tag];
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        
        [sheetVC.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
        sheetVC.sheetLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Stop caring about", nil),model.nickName];
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userid} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                model.isLove = @1;
                [self.myTbaleView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Focus on success", nil)];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Pay attention to fail", nil)];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    FindFriendModel *model = _userAry[sender.tag];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userid} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result objectForKey:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Remove focus on success", nil)];
            model.isLove = @0;
            
            [self.myTbaleView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The operation failure", nil)];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        return 44;
    }else{
        if (indexPath.section == 0) {
            return 60/667.0*SCREEN_HEIGHT;
        }else{
            return 542*0.5/667.0*SCREEN_HEIGHT;
        }
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
    UMSocialConfig *h = [[UMSocialConfig alloc] init];
    h.hiddenStatusTip = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //微信
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:ShareURlText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                }
            }];
            
        }else if (indexPath.row == 1){
            //weibo
            MyQrCodeViewController *vc = [[MyQrCodeViewController alloc] init];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:ShareURlText image:vc.qrCodeView.qrCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                }
            }];
        }else if (indexPath.row == 2){
            //通讯录
//            LBAddressBookViewController *vc = [[LBAddressBookViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:ShareURlText image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                }
            }];
        }
    }
    if (indexPath.section == 1) {
        FindFriendModel *model = _userAry[indexPath.row];
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.type = @2;
        vc.isMySelf = NO;
        vc.userId = [NSString stringWithFormat:@"%@",model.userid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
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
