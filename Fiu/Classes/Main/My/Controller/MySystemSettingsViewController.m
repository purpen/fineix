//
//  MySystemSettingsViewController.m
//  fineix
//
//  Created by THN-Dong on 16/3/17.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MySystemSettingsViewController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ShareView.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"

@interface MySystemSettingsViewController ()<NotificationDelege,FBRequestDelegate>
{
    ShareView *_shareView;
}
@property (weak, nonatomic) IBOutlet UILabel *pushNotificationL;
@end
static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";
static NSString *const logOut = @"/auth/logout";
@implementation MySystemSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //更改通知状态的代理
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.notiDelegate = self;
    //第一次进入界面时判断推送状态
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushNotificationL.text = @"已关闭";
    }else{
        self.pushNotificationL.text = @"已开启";
    }
    
    
}

//将要进入界面时隐藏tabbar
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

//将要退出界面时显示tabbar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//返回按钮
- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//给每一个按钮连接事件
- (IBAction)actionBtn:(UIButton *)sender {
    //通过tag值来进行相应方法
    switch (sender.tag) {
        case 1:
            //推送设置
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString ]];
            break;
        case 2:
        {//清空缓存
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
                        //获取文件里存储的文件大小
                        NSString *cacheStr = [NSString stringWithFormat:@"%.1fM",[self folderSizeAtPath:cachesPath]];
                        //提示清空，改变显示的内存大小
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"清理缓存成功 %@",cacheStr]];
                        
                    }
                }
            }}
            break;
        case 3:
            //去评价
        {
            //Appstore里的连接
            NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8&id=1089442815";
            //跳转过去
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
            break;
        case 4:
            //欢迎页
            break;
        case 5:
            //意见反馈
            //跳转到意见反馈的界面
            break;
        case 6:
            //关于太火鸟
            //跳转到相应的页面
            break;
        case 7:
            //分享给好友
        {
            //出现分享view
            _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, +200, SCREEN_WIDTH, SCREEN_HEIGHT+200)];
            
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.navigationBarHidden = YES;
                CGRect frame = _shareView.frame;
                frame.origin.y -= 200;
                _shareView.frame = frame;
                [self.view addSubview:_shareView];
                
            }];
            
            //给每一个分享按钮添加点击事件
            [_shareView.wechat addTarget:self action:@selector(wechatShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_shareView.wechatTimeline addTarget:self action:@selector(timelineShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_shareView.qq addTarget:self action:@selector(qqShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_shareView.sina addTarget:self action:@selector(sinaShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
            [_shareView.cancel addTarget:self action:@selector(cancleBtnAction) forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)wechatShareBtnAction{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = ShareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"太火鸟商城App" image:[UIImage imageNamed:@""] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)timelineShareBtnAction{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = ShareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"太火鸟商城App" image:[UIImage imageNamed:@"icon_80"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)qqShareBtnAction{
    [UMSocialData defaultData].extConfig.qqData.url = ShareURL;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"太火鸟商城App" image:[UIImage imageNamed:@"icon_80"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)sinaShareBtnAction{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"最火爆的智能硬件电商平台——太火鸟商城App%@", ShareURL] image:[UIImage imageNamed:@"icon_120"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)cancleBtnAction{
    [_shareView removeFromSuperview];
    self.navigationController.navigationBarHidden = NO;
}

//获取文件里存储的文件大小
//遍历文件夹获得文件夹大小，返回多少兆
-(float)folderSizeAtPath:(NSString*) folderPath{
    NSFileManager *manager = [NSFileManager defaultManager];
    //本来就是空的返回0
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    //如果不是空的
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileNmae;
    long long folderSize = 0;
    //遍历文件夹里的文件
    while ((fileNmae = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileNmae];
        //得到一个文件夹的大小并相加
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //返回文件夹大小
    return folderSize/(1024/.0 * 1024.0);
}


//得到一个文件夹的大小
-(long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



//推送设置提示开启关闭label
#pragma mark - NotificationDelege
- (void)resetNotificationState
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types == UIUserNotificationTypeNone) {
        self.pushNotificationL.text = @"已关闭";
    } else {
        self.pushNotificationL.text = @"已开启";
    }
}

//退出登录
- (IBAction)logOutBtn:(UIButton *)sender {
    //如果已经登录了开始发送网络请求
    //UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    //if (entity.isLogin == YES) {
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
        
        [self.tabBarController setSelectedIndex:0];
    }
    
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
