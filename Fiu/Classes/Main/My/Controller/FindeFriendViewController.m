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
#import "SearchView.h"
#import "SearchTF.h"
#import "UIView+FSExtension.h"
#import "SearchPepoleTableViewCell.h"
#import "THNMacro.h"
#import <UMSocialCore/UMSocialCore.h>
#import "THNUserData.h"

static NSString *const ShareURlText = @"我在D3IN寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！>>> http://m.taihuoniao.com/fiu";

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
/**  */
@property (nonatomic, strong) NSArray *findUserAry;
/**  */
@property (nonatomic, strong) UIView *topView;

@end

static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";
static NSString *searchCellId = @"search";

@implementation FindeFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userAry = [NSMutableArray array];
    _scenceAry = [NSMutableArray array];
    
    
    //设置导航
    self.navViewTitle.text = NSLocalizedString(@"findFriend", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    self.delegate = self;
    [self addBarItemRightBarButton:nil image:@"scanning" isTransparent:NO];
    [self.view addSubview:self.myTbaleView];
    //网络请求
    [self netGetData];
    
    [self.view addSubview:self.topView];
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _topView.backgroundColor = [UIColor blackColor];
    }
    return _topView;
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
        if (Is_iPhoneX) {
            _myTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStyleGrouped];
        }else {
            _myTbaleView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        }
        
        SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        searchView.searchTF.delegate = self;
        [searchView.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        searchView.cancelBtn.hidden = YES;
        self.searchView = searchView;
        
        
        _myTbaleView.tableHeaderView = searchView;
        
        
        _myTbaleView.delegate = self;
        _myTbaleView.dataSource = self;
        _myTbaleView.showsVerticalScrollIndicator = NO;
        _myTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTbaleView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    }
    return _myTbaleView;
}

-(void)cancelBtn:(UIButton*)sender{
    self.findUserAry = nil;
    self.searchView.searchTF.text = nil;
    [self.searchTableView reloadData];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.searchView.backgroundColor = [UIColor whiteColor];
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view endEditing:YES];
        self.searchView.searchTF.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 40, 35);
        self.searchView.searchTF.searchIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40 -16, 9.5, 16, 16);
        self.window = nil;
        if (Is_iPhoneX) {
            _myTbaleView.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88);
        }else {
            _myTbaleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        }
        CGRect frame = self.searchView.searchTF.frame;
        frame.size.width = SCREEN_WIDTH - 15 * 2;
        frame.size.height = 35;
        self.searchView.searchTF.frame = frame;
        self.searchView.cancelBtn.hidden = YES;
        self.searchView.searchTF.backgroundColor = [UIColor whiteColor];
        self.navView.y = 0;
    } completion:^(BOOL finished) {
        
    }];
    
}


-(UITableView *)searchTableView{
    if (!_searchTableView) {
        if (Is_iPhoneX) {
            _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, SCREEN_WIDTH, SCREEN_HEIGHT-88) style:UITableViewStylePlain];
        }else{
            _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        }
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.tag = 10;
        [_searchTableView registerNib:[UINib nibWithNibName:@"SearchPepoleTableViewCell" bundle:nil] forCellReuseIdentifier:searchCellId];
        _searchTableView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSearchTableview)];
//        [_searchTableView addGestureRecognizer:tap];
    }
    return _searchTableView;
}

-(void)tapSearchTableview{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.searchView.backgroundColor = [UIColor blackColor];
    UIWindow *window;
    if (Is_iPhoneX) {
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88)];
    } else {
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    [UIView animateWithDuration:0.25 animations:^{
        
        if (Is_iPhoneX) {
            self.navView.y = -88;
        } else {
            self.navView.y = -64;
        }
        _myTbaleView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        
        CGRect frame = self.searchView.searchTF.frame;
        frame.size.width = SCREEN_WIDTH - 15 - 15 - 10 - 35;
        frame.size.height = 30;
        self.searchView.searchTF.frame = frame;
        self.searchView.searchTF.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        
        self.searchView.cancelBtn.hidden = NO;
        self.searchView.cancelBtn.centerY = self.searchView.searchTF.centerY;
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
    
    
    if (textField.text.length) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        FBRequest *request = [FBAPI postWithUrlString:@"/search/getlist" requestDictionary:@{
                                                                                             @"q" : textField.text,
                                                                                             @"t" : @14
                                                                                             } delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            [SVProgressHUD dismiss];
            NSLog(@"用户  %@",result);
            NSArray *rows = result[@"data"][@"rows"];
            self.findUserAry = [THNUserData mj_objectArrayWithKeyValuesArray:rows];
            [self.searchTableView reloadData];
        } failure:^(FBRequest *request, NSError *error) {
            [SVProgressHUD dismiss];
        }];

    }
    
    return flag;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 10) {
        return 1;
    }else{
        return _userAry.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 10) {
        return self.findUserAry.count;
    }else{
        if (section == 0) {
            return 3;
        }else{
            return 1;
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
        
        SearchPepoleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellId];
        cell.model = self.findUserAry[indexPath.row];
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
            if (indexPath.row == 2) {
                cell.lineView.hidden = YES;
            }
            return cell;
        }else{
            static NSString *cellId = @"cellTwo";
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[FriendTableViewCell alloc] init];
            }
            cell.navi = self.navigationController;
            FindFriendModel *model = _userAry[indexPath.section];
            cell.follow.tag = indexPath.section;
            if ([model.isLove isEqualToNumber:@0]) {
                cell.follow.selected = NO;
                cell.follow.layer.borderColor = [UIColor whiteColor].CGColor;
                cell.follow.backgroundColor = [UIColor blackColor];
            }else if ([model.isLove isEqualToNumber:@1]){
                cell.follow.selected = YES;
                cell.follow.layer.borderColor = [UIColor clearColor].CGColor;
                cell.follow.backgroundColor = [UIColor colorWithHexString:@"#BE8914"];
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
            [cell.follow addTarget:self action:@selector(clickFocusBtn:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    return nil;
}

-(void)clickFocusBtn:(UIButton*)sender{
     FindFriendModel *model = _userAry[sender.tag];
    if (sender.selected) {
        
        MyFansActionSheetViewController *sheetVC = [[MyFansActionSheetViewController alloc] init];
        sheetVC.findFriendModel = model;
        sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        sheetVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:sheetVC animated:YES completion:nil];
        sheetVC.stopBtn.tag = sender.tag;
        [sheetVC.stopBtn addTarget:self action:@selector(clickStopBtn:) forControlEvents:UIControlEventTouchUpInside];
        [sheetVC.cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        }else{
        
        //请求数据
        FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_follow" requestDictionary:@{@"follow_id":model.userid} delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if ([result objectForKey:@"success"]) {
                model.isLove = @1;
                
                [self.myTbaleView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:sender.tag], nil] withRowAnimation:UITableViewRowAnimationNone];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Focus on success", nil)];
            }else{
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Pay attention to fail", nil)];
            }
        } failure:^(FBRequest *request, NSError *error) {
            
        }];
    }
}

-(void)clickCancelBtn{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)clickStopBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    FindFriendModel *model = _userAry[sender.tag];
    FBRequest *request = [FBAPI postWithUrlString:@"/follow/ajax_cancel_follow" requestDictionary:@{@"follow_id":model.userid} delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if ([result objectForKey:@"success"]) {
            model.isLove = @0;
            
            [self.myTbaleView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:sender.tag], nil] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"The operation failure", nil)];
        }
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10) {
        return 60;
    }else{
        if (indexPath.section == 0) {
            return 60/667.0*SCREEN_HEIGHT;
        }else{
            return SCREEN_WIDTH / 3.0 + 55;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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
    
    if (tableView.tag == 10) {
        THNUserData *model = self.findUserAry[indexPath.row];
        NSString *id = model._id;
        self.findUserAry = nil;
        self.searchView.searchTF.text = nil;
        [self.searchTableView reloadData];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        self.searchView.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:0.000001 animations:^{
            
            [self.view endEditing:YES];
            self.searchView.searchTF.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width * 0.5 - 40, 35);
            self.searchView.searchTF.searchIcon.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 40 -16, 9.5, 16, 16);
            self.window.hidden = YES;
            if (Is_iPhoneX) {
                _myTbaleView.frame = CGRectMake(0, 88, SCREEN_WIDTH, SCREEN_HEIGHT-88);
            }else {
                _myTbaleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            }
            CGRect frame = self.searchView.searchTF.frame;
            frame.size.width = SCREEN_WIDTH - 15 * 2;
            self.searchView.searchTF.frame = frame;
            self.searchView.cancelBtn.hidden = YES;
            self.navView.y = 0;
        } completion:^(BOOL finished) {
            HomePageViewController *vc = [[HomePageViewController alloc] init];
            vc.type = @2;
            vc.isMySelf = NO;
            vc.userId = id;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        if (indexPath.section == 0) {
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            messageObject.text = ShareURlText;
            
            if (indexPath.row == 0) {
                //微信
                [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_WechatSession) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                    }
                }];
                
            }else if (indexPath.row == 1){
                //w微博
                [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_Sina) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                    }
                }];
            }else if (indexPath.row == 2){
                //通讯录
                [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType_Sms) messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                    }else{
                        [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                    }
                }];
            }
        }else{
            FindFriendModel *model = _userAry[indexPath.section];
            HomePageViewController *vc = [[HomePageViewController alloc] init];
            vc.type = @2;
            vc.isMySelf = NO;
            vc.userId = [NSString stringWithFormat:@"%@",model.userid];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
