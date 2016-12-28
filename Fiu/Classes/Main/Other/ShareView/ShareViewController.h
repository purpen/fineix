//
//  ShareViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <SVProgressHUD/SVProgressHUD.h>

@protocol ShareViewControllerDelegate <NSObject>

-(void)afterShare;

@end


@interface ShareViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIView *friendView;
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIView *weiBoView;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
/** 分享语 */
@property (nonatomic, strong) NSString *content;
/** 分享图片 */
@property (nonatomic, strong) UIImage *image;

/**  */
@property (nonatomic, weak) id<ShareViewControllerDelegate> shareDelegate;

@end
