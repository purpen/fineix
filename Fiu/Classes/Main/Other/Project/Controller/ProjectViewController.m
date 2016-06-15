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


@interface ProjectViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *projectWebView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentsBtn;
@property (weak, nonatomic) IBOutlet UIButton *loveBtn;
/** 创建专题的人的id */
@property(nonatomic,copy) NSString *personId;
@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestGetDataFromeNet];
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
        self.navViewTitle.text = dataDict[@"title"];
        NSString *h5Url = dataDict[@"content_view_url"];
        self.personId = dataDict[@"user_id"];
        //地址
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",h5Url]];
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


/**
 *  进入专题的评论界面
 *
 *
 */
- (IBAction)clickCommentsBtn:(UIButton *)sender {
    ProjectViewCommentsViewController * commentVC = [[ProjectViewCommentsViewController alloc] init];
    commentVC.targetId = self.projectId;
    commentVC.sceneUserId = self.personId;
    [self.navigationController pushViewController:commentVC animated:YES];
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
