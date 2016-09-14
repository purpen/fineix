//
//  THNXinPinDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNXinPinDetalViewController.h"
#import "THNArticleDetalModel.h"
#import "THNProductModel.h"
#import "SVProgressHUD.h"
#import "ShareViewController.h"
#import "FBGoodsInfoViewController.h"
#import "THNCuXiaoDetalViewController.h"
#import "GoodsBrandViewController.h"
#import "SearchViewController.h"
#import "HomePageViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNSceneDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"

@interface THNXinPinDetalViewController ()<FBNavigationBarItemsDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *contenWebView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
/**  */
@property (nonatomic, strong) THNArticleDetalModel *model;
@property(nonatomic,strong) ShareViewController *shareVC;

@end

@implementation THNXinPinDetalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
                                                                                             @"id" : self.xinPinDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"新品详情 %@",result);
            self.model = [THNArticleDetalModel mj_objectWithKeyValues:result[@"data"]];
            NSString *flag = self.model.product.is_favorite;
            NSInteger a = [flag integerValue];
            if (a == 0) {
                self.collectBtn.selected = NO;
            }else{
                self.collectBtn.selected = YES;
            }
        }
    } failure:nil];
}

-(void)requestUrl{
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.xinPinDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"文章详情 %@",result);
            self.model = [THNArticleDetalModel mj_objectWithKeyValues:result[@"data"]];
            self.navViewTitle.text = self.model.title;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.content_view_url]];
            //在网页上加载
            NSURLRequest *webRequest = [NSURLRequest requestWithURL:url];
            [self.contenWebView loadRequest:webRequest];
            self.contenWebView.delegate = self;
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

#pragma mark - 截取网页点击事件，获取url
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSString *str = [url absoluteString];
        NSLog(@"str  %@",str);
        if([str rangeOfString:@"taihuoniao.com"].location == NSNotFound && [str rangeOfString:@"infoType"].location == NSNotFound){
            //打开浏览器
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else if ([str rangeOfString:@"taihuoniao.com"].location != NSNotFound && [str rangeOfString:@"infoType"].location != NSNotFound && [str rangeOfString:@"infoId"].location != NSNotFound){
            NSArray *oneAry = [str componentsSeparatedByString:@"?"];
            NSString *infoStr = oneAry[1];
            NSArray *twoAry = [infoStr componentsSeparatedByString:@"&"];
            NSString *infoType;
            if (((NSString*)twoAry[0]).length == 11) {
                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 2)];
            }else if(((NSString*)twoAry[0]).length == 10){
                infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 1)];
            }
            NSInteger type = [infoType integerValue];
            NSString *infoId;
            NSArray *threeAry = [twoAry[1] componentsSeparatedByString:@"="];
            NSString *inforTag;
            if (type == 20) {
                NSArray *fourAry = [threeAry[1] componentsSeparatedByString:@"&"];
                infoId = fourAry[0];
                NSArray *fiveAry = [twoAry[2] componentsSeparatedByString:@"="];
                inforTag = fiveAry[1];
            }else{
                infoId = threeAry[1];
            }
            
            
            switch (type) {
                case 1:
                    //网址
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:infoId]];
                    break;
                case 11:{
                    //情境
                    THNSceneDetalViewController * fiuSceneVC = [[THNSceneDetalViewController alloc] init];
                    fiuSceneVC.sceneDetalId = infoId;
                    [self.navigationController pushViewController:fiuSceneVC animated:YES];
                }
                    break;
                case 12:{
                    //产品
                    FBGoodsInfoViewController * goodsInfoVC = [[FBGoodsInfoViewController alloc] init];
                    goodsInfoVC.goodsID = infoId;
                    [self.navigationController pushViewController:goodsInfoVC animated:YES];
                }
                    break;
                case 13:{
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
                }  //用户
                    break;
                case 14:
                    //专题
                {
                    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                                             @"id" : infoId
                                                                                                             } delegate:self];
                    [request startRequestSuccess:^(FBRequest *request, id result) {
                        if (result[@"success"]) {
                            NSString *zhuanTiType = result[@"data"][@"type"];
                            NSInteger zhuanType = [zhuanTiType integerValue];
                            switch (zhuanType) {
                                case 1:{
                                    
                                    THNArticleDetalViewController *vc = [[THNArticleDetalViewController alloc] init];
                                    vc.articleDetalid = infoId;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    break;
                                }
                                    
                                case 2:{
                                    
                                    THNActiveDetalTwoViewController *vc = [[THNActiveDetalTwoViewController alloc] init];
                                    vc.activeDetalId = infoId;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    break;
                                }
                                case 3:{
                                    
                                    THNCuXiaoDetalViewController *vc = [[THNCuXiaoDetalViewController alloc] init];
                                    vc.cuXiaoDetalId = infoId;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    break;
                                }
                                case 4:{
                                    
                                    THNXinPinDetalViewController *vc = [[THNXinPinDetalViewController alloc] init];
                                    vc.xinPinDetalId = infoId;
                                    [self.navigationController pushViewController:vc animated:YES];
                                    break;
                                }
                                default:
                                    break;
                            }
                        }
                    } failure:nil];
                }
                    break;
                case 15:
                    //品牌
                {
                    GoodsBrandViewController *vc = [[GoodsBrandViewController alloc] init];
                    vc.brandId = infoId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 20:
                    //搜索
                {
                    NSString *keyWord = [inforTag stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    SearchViewController *vc = [[SearchViewController alloc] init];
                    vc.keyword = keyWord;
                    NSInteger infoIdTeger = [infoId integerValue];
                    switch (infoIdTeger) {
                        case 3:
                            vc.index = 2;
                            break;
                            
                        case 9:
                            vc.index = 0;
                            break;
                        case 12:
                            vc.index = 4;
                            break;
                        case 13:
                            vc.index = 3;
                            break;
                        case 14:
                            vc.index = 1;
                            break;
                            
                        default:
                            break;
                    }
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
        return NO;
    }
    return YES;
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

-(void)wechatShareBtnAction:(UIButton*)sender{
    
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession]
                                                        content:self.model.summary
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/record_share_count" requestDictionary:@{
                                                                                                                                                           @"id" : self.model._id
                                                                                                                                                           } delegate:self];
                                                    [request startRequestSuccess:^(FBRequest *request, id result) {
                                                    } failure:nil];

                                                } else {
                                                    [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeImage) url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline]
                                                        content:self.model.summary
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self completion:^(UMSocialResponseEntity *response){
                                                if (response.responseCode == UMSResponseCodeSuccess) {
                                                    [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                    [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/record_share_count" requestDictionary:@{
                                                                                                                                                           @"id" : self.model._id
                                                                                                                                                           } delegate:self];
                                                    [request startRequestSuccess:^(FBRequest *request, id result) {
                                                    } failure:nil];

                                                } else {
                                                    [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                }
                                            }];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.qqData.url = self.model.share_view_url;
    [UMSocialData defaultData].extConfig.qqData.title = self.model.title;
    UMSocialUrlResource * imgUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ]
                                                        content:self.model.summary
                                                          image:nil
                                                       location:nil
                                                    urlResource:imgUrl
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *response){
                                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                                             [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                             [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                             FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/record_share_count" requestDictionary:@{
                                                                                                                                                                    @"id" : self.model._id
                                                                                                                                                                    } delegate:self];
                                                             [request startRequestSuccess:^(FBRequest *request, id result) {
                                                             } failure:nil];

                                                         } else {
                                                             [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.model.cover_url];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina]
                                                        content:[NSString stringWithFormat:@"%@", self.model.title]
                                                          image:nil
                                                       location:nil
                                                    urlResource:urlResource
                                            presentedController:self
                                                     completion:^(UMSocialResponseEntity *shareResponse){
                                                         if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                                             [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                             [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
                                                             FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/record_share_count" requestDictionary:@{
                                                                                                                                                                    @"id" : self.model._id
                                                                                                                                                                    } delegate:self];
                                                             [request startRequestSuccess:^(FBRequest *request, id result) {
                                                             } failure:nil];

                                                         } else {
                                                             [self.shareVC dismissViewControllerAnimated:NO completion:nil];
                                                             [SVProgressHUD showErrorWithStatus:@"分享失败"];
                                                         }
                                                     }];
}

-(void)cancleBtnAction:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)collect:(UIButton*)sender {
    if (sender.selected) {
        //取消收藏
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = self.model.product._id;
        params[@"type"] = @"1";
        FBRequest *request = [FBAPI postWithUrlString:@"/favorite/ajax_cancel_favorite" requestDictionary:params delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if (result[@"success"]) {
                sender.selected = NO;
            }else{
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
            }
        } failure:nil];
    }else{
        //收藏
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = self.model.product._id;
        params[@"type"] = @"1";
        FBRequest *request = [FBAPI postWithUrlString:@"/favorite/ajax_favorite" requestDictionary:params delegate:self];
        [request startRequestSuccess:^(FBRequest *request, id result) {
            if (result[@"success"]) {
                sender.selected = YES;
            }else{
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
            }
        } failure:nil];
    }
}


- (IBAction)buy:(id)sender {
    FBGoodsInfoViewController *vc = [[FBGoodsInfoViewController alloc] init];
    vc.goodsID = self.model.product._id;
    [self.navigationController pushViewController:vc animated:YES];
}

-(ShareViewController *)shareVC{
    if (!_shareVC) {
        _shareVC = [[ShareViewController alloc] init];
    }
    return _shareVC;
}

@end
