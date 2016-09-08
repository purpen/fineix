//
//  THNCuXiaoDetalViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNCuXiaoDetalViewController.h"
#import "THNCuXiaoDetalModel.h"
#import "THNCuXiaoDetalTopView.h"
#import "UIView+FSExtension.h"
#import "THNCuXiaoDetalContentTableViewCell.h"
#import <MJExtension.h>
#import "THNProductModel.h"
#import "ShareViewController.h"
#import "ProjectViewCommentsViewController.h"
#import "THNSceneDetalViewController.h"
#import "GoodsInfoViewController.h"
#import "HomePageViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "GoodsBrandViewController.h"
#import "SearchViewController.h"

@interface THNCuXiaoDetalViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UITableView *contenView;
/**  */
@property (nonatomic, strong) THNCuXiaoDetalModel *model;
/**  */
@property (nonatomic, strong) THNCuXiaoDetalTopView *topView;
/**  */
@property (nonatomic, strong) NSArray *modelAry;
@property(nonatomic,strong) ShareViewController *shareVC;

@end

static NSString *const cellId = @"THNCuXiaoDetalContentTableViewCell";

@implementation THNCuXiaoDetalViewController

-(THNCuXiaoDetalTopView *)topView{
    if (!_topView) {
        _topView = [THNCuXiaoDetalTopView viewFromXib];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        // 文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 10, MAXFLOAT);
        // 计算文字的高度
        CGFloat textH = [self.model.summary boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        _topView.height = 211 + textH + 10 + 20;
    }
    return _topView;
}

-(void)viewWillAppear:(BOOL)animated{
    if (self.vcType == 1) {
        self.navViewTitle.text = @"促销详情";
    }else if (self.vcType == 2){
        self.navViewTitle.text = @"好货详情";
    }
    
    
    
    [self.contenView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.cuXiaoDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            NSLog(@"促销详情 %@",result);
            self.model = [THNCuXiaoDetalModel mj_objectWithKeyValues:result[@"data"]];
            
            self.topView.model = self.model;
            [self.view layoutIfNeeded];
            [self.contenView reloadData];
            self.contenView.tableHeaderView = self.topView;
            [self.lookBtn setTitle:[NSString stringWithFormat:@"%@",self.model.view_count] forState:UIControlStateNormal];
            [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",self.model.comment_count] forState:UIControlStateNormal];
            [self.shareBtn setTitle:[NSString stringWithFormat:@"%@",self.model.share_count] forState:UIControlStateNormal];
        }
    } failure:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

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
                                                        [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld",[self.model.share_count integerValue] + 1] forState:UIControlStateNormal];
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
                                                        [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld",[self.model.share_count integerValue] + 1] forState:UIControlStateNormal];
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
                                                                 [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld",[self.model.share_count integerValue] + 1] forState:UIControlStateNormal];
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
                                                        content:[NSString stringWithFormat:@"%@，%@。%@", self.model.title, self.model.summary, self.model.cover_url]
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
                                                                 [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld",[self.model.share_count integerValue] + 1] forState:UIControlStateNormal];
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


- (IBAction)comment:(id)sender {
    ProjectViewCommentsViewController * commentVC = [[ProjectViewCommentsViewController alloc] init];
    commentVC.targetId = self.model._id;
    commentVC.sceneUserId = self.model.user_id;
    [self.navigationController pushViewController:commentVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    THNCuXiaoDetalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    self.modelAry = [THNProductModel mj_objectArrayWithKeyValuesArray:self.model.products];
    cell.model = self.modelAry[indexPat.row];
    cell.goodsTitleLabel.text = [NSString stringWithFormat:@"%@", cell.model.title] ;
    cell.navi = self.navigationController;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((THNProductModel*)self.modelAry[indexPath.row]).cellHeight;
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
                NSArray *fiveAry = [fourAry[1] componentsSeparatedByString:@"="];
                inforTag = fiveAry[1];
            }else{
                infoId = threeAry[1];
            }
            
            
            switch (type) {
                case 1:
                    //网址
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
                    GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
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
                    SearchViewController *vc = [[SearchViewController alloc] init];
                    vc.keyword = inforTag;
                    vc.index = [infoId integerValue];
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


@end
