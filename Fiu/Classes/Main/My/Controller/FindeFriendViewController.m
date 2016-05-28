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

@interface FindeFriendViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource,FBRequestDelegate>
{
    NSMutableArray *_userAry;
    NSMutableArray *_scenceAry;
}
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
    self.navViewTitle.text = @"发现好友";
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
    FBRequest *request = [FBAPI postWithUrlString:@"/user/find_user" requestDictionary:@{@"page":@1,@"size":@5,@"type":@1,@"sight_count":@5,@"sort":@0} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"发现好友******** result %@",result);
        NSDictionary *dataDict = [result objectForKey:@"data"];
        NSArray *rowsAry = [dataDict objectForKey:@"users"];
        for (NSDictionary *rowsDict in rowsAry) {
            FindFriendModel *model = [[FindFriendModel alloc] init];
            model.userid = [rowsDict objectForKey:@"_id"];
            model.avatarUrl = rowsDict[@"medium_avatar_url"];
            model.nickName = rowsDict[@"nickname"];
            model.address = rowsDict[@"areas"];
            model.isLove = rowsDict[@"is_love"];
            
            if(![rowsDict[@"label"] isKindOfClass:[NSNull class]]){
                model.label = rowsDict[@"label"];
            }
            model.expert_label = rowsDict[@"expert_label"];
            model.rank_id = rowsDict[@"rank_id"];
            model.is_expert = rowsDict[@"identify"][@"is_expert"];
            NSArray *sceneAry = rowsDict[@"scene_sight"];
            //model.scene = [NSMutableArray array];
            for (NSDictionary *sceneDict in sceneAry) {
                
                FindSceneModel *model1 = [[FindSceneModel alloc] init];
                model1.id = sceneDict[@"_id"];
                model1.title = sceneDict[@"title"];
                NSLog(@"标题   %@",model1.title);
                model1.address = sceneDict[@"address"];
                model1.cober = sceneDict[@"cover_url"];
                [model.scene addObject:model1];
            }
            FindSceneModel *model1 = model.scene[1];
            NSLog(@"嘿嘿  %@",model1.title);
            [_userAry addObject:model];
        }
        NSLog(@"_userAry  %@",_userAry);
        NSLog(@"_scenceAry  %@",_scenceAry);
        [self.myTbaleView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
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
        return _userAry.count;
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
        FindFriendModel *model = _userAry[indexPath.row];
        cell.focusBtn.tag = indexPath.row;
        if ([model.isLove isEqualToNumber:@0]) {
            cell.focusBtn.selected = NO;
        }else if ([model.isLove isEqualToNumber:@1]){
            cell.focusBtn.selected = YES;
        }
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
        cell.nameLbael.text = model.nickName;
        
        NSArray *tagsAry = [NSArray arrayWithObjects:@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer", nil];
        if ([model.is_expert isEqual:@(1)]) {
            cell.userLevelLabel.text = [NSString stringWithFormat:@" | Lv%d",[model.rank_id intValue]];
            cell.userLevelLabel.hidden = NO;
            cell.idTagsImageView.hidden = NO;
            int n = (int)[tagsAry indexOfObject:model.expert_label];
            cell.idTagsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"tags%d",n+1]];
        }else{
            if (model.label.length == 0) {
                cell.levelLabel.text = [NSString stringWithFormat:@" Lv%d",[model.rank_id intValue]];
            }else{
                cell.levelLabel.text = [NSString stringWithFormat:@"%@ | Lv%d",model.label,[model.rank_id intValue]];
            }
            cell.userLevelLabel.hidden = NO;
            cell.idTagsImageView.hidden = YES;
//            cell.userLevelLabel.hidden = NO;
        }
//        if (model.address.firstObject && model.address.lastObject) {
//            cell.deressLabel.text = [NSString stringWithFormat:@"%@ %@",model.address.firstObject,model.address.lastObject];
//        }
        cell.sceneAry = model.scene;
        [cell.focusBtn addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return nil;
}

-(void)clickFocusBtn:(UIButton*)sender{
     FindFriendModel *model = _userAry[sender.tag];
    if (sender.selected) {
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        
        [sheetVC.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
        sheetVC.sheetLabel.text = [NSString stringWithFormat:@"停止关注 %@",model.nickName];
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
                [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            }else{
                [SVProgressHUD showErrorWithStatus:@"关注失败"];
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
            [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
            model.isLove = @0;
            
            [self.myTbaleView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:sender.tag inSection:1], nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)clickCancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
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
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"我喜欢用图片梳理情绪，个性滤镜搭配细腻文字、还能一站购齐好设计！Fiu有一百种方式让你创新生活体验，快来让分享变成生产力。http://m.taihuoniao.com/guide/fiu" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
            
        }else if (indexPath.row == 1){
            //weibo
            MyQrCodeViewController *vc = [[MyQrCodeViewController alloc] init];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"我喜欢用图片梳理情绪，个性滤镜搭配细腻文字、还能一站购齐好设计！Fiu有一百种方式让你创新生活体验，快来让分享变成生产力。http://m.taihuoniao.com/guide/fiu"] image:vc.qrCodeView.qrCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
        }else if (indexPath.row == 2){
            //通讯录
//            LBAddressBookViewController *vc = [[LBAddressBookViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:@"我喜欢用图片梳理情绪，个性滤镜搭配细腻文字、还能一站购齐好设计！Fiu有一百种方式让你创新生活体验，快来让分享变成生产力。http://m.taihuoniao.com/guide/fiu" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
                }
            }];
        }
    }
    if (indexPath.section == 1) {
        FindFriendModel *model = _userAry[indexPath.row];
        HomePageViewController *vc = [[HomePageViewController alloc] init];
        vc.type = @1;
        vc.isMySelf = NO;
        vc.userId = [NSString stringWithFormat:@"%@",model.userid];
        [self.navigationController pushViewController:vc animated:YES];
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
