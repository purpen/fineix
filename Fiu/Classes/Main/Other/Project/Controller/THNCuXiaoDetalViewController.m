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
        _topView.height = 211 + textH + 10 + 10;
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navViewTitle.text = @"促销详情";
    
    
    [self.contenView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.id
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
//    ProjectViewCommentsViewController * commentVC = [[ProjectViewCommentsViewController alloc] init];
//    commentVC.targetId = self.model._id;
//    commentVC.sceneUserId = self.model.user_id;
//    [self.navigationController pushViewController:commentVC animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPat{
    THNCuXiaoDetalContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    self.modelAry = [THNProductModel mj_objectArrayWithKeyValuesArray:self.model.products];
    cell.model = self.modelAry[indexPat.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.",(long)indexPat.row + 1];
    cell.navi = self.navigationController;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ((THNProductModel*)self.modelAry[indexPath.row]).cellHeight;
}

@end
