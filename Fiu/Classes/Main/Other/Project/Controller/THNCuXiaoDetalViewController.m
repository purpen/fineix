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
#import "MJExtension.h"
#import "THNProductModel.h"
#import "ShareViewController.h"
#import "ProjectViewCommentsViewController.h"
#import "THNSceneDetalViewController.h"
#import "FBGoodsInfoViewController.h"
#import "HomePageViewController.h"
#import "THNArticleDetalViewController.h"
#import "THNActiveDetalTwoViewController.h"
#import "THNXinPinDetalViewController.h"
#import "GoodsBrandViewController.h"
#import "SearchViewController.h"
#import <UMSocialCore/UMSocialCore.h>

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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopSpace;

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
        _topView.height = 211 + textH + 10 + 10;
        if (self.vcType == 2) {
            _topView.timeLabel.hidden = YES;
        }
    }
    return _topView;
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    [[UIApplication sharedApplication] setStatusBarStyle:(UIStatusBarStyleLightContent) animated:YES];
    
    if (self.vcType == 1) {
        self.navViewTitle.text = @"促销详情";
    }else if (self.vcType == 2){
        self.navViewTitle.text = @"好货合集";
    }
    
    
    [self.contenView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.cuXiaoDetalId
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
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
    
    if (SCREEN_HEIGHT == 812) {
        self.viewBottomSpace.constant = 20;
        self.tableViewTopSpace.constant += 24;
    }
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

- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.title descr:self.model.summary thumImage:self.model.cover_url];
    //设置网页地址
    shareObject.webpageUrl = self.model.share_view_url;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [self.shareVC dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showErrorWithStatus:@"分享失败"];
            
        } else {
            [self.shareVC dismissViewControllerAnimated:NO completion:nil];
            [SVProgressHUD showSuccessWithStatus:@"让分享变成生产力，别让生活偷走远方的精彩"];
            FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/record_share_count" requestDictionary:@{@"id" : self.model._id} delegate:self];
            [request startRequestSuccess:^(FBRequest *request, id result) {
                [self.shareBtn setTitle:[NSString stringWithFormat:@"%ld",[self.model.share_count integerValue] + 1] forState:UIControlStateNormal];
            } failure:nil];

        }
    }];
}

-(void)wechatShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_WechatSession)];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_WechatTimeLine)];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_QQ)];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    [self shareTextToPlatformType:(UMSocialPlatformType_Sina)];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FBGoodsInfoViewController *vc = [[FBGoodsInfoViewController alloc] init];
    THNProductModel *model = self.modelAry[indexPath.row];
    vc.goodsID = model._id;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
