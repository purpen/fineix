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
    [self addBarItemLeftBarButton:nil image:@"icon_back"];
    [self addBarItemRightBarButton:nil image:@"icon_ios_more_black"];
    
    [self.filter setDefaults];
    NSString *str = @"董永胜";
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
