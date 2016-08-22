//
//  THNArticleDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNArticleDetalViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import "THNArticleDetalModel.h"
#import <MJExtension.h>
#import "SVProgressHUD.h"
#import "ProjectViewCommentsViewController.h"
#import "ShareViewController.h"

@interface THNArticleDetalViewController ()<FBNavigationBarItemsDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *contentWebView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
/**  */
@property (nonatomic, strong) THNArticleDetalModel *model;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property(nonatomic,strong) ShareViewController *shareVC;

@end

@implementation THNArticleDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navViewTitle.text = self.title;
    self.delegate = self;
    [self addBarItemRightBarButton:nil image:@"project_share_w" isTransparent:NO];
    
    [self requestUrl];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestGetDataFromeNet];
}

-(void)requestGetDataFromeNet{
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.id
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"文章详情 %@",result);
            self.model = [THNArticleDetalModel mj_objectWithKeyValues:result[@"data"]];
            [self.lookBtn setTitle:[NSString stringWithFormat:@"%@",self.model.view_count] forState:UIControlStateNormal];
            [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",self.model.favorite_count] forState:UIControlStateNormal];
            [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",self.model.attend_count] forState:UIControlStateNormal];
        }
    } failure:nil];
}

-(void)requestUrl{
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.id
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"文章详情 %@",result);
            self.model = [THNArticleDetalModel mj_objectWithKeyValues:result[@"data"]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.content_view_url]];
            //在网页上加载
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
            [self.contentWebView loadRequest:webRequest];
            self.contentWebView.delegate = self;
        }
    } failure:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [SVProgressHUD show];
}
//网页加载完成进度条消失
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
//网页加载失败，提示加载失败原因
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showInfoWithStatus:error.localizedDescription];
}

//#pragma mark - 截取网页点击事件，获取url
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked)
//    {
//        NSURL *url = [request URL];
//        NSString *str = [url absoluteString];
//        NSLog(@"str  %@",str);
//        if([str rangeOfString:@"infoType"].location == NSNotFound){
//            [SVProgressHUD showErrorWithStatus:@"参数不足"];
//        }else if ([str rangeOfString:@"taihuoniao.com"].location != NSNotFound && [str rangeOfString:@"infoType"].location != NSNotFound){
//            NSArray *oneAry = [str componentsSeparatedByString:@"?"];
//            NSString *infoStr = oneAry[1];
//            NSArray *twoAry = [infoStr componentsSeparatedByString:@"&"];
//            NSString *infoType;
//            if (((NSString*)twoAry[0]).length == 11) {
//                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 2)];
//            }else if(((NSString*)twoAry[0]).length == 10){
//                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 1)];
//            }
//            NSArray *threeAry = [twoAry[1] componentsSeparatedByString:@"="];
//            NSString *infoId = threeAry[1];
//            if ([infoType isEqualToString:@"10"]) {
//                //情景
//                FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
//                fiuSceneVC.fiuSceneId = infoId;
//                [self.navigationController pushViewController:fiuSceneVC animated:YES];
//            }else if ([infoType isEqualToString:@"11"]) {
//                //场景
//                SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
//                sceneInfoVC.sceneId = infoId;
//                [self.navigationController pushViewController:sceneInfoVC animated:YES];
//            }else if ([infoType isEqualToString:@"12"]) {
//                //产品
//                GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
//                goodsInfoVC.goodsID = infoId;
//                [self.navigationController pushViewController:goodsInfoVC animated:YES];
//            }else if ([infoType isEqualToString:@"13"]) {
//                //用户
//                HomePageViewController *homeOpage = [[HomePageViewController alloc] init];
//                homeOpage.type = @2;
//                homeOpage.userId = infoId;
//                UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
//                if ([entity.userId isEqualToString:infoId]) {
//                    homeOpage.isMySelf = YES;
//                }else{
//                    homeOpage.isMySelf = NO;
//                }
//                [self.navigationController pushViewController:homeOpage animated:YES];
//            }
//        }
//        return NO;
//    }
//    return YES;
//}

-(ShareViewController *)shareVC{
    if (!_shareVC) {
        _shareVC = [[ShareViewController alloc] init];
    }
    return _shareVC;
}

- (IBAction)share:(id)sender {
    self.shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_shareVC animated:YES completion:nil];
    //给每一个分享按钮添加点击事件
    [_shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)wechatShareBtnAction:(UIButton*)sender{
    
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.model.share_desc;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.model.share_desc;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                } else {
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.qqData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.qqData.title = self.model.share_desc;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                        content:self.model.share_desc
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response){
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                         } else {
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
                                                        content:[NSString stringWithFormat:@"%@，%@。%@", self.model.share_desc, self.model.share_desc, self.model.cover_url]
                                                          image:nil
                                                       location:nil
                                                    urlResource:urlResource
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *shareResponse){
                                                         if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                             [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                         } else {
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)cancleBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (IBAction)comment:(id)sender {
    ProjectViewCommentsViewController * commentVC = [[ProjectViewCommentsViewController alloc] init];
    commentVC.targetId = self.model._id;
    commentVC.sceneUserId = self.model.user_id;
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (IBAction)look:(id)sender {
}

-(void)rightBarItemSelected{
    self.shareVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    self.shareVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:_shareVC animated:YES completion:nil];
    //给每一个分享按钮添加点击事件
    [_shareVC.wechatBtn addTarget:self action:@selector(wechatShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.friendBtn addTarget:self action:@selector(timelineShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.qqBtn addTarget:self action:@selector(qqShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareVC.weiBoBtn addTarget:self action:@selector(sinaShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

@end
