//
//  QRCodeScanViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AudioToolbox/AudioToolbox.h>
#import "UserInfo.h"
#import "Fiu.h"
#import "SVProgressHUD.h"
#import "HomePageViewController.h"
#import "MyQrCodeViewController.h"
#import "FiuSceneViewController.h"
#import "SceneInfoViewController.h"
#import "GoodsInfoViewController.h"
#import "UserInfoEntity.h"

@interface QRCodeScanViewController ()<FBNavigationBarItemsDelegate,UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate>

{
    int _num;
    BOOL _upOrDown;
    NSTimer *_timer;
}

@property(nonatomic,strong) AVCaptureDevice *device;
@property(nonatomic,strong) AVCaptureDeviceInput *input;
@property(nonatomic,strong) AVCaptureMetadataOutput *output;
@property(nonatomic,strong) AVCaptureSession *session;
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *preview;//预览图层
@property(nonatomic,strong) UserInfo *model;//二维码扫描结果
@property(nonatomic,strong) UIImageView *line;//动画线
@property(nonatomic,strong) UIImageView *imageView;//边框
@property(nonatomic,copy) NSString *resultStr;//记录扫描结果


@end

@implementation QRCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条
    self.navViewTitle.text = @"扫一扫";
    self.delegate = self;
    [self addBarItemLeftBarButton:nil image:@"icon_back" isTransparent:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_device) {
        [self setupCamera];
        [self setUpViews];
    }else{
        [_session startRunning];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    }
}

-(void)setUpViews{
    _upOrDown = NO;
    _num = 0;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (SCREEN_HEIGHT-SCREEN_WIDTH+80)*0.5, SCREEN_WIDTH-80, SCREEN_WIDTH-80)];
    _imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:_imageView];
    
    UIGraphicsBeginImageContext(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.5);
    
    CGRect drawRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    CGContextFillRect(ctx, drawRect);
    
    drawRect = CGRectMake(40, CGRectGetMinY(_imageView.frame), CGRectGetWidth(_imageView.frame), CGRectGetHeight(_imageView.frame));
    CGContextClearRect(ctx, drawRect);
    
    UIImage *returnimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *bgimv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgimv.image = returnimage;
    [self.view addSubview:bgimv];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_imageView.frame)-220)/2+CGRectGetMinX(_imageView.frame), CGRectGetMinY(_imageView.frame), 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    UILabel * titleLab =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imageView.frame), _imageView.frame.origin.y-30, CGRectGetWidth(_imageView.frame), 10)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"将二维码放入框内可自动扫描";
    titleLab.textColor =[UIColor whiteColor];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(1000*0.5/667.0*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    //我的二维码
    UIButton * lightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    lightBtn.frame =CGRectMake(0, _imageView.frame.size.height+_imageView.frame.origin.y + 30, SCREEN_WIDTH, 40);
    [lightBtn setTitle:@"我的二维码" forState:UIControlStateNormal];
    [lightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lightBtn addTarget:self action:@selector(myQr:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLab.mas_bottom).with.offset(15/667.0*SCREEN_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1{
    if (_upOrDown == NO) {
        _num ++;
        _line.frame = CGRectMake((SCREEN_WIDTH-220)*0.5, CGRectGetMinY(_imageView.frame)+_num, 220, 2);
        if (_num + CGRectGetMinY(_imageView.frame) == CGRectGetMaxY(_imageView.frame)) {
            _upOrDown = YES;
        }
    }else{
        _num --;
        _line.frame = CGRectMake((SCREEN_WIDTH-220)*0.5, CGRectGetMinY(_imageView.frame)+_num, 220, 2);
        if (_num == 0) {
            _upOrDown = NO;
        }
    }
}



-(void)myQr:(UIButton*)sender{
    MyQrCodeViewController *vc = [[MyQrCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(void)setupCamera{
    BOOL state = [self isAllowMedia];
    if (state) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        if ([_session canAddInput:self.input]) {
            [_session addInput:self.input];
        }
        if ([_session canAddOutput:self.output]) {
            [_session addOutput:self.output];
        }
        
        //条码类型
        _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
        
        _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _preview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.view.layer insertSublayer:self.preview atIndex:0];
        
        [_session startRunning];
    }
}

-(BOOL)isAllowMedia{
    BOOL isMedia;
    NSString *mediaMessage = @"请在设置->隐私->相机 中打开本应用的访问权限";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        isMedia = NO;
    }else{
        isMedia = YES;
    }
    if (!isMedia) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:mediaMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 7;
        alertView.delegate = self;
        [alertView show];
    }
    return isMedia;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 7:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 11:
        {
            if (buttonIndex) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_resultStr]];
            }
        }
            break;
            
        default:
            break;
    }
    [_session startRunning];
}

-(void)leftBarItemSelected{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_timer invalidate];
    [_session stopRunning];
}


#pragma mark -AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        stringValue = metadataObject.stringValue;
        //记录扫描结果
        _resultStr = stringValue;
    }
    if (stringValue.length) {
        [_session stopRunning];
        //处理扫描结果
        [self scanResultWithStr:stringValue];
    }
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        [_timer invalidate];
//        if ([self.delegate1 respondsToSelector:@selector(getTheScanfMessage:)]) {
//            [self.delegate1 getTheScanfMessage:stringValue];
//        }
//    }];
}

#pragma mark - 处理扫描结果
-(void)scanResultWithStr:(NSString*)resultStr{
    NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id resultObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    //判断是不是自己的二维码
    if ([resultStr rangeOfString:@"taihuoniao.com"].location == NSNotFound || [resultStr rangeOfString:@"infoType"].location == NSNotFound) {
        
        
        NSRange range = [resultStr rangeOfString:@"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否打开以下网址" message:resultStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 11;
            [alertView show];
            [_session stopRunning];
            return;
        }else{
            [SVProgressHUD showErrorWithStatus:resultObj];
        }
    }else if([resultStr rangeOfString:@"infoType"].location == NSNotFound){
        [SVProgressHUD showErrorWithStatus:@"参数不足"];
    }else if ([resultStr rangeOfString:@"taihuoniao.com"].location != NSNotFound && [resultStr rangeOfString:@"infoType"].location != NSNotFound){
        NSArray *oneAry = [resultStr componentsSeparatedByString:@"?"];
        NSString *infoStr = oneAry[1];
        NSArray *twoAry = [infoStr componentsSeparatedByString:@"&"];
        NSString *infoType = [twoAry[0] substringWithRange:NSMakeRange(9, 2)];
        NSString *infoId = [twoAry[1] substringWithRange:NSMakeRange(7, 5)];
        if ([infoType isEqualToString:@"10"]) {
            //情景
            FiuSceneViewController * fiuSceneVC = [[FiuSceneViewController alloc] init];
            fiuSceneVC.fiuSceneId = infoId;
            [self.navigationController pushViewController:fiuSceneVC animated:YES];
        }else if ([infoType isEqualToString:@"11"]) {
            //场景
            SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
            sceneInfoVC.sceneId = infoId;
            [self.navigationController pushViewController:sceneInfoVC animated:YES];
        }else if ([infoType isEqualToString:@"12"]) {
            //产品
            GoodsInfoViewController * goodsInfoVC = [[GoodsInfoViewController alloc] init];
            goodsInfoVC.goodsID = infoId;
            [self.navigationController pushViewController:goodsInfoVC animated:YES];
        }else if ([infoType isEqualToString:@"13"]) {
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
        }
    }
    [_session startRunning];
}

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

@end
