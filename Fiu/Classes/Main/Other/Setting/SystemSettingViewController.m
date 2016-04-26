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
#import "ShareView.h"
#import "Fiu.h"
#import "UserInfoEntity.h"
#import "FBRequest.h"
#import "FBAPI.h"
#import "UserInfo.h"
#import "OptionViewController.h"
#import "AboutViewController.h"

@interface SystemSettingViewController ()<FBNavigationBarItemsDelegate,NotificationDelege,FBRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *pushStateLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";
static NSString *const logOut = @"/auth/logout";
@implementation SystemSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"系统设置";
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    self.backBtn.layer.masksToBounds = YES;
    self.backBtn.layer.cornerRadius = 3;
    
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
                //获取文件里存储的文件大小
                NSString *cacheStr = [NSString stringWithFormat:@"%.1fM",[self folderSizeAtPath:cachesPath]];
                //提示清空，改变显示的内存大小
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"清理缓存成功 %@",cacheStr]];
                
            }
        }
    }
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

    
- (IBAction)evaluationBtn:(UIButton *)sender {
    
    //Appstore里的连接
//    NSString *urlStr = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8&id=1089442815";
    NSString *urlStr = @"itms-apps://itunes.apple.com/app/id946737402";
    //跳转过去
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}


- (IBAction)welcomePageBtn:(UIButton *)sender {
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
}


-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)quitBtn:(UIButton *)sender {
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
