//
//  SystemSettingViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ShareViewController.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "OptionViewController.h"
#import "AboutViewController.h"
#import "UMSocial.h"
#import "Fiu.h"
#import "ChanePwdViewController.h"
#import "MyQrCodeViewController.h"
#import "MyQrCodeView.h"
#import "GuidePageViewController.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UITabBar+badge.h"
#import "ServiceViewController.h"

static NSString *const ShareURlText = @"我在Fiu浮游™寻找同路人；希望和你一起用文字来记录内心情绪，用滤镜来表达情感色彩，用分享去变现原创价值；带你发现美学科技的力量和感性生活的温度！来吧，去Fiu一下 >>> http://m.taihuoniao.com/fiu";

@interface SystemSettingViewController ()<FBNavigationBarItemsDelegate,NotificationDelege,FBRequestDelegate,UMSocialUIDelegate,ShareViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pushStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UILabel *memoryLabel;
@property (weak, nonatomic) IBOutlet UIView *quitBtn;

@end
static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";
static NSString *const logOut = @"/auth/logout";
@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.quitBtn.layer.masksToBounds = YES;
    self.quitBtn.layer.cornerRadius = 3;
    self.view.backgroundColor = [UIColor colorWithHexString:grayLineColor];
    // Do any additional setup after loading the view from its nib
    //设置导航
    self.navViewTitle.text = @"系统设置";
    self.delegate = self;
    //-----
    //更改通知状态的代理
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.notiDelegate = self;
    //第一次进入界面时判断推送状态
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushStateLabel.text = @"已关闭";
    }else{
        self.pushStateLabel.text = @"已开启";
    }
    //-----
    
    //清空缓存
    NSString * cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    self.memoryLabel.text = [NSString stringWithFormat:@"%.1fM", [self folderSizeAtPath:cachesPath]];
}

- (IBAction)service:(id)sender {
    ServiceViewController *vc = [[ServiceViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (IBAction)pushSetBtn:(UIButton *)sender {
    //推送设置
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString ]];
}
- (IBAction)clearBtn:(UIButton *)sender {
    
    //清空缓存
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files = [manager subpathsAtPath:cachesPath];
    if (files.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"缓存已清空"];
        
        return;
    }
    //如果数组里有内容需要遍历清空
    for (NSString *fileName in files) {
        NSError *error = nil;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:filePath]) {
            [manager removeItemAtPath:filePath error:&error];
            if (error) {
                //本来就是空的
                [SVProgressHUD showInfoWithStatus:@"缓存已清空"];
            }else{
                //提示清空，改变显示的内存大小
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"清理缓存成功"]];
                
            }
        }
    }
    self.memoryLabel.text = @"0.0M";
}


#pragma mark - 计算缓存大小
//遍历文件夹获得文件夹大小，返回多少M
- (float)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0 * 1024.0);
}

//单个文件的大小
- (long long)fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


    
- (IBAction)evaluationBtn:(UIButton *)sender {
    
    //Appstore里的连接
//    NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8&id=1089442815";
    NSString *urlStr = @"itms-apps://itunes.apple.com/app/id1089442815";
    //跳转过去
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}


- (IBAction)welcomePageBtn:(UIButton *)sender {
    NSArray *arr = [NSArray arrayWithObjects:@"Guide_one",@"Guide_two",@"Guide_three",@"Guide_four", nil];
    GuidePageViewController *vc = [[GuidePageViewController alloc] initWithPicArr:arr andRootVC:self];
    vc.flag = welcomePage;
    [self presentViewController:vc animated:YES completion:nil];
}


- (IBAction)optionBtn:(UIButton *)sender {
    OptionViewController *vc = [[OptionViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)aboutBtn:(UIButton *)sender {
    
    AboutViewController *vc = [[AboutViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}


- (IBAction)shareBtn:(UIButton *)sender {
    self.shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_shareVC animated:YES completion:nil];
    self.shareVC.shareDelegate = self;
    self.shareVC.content = ShareURlText;
}

-(void)afterShare{
    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
}

-(void)cancleBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(ShareViewController *)shareVC{
    if (!_shareVC) {
        _shareVC = [[ShareViewController alloc] init];
        [self judgeWith:_shareVC];
    }
    return _shareVC;
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judgeWith:(ShareViewController*)vc{
    if ([WXApi isWXAppInstalled] == NO) {
        vc.wechatBtn.hidden = YES;
    }else{
        vc.wechatBtn.hidden = NO;
    }
    
    if ([WeiboSDK isWeiboAppInstalled] == NO) {
        vc.weiBoBtn.hidden = YES;
    }else{
        vc.weiBoBtn.hidden = NO;
    }
    
    if ([QQApiInterface isQQInstalled] == NO) {
        vc.qqBtn.hidden = YES;
    }else{
        vc.qqBtn.hidden = NO;
    }
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 修改密码
- (IBAction)changePwd:(UIButton *)sender {
    ChanePwdViewController *vc = [[ChanePwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//退出登录
- (IBAction)quitBtn:(UIButton *)sender {
    //如果已经登录了开始发送网络请求
    NSDictionary *params = @{
                             @"from_to":@1
                             };
    FBRequest *request = [FBAPI postWithUrlString:logOut requestDictionary:params delegate:self];
    request.flag = logOut;
    [request startRequest];
}

#pragma mark -fbrequestDElegate
-(void)requestSucess:(FBRequest *)request result:(id)result{
    //退出登录操作
    if ([request.flag isEqualToString:logOut]) {
        //更新用户信息，并且登录状态改变
        UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
        entity.isLogin = NO;
        [entity clear];
        [UserInfo clearTable];
        [SVProgressHUD showSuccessWithStatus:@"登出成功"];
        //回到首页
        //圆点消失
        [self.tabBarController.tabBar hideBadgeWithIndex:4];
        
        [self.tabBarController setSelectedIndex:0];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

-(void)resetNotificationState{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushStateLabel.text = @"已关闭";
    } else {
        self.pushStateLabel.text = @"已开启";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
