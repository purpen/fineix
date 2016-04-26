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
#import "FBSheetViewController.h"
#import "SVProgressHUD.h"
#import "QRCodeScanViewController.h"
#import "UserInfoEntity.h"

@interface MyQrCodeViewController ()<FBNavigationBarItemsDelegate>

@property(nonatomic,strong) CIFilter *filter;//生成二维码  过滤器
@property(nonatomic,strong) MyQrCodeView *qrCodeView;//我的二维码图片


@end



@implementation MyQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
    // Do any additional setup after loading the view.
    //设置导航条
    self.navigationItem.title = @"二维码";
    self.delegate = self;
//    [self addBarItemLeftBarButton:nil image:@"icon_back"];
//    [self addBarItemRightBarButton:nil image:@"icon_ios_more_black"];
    
    [self.filter setDefaults];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSString *str = [NSString stringWithFormat:@"qq41e073ea://id=%@",entity.userId];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_filter setValue:data forKey:@"inputMessage"];
    self.view = self.qrCodeView;
    
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
    NSLog(@"更多");
    FBSheetViewController *sheetVC = [[FBSheetViewController alloc] init];
    sheetVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:sheetVC animated:NO completion:nil];
    [sheetVC initFBSheetVCWithNameAry:[NSArray arrayWithObjects:@"保存图片",@"扫描二维码",@"取消", nil]];
    [((UIButton*)sheetVC.sheetView.subviews[2]) addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton*)sheetVC.sheetView.subviews[0]) addTarget:self action:@selector(savePicture:) forControlEvents:UIControlEventTouchUpInside];
    [((UIButton*)sheetVC.sheetView.subviews[1]) addTarget:self action:@selector(scanQrCode:) forControlEvents:UIControlEventTouchUpInside];
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
    NSLog(@"保存图片");
    UIImageWriteToSavedPhotosAlbum(self.qrCodeView.qrCodeImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    [self dismissViewControllerAnimated:NO completion:nil];
    
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
