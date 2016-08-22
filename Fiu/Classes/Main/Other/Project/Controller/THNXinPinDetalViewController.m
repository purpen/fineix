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
            NSLog(@"新品详情 %@",result);
            self.model = [THNArticleDetalModel mj_objectWithKeyValues:result[@"data"]];
            NSString *flag = self.model.product.is_favorite;
            NSInteger a = [flag integerValue];
            if (a == 0) {
                self.buyBtn.selected = NO;
            }else{
                self.buyBtn.selected = YES;
            }
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
