//
//  MyQrCodeViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyQrCodeViewController.h"
#import <CoreImage/CoreImage.h>
#import "Fiu.h"
#import "MyQrCodeView.h"
#import "QrShareSheetViewController.h"
#import "SVProgressHUD.h"
#import "QRCodeScanViewController.h"
#import "UserInfoEntity.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>


@interface MyQrCodeViewController ()<FBNavigationBarItemsDelegate>
{
    UIImage *_viewImage;
}
@property(nonatomic,strong) CIFilter *filter;//生成二维码  过滤器
@property(nonatomic,strong) UIView *bgView;


@end

static NSString *const ShareURL = @"http://m.taihuoniao.com/guide/app_about";

@implementation MyQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navViewTitle.text = @"二维码";
    self.delegate = self;
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
    [self addBarItemRightBarButton:nil image:@"icon_ios_more_black" isTransparent:NO];
    
    [self.filter setDefaults];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSString *str = [NSString stringWithFormat:@"http://m.taihuoniao.com/guide/appload?infoType=13&infoId=%@",entity.userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_filter setValue:data forKey:@"inputMessage"];
    
    
    [self.view addSubview:self.qrCodeView];
    [_qrCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.top.mas_equalTo(self.view.mas_top).with.offset(64);
    }];
    
    [self getImageFromView:self.view];
    self.navView.hidden = NO;
}

-(void)getImageFromView:(UIView*)theView{
    
    self.navView.hidden = YES;
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, [UIScreen mainScreen].scale);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _viewImage = image;
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(UIView *)qrCodeView{
    if (!_qrCodeView) {
        _qrCodeView = [[MyQrCodeView alloc] init];
        [_qrCodeView setUI];
        CIImage *outputImag = [_filter outputImage];
        _qrCodeView.qrCodeImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImag withSize:300/667.0*SCREEN_HEIGHT];
    }
    return _qrCodeView;
}

-(CIFilter *)filter{
    if (!_filter) {
        _filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    }
    return _filter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBarItemSelected{
    QrShareSheetViewController *sheetVC = [[QrShareSheetViewController alloc] init];
    [self judgeWith:sheetVC];
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    sheetVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:sheetVC animated:NO completion:nil];
    [sheetVC.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.saveBtn addTarget:self action:@selector(savePicture:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.saoMiaoBtn addTarget:self action:@selector(scanQrCode:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.weChatBtn addTarget:self action:@selector(wechatShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.firendBtn addTarget:self action:@selector(timelineShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.weiboBtn addTarget:self action:@selector(sinaShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.qqBtn addTarget:self action:@selector(qqShareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [sheetVC.otherBtn addTarget:self action:@selector(clickOtherBtn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 点击屏幕空余部分消失
-(void)clickOtherBtn:(UIButton*)sender{
   [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -判断手机是否安装了相应的客户端
-(void)judgeWith:(QrShareSheetViewController*)vc{
    if ([WXApi isWXAppInstalled] == NO) {
        vc.weChatBtn.hidden = YES;
    }else{
        vc.weChatBtn.hidden = NO;
    }
    
    if ([WeiboSDK isWeiboAppInstalled] == NO) {
        vc.weiboBtn.hidden = YES;
    }else{
        vc.weiboBtn.hidden = NO;
    }
    
    if ([QQApiInterface isQQInstalled] == NO) {
        vc.qqBtn.hidden = YES;
    }else{
        vc.qqBtn.hidden = NO;
    }
}

-(void)wechatShareBtnAction:(UIButton*)sender{
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"" image:_viewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)timelineShareBtnAction:(UIButton*)sender{
    
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"" image:_viewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)qqShareBtnAction:(UIButton*)sender{
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"" image:_viewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [SVProgressHUD showSuccessWithStatus:@"分享成功！"];
        }
    }];
}

-(void)sinaShareBtnAction:(UIButton*)sender{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:@"有Fiu的生活，才够意思，快点扫码加我吧！查看个人主页>>http://www.taihuoniao.com" image:_viewImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
        }
    }];
}


-(void)cancelBtn:(UIButton*)sender{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -扫描二维码
-(void)scanQrCode:(UIButton*)sender{
//    QRCodeScanViewController *scanVC = [[QRCodeScanViewController alloc] init];
//    [self .navigationController pushViewController:scanVC animated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存图片
-(void)savePicture:(UIButton*)sender{
    
    //viewImage就是获取的截图，如果要将图片存入相册，只需在后面调用
    UIImageWriteToSavedPhotosAlbum(_viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    
    
//    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *pictureName= [NSString stringWithFormat:@"screenShow_%d.png",ScreenshotIndex];
//    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
//    NSLog(@"截屏路径打印: %@", savedImagePath);
}

-(void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存至相册"];
    }else{
        [SVProgressHUD showErrorWithStatus:[error description]];
    }
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
