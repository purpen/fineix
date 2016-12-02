//
//  PaySuccessViewController.m
//  parrot
//
//  Created by THN-Huangfei on 16/1/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "BonusViewController.h"
#import "UMSocial.h"
#import "THNOrderInfoViewController.h"
#import "UIView+TYAlertView.h"
#import "OrderInfoModel.h"
#define shareReqFlag  @"shareflge"
#define bounsReqFlag  @"bounsflge"
;
@interface PaySuccessViewController ()<UMSocialUIDelegate,FBNavigationBarItemsDelegate>

@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *paymentWayLbl;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLbl;
//获取红包
@property (nonatomic,strong)FBAPI * disCountRequest;

//获取分享数据
@property (nonatomic,strong)FBAPI * GetShareInfoRequest;


/**
 *  分享获得优惠券视图
 */
//@property (nonatomic,strong)PaySuccessWithShareView * shareView;

@property (nonatomic,strong)NSString * titleStr;
@property (nonatomic,strong)NSString * cover_url;
@property (nonatomic,strong)NSString * desc;
@property (nonatomic,strong)NSString * wap_view_url;

- (IBAction)orderDetailBtnAction:(id)sender;


@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.delegate = self;
    self.navViewTitle.text = @"支付完成";
    
    
    self.orderIdLbl.text = self.orderInfo.rid;
    if (self.paymentWay.length == 0) {
        self.paymentWayLbl.text = @"红包支付";
    }else{
       self.paymentWayLbl.text = self.paymentWay;
    }
    self.createTimeLbl.text = self.orderInfo.createdAt;
    self.leftBtn.hidden = YES;
    [self addBarItemRightBarButton:@"完成" image:nil isTransparent:NO];
    
    //[self NoticeWithShare];
}
//- (void)NoticeWithShare{
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"分享有奖" message:@"分享您此次购买的产品将获得5元无门槛红包！" preferredStyle:1];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不分享" style:UIAlertActionStyleCancel handler:nil];
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"果断分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        //分享
//        [weakSelf GotoShare];
//    }];
//    
//    [alert addAction:cancelAction];
//    [alert addAction:okAction];
//    [self presentViewController:alert animated:YES completion:nil];
//}
////TODO:toshare
//- (void)GotoShare{
//    [SVProgressHUD show];
//    NSDictionary * params = @{@"rid":self.orderInfo.rid?self.orderInfo.rid:@""};
//    self.GetShareInfoRequest = [FBAPI postWithUrlString:KURL_GET_SHARE_INFO requestDictionary:params delegate:self];
//    self.GetShareInfoRequest.flag = shareReqFlag;
//    [self.GetShareInfoRequest startRequest];
//    
//}
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

- (IBAction)orderDetailBtnAction:(id)sender {
    THNOrderInfoViewController *orderInfoVC = [[THNOrderInfoViewController alloc] init];
    orderInfoVC.orderId = self.orderInfo.rid;
    [self.navigationController pushViewController:orderInfoVC animated:YES];
}


-(void)rightBarItemSelected{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



////-------------
//- (void)defaultShareUI{
//    NSLog(@"%@\n%@\n%@\n%@\n",self.cover_url,self.titleStr,self.wap_view_url,self.desc);
//    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.cover_url];
//
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.wechatFavoriteData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.wechatFavoriteData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.qqData.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.qqData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.qzoneData.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.qzoneData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.emailData.urlResource.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.emailData.title = self.titleStr;
//    
//    [UMSocialData defaultData].extConfig.smsData.urlResource.url = self.wap_view_url;
//    [UMSocialData defaultData].extConfig.smsData.shareText = self.titleStr;
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"56934de2e0f55aaae1002f37"
//                                      shareText:self.desc
//                                     shareImage:nil
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite,UMShareToQQ,UMShareToQzone,UMShareToEmail,UMShareToSms,nil]
//                                       delegate:self];   
//}
//

//现在会出现效果：
//social
//
//注意： 1. 支持分享编辑页和授权页面横屏，必须要在出现列表页面前设置:
//[UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape]; 
//2. 点击每个平台后默认会进入内容编辑页面，若想点击后直接分享内容，可以实现下面的回调方法。
////弹出列表方法presentSnsIconSheetView需要设置delegate为self
//-(BOOL)isDirectShareInIconActionSheet
//{
//    return YES;
//}
//
//-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//    //根据`responseCode`得到发送结果,如果分享成功
//    if(response.responseCode == UMSResponseCodeSuccess)
//    {
//        //得到分享到的微博平台名
//        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
//        
//        //[self shareSuccseeful];
//
//    }      
//}
//跳转红包页面
-(void)discounrBtnClick{
//    [_shareView hideInWindow];
    BonusViewController * bonusVC = [[BonusViewController alloc] initWithNibName:@"BonusViewController" bundle:nil];
    [self.navigationController pushViewController:bonusVC animated:YES];
}
////TODO:REQUEST
//- (void)shareSuccseeful{
//    [SVProgressHUD show];
//    NSDictionary * params = @{@"type":@"1",@"rid":self.orderInfo.rid?self.orderInfo.rid:@""};
//    self.disCountRequest = [FBAPI postWithUrlString:KURL_GET_FIVE_BOUNS requestDictionary:params delegate:self];
//    self.disCountRequest.flag = bounsReqFlag;
//    [self.disCountRequest startRequest];
//}
//- (void)requestFailed:(FBRequest *)request error:(NSError *)error{
//    [SVProgressHUD dismiss];
//    TYAlertView * alert = [TYAlertView alertViewWithTitle:@"警告" message:error.localizedDescription];
//    [alert showInWindowWithBackgoundTapDismissEnable:YES];
//    NSLog(@"%@",error.localizedDescription);
//}
//- (void)requestSucess:(FBRequest *)request result:(id)result{
//    [SVProgressHUD dismiss];
//    if ([request.flag isEqualToString:bounsReqFlag]) {
//    if ([[result objectForKey:@"success"] boolValue]) {
//                if (!_shareView) {
//                    _shareView = [PaySuccessWithShareView createViewFromNib];
//        
//                }
//                _shareView.delegate =self;
//                // use UIView Category
//        NSString * bounsPricestr = [NSString stringWithFormat:@"%@",[[result objectForKey:@"data"] objectForKey:@"bonus_money"]];
//        _shareView.priceLab.text = bounsPricestr;
//        _shareView.bounsInfoLab.text = [NSString stringWithFormat:@"您已获得%@元无门槛优惠券",bounsPricestr];
//                [_shareView showInWindowWithBackgoundTapDismissEnable:YES];  
//    }
//    else{
//        TYAlertView * alert = [TYAlertView alertViewWithTitle:@"警告" message:[result objectForKey:@"message"]];
//        [alert showInWindowWithBackgoundTapDismissEnable:YES];
//    }
//    }
//    else{
//        if ([[result objectForKey:@"success"] boolValue]) {
//            self.titleStr = [[result objectForKey:@"data"] objectForKey:@"title"];
//            self.cover_url = [[result objectForKey:@"data"] objectForKey:@"cover_url"];
//            self.desc = [[result objectForKey:@"data"] objectForKey:@"desc"];
//            self.wap_view_url = [[result objectForKey:@"data"] objectForKey:@"wap_view_url"];
//            [self defaultShareUI];
//        }
//        else{
//            TYAlertView * alert = [TYAlertView alertViewWithTitle:@"警告" message:[result objectForKey:@"message"]];
//            [alert showInWindowWithBackgoundTapDismissEnable:YES];
//        }
//    }
//    
//}
@end
