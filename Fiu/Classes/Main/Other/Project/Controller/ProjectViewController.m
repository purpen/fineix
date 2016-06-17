//
//  ProjectViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/15.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ProjectViewController.h"
#import "SVProgressHUD.h"
#import "ProjectViewCommentsViewController.h"
#import "ShareViewController.h"
#import "UMSocial.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ProjectModel.h"
#import "FBLoginRegisterViewController.h"
#import "FiuSceneViewController.h"
#import "UIImageView+WebCache.h"

@interface ProjectViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *projectWebView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
@property (weak, nonatomic) IBOutlet UILabel *loveContLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property(nonatomic,strong) ShareViewController *shareVC;
/** 专题的数据模型 */
@property (nonatomic, strong) ProjectModel *model;

@end

static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGetDataFromeNet];
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:NO];
}

/**
 *  从网络获取数据
 */
-(void)requestGetDataFromeNet{
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                            @"id":self.projectId
                                                                                            } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = [result objectForKey:@"data"];
        self.model = [ProjectModel projectWithDict:dataDict];
        self.navViewTitle.text = self.model.title;
        if (self.model.is_love == ProjectLove) {
            self.loveBtn.selected = YES;
        }else if (self.model.is_love == ProjectNotLove){
            self.loveBtn.selected = NO;
        }
        self.loveContLabel.text = [NSString stringWithFormat:@"%@",self.model.love_count];
        self.commentCountLabel.text = [NSString stringWithFormat:@"%@",self.model.comment_count];
        //地址
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.content_view_url]];
        //在网页上加载
        NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
        [self.projectWebView loadRequest:webRequest];
        self.projectWebView.delegate = self;
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIWebViewDelegate
//网页开始加载时出现进度条
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}
//网页加载完成进度条消失
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
//网页加载失败，提示加载失败原因
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
}
#pragma mark - 截取网页点击事件，获取url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSString *str = [url absoluteString];
        NSLog(@"str  %@",str);
        if([str rangeOfString:@"infoType"].location == NSNotFound){
            [SVProgressHUD showErrorWithStatus:@"参数不足"];
        }else if ([str rangeOfString:@"taihuoniao.com"].location != NSNotFound && [str rangeOfString:@"infoType"].location != NSNotFound){
            NSArray *oneAry = [str componentsSeparatedByString:@"?"];
            NSString *infoStr = oneAry[1];
            NSArray *twoAry = [infoStr componentsSeparatedByString:@"&"];
            NSString *infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 2)];
            NSArray *threeAry = [twoAry[1] componentsSeparatedByString:@"="];
            NSString *infoId = threeAry[1];
            if ([infoType isEqualToString:@"10"]) {
                //情景
                FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
                fiuSceneVC.fiuSceneId = infoId;
                [self.navigationController pushViewController:fiuSceneVC animated:YES];
            }else if ([infoType isEqualToString:@"11"]) {
                //场景
                SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
                sceneInfoVC.sceneId = infoId;
                [self.navigationController pushViewController:sceneInfoVC animated:YES];
            }else if ([infoType isEqualToString:@"12"]) {
                //产品
                GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
                goodsInfoVC.goodsID = infoId;
                [self.navigationController pushViewController:goodsInfoVC animated:YES];
            }else if ([infoType isEqualToString:@"13"]) {
                //用户
                HomePageViewController *homeOpage = [[HomePageViewController alloc] init];
                homeOpage.type = @2;
                homeOpage.userId = infoId;
                UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
                if ([entity.userId isEqualToString:infoId]) {
                    homeOpage.isMySelf = YES;
                }else{
                    homeOpage.isMySelf = NO;
                }
                [self.navigationController pushViewController:homeOpage animated:YES];
            }
        }
        return NO;
    }
    return YES;
}

/**
 *  进入专题的评论界面
 *
 *  @param sender 右侧按钮
 */
- (IBAction)clickCommentsBtn:(UIButton *)sender {
    ProjectViewCommentsViewController * commentVC = [[ProjectViewCommentsViewController alloc] init];
    commentVC.targetId = self.projectId;
    commentVC.sceneUserId = self.model.personId;
    [self.navigationController pushViewController:commentVC animated:YES];
}

/**
 *  喜欢这个专题
 *
 *  @param sender 最左侧按钮
 */
- (IBAction)loveBtn:(UIButton *)sender {
    //判断有没有登录
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    FBRequest * request = [FBAPI postWithUrlString:@"/auth/check_login" requestDictionary:nil delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary * dataDic = [result objectForKey:@"data"];
        entity.isLogin = [[dataDic objectForKey:@"is_login"] boolValue];
        request = nil;
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
        request = nil;
    }];
    if (entity.isLogin) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            //如果登录了按钮改变状态，进行网络请求获取数字改变label数值
            [self loveRequset:@"/favorite/ajax_love"];
        }else{
            //如果登录了按钮改变状态，进行网络请求获取数字改变label数值
            [self loveRequset:@"/favorite/ajax_cancel_love"];
        }
    }
    else
    {
        //如果没有登录就提示用户登录
        UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"LoginRegisterController" bundle:[NSBundle mainBundle]];
        FBLoginRegisterViewController *loginSignupVC = [loginStory instantiateViewControllerWithIdentifier:@"FBLoginRegisterViewController"];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginSignupVC];
        [self presentViewController:navi animated:YES completion:nil];
    }
    
}


/**
 *  进行点赞或取消点赞操作的网络请求
 *
 *  @param url 接口地址
 */
-(void)loveRequset:(NSString*)url{
    FBRequest *loveRequest = [FBAPI postWithUrlString:url requestDictionary:@{
                                                                                                 @"id":self.projectId,
                                                                                                 @"type":@"13"
                                                                                                 } delegate:self];
    [loveRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSDictionary *dataDict = result[@"data"];
        NSLog(@"result %@",result);
        ProjectModel *model = [ProjectModel projectWithDict:dataDict];
        self.loveContLabel.text = [NSString stringWithFormat:@"%@",model.love_count];
    } failure:^(FBRequest *request, NSError *error) {
        
    }];
    loveRequest = nil;
}


//--------------------------------------------------------------------------------------------------------------------
/**
 *  进行专题的分享
 *
 *  @param sender 中间的那个按钮
 */
- (IBAction)shareBtn:(UIButton *)sender {
    self.shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_shareVC animated:YES completion:nil];
    //给每一个分享按钮添加点击事件
    [_shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.cancelBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(ShareViewController *)shareVC{
    if (!_shareVC) {
        _shareVC = [[ShareViewController alloc] init];
    }
    return _shareVC;
}

-(void)wechatShareBtnAction:(UIButton*)sender{
    
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.qqData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.qqData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response){
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                         } else {
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
                                                        content:[NSString stringWithFormat:@"%@，%@。%@", self.model.title, self.model.share_desc, self.model.cover_url]
                                                          image:nil
                                                       location:nil
                                                    urlResource:urlResource
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *shareResponse){
                                                         if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                             [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                                                         } else {
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)cancleBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}
//--------------------------------------------------------------------------
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
