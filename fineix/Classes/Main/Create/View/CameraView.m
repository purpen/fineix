//
//  CameraView.m
//  fineix
//
//  Created by FLYang on 16/2/29.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        
        [self addSubview:self.cameraNavView];
        
        [self setCamere];
        
        [self addSubview:self.takePhotosBtn];
        [_takePhotosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 80));
            make.top.equalTo(self.mas_top).with.offset((SCREEN_WIDTH  *1.33) + 10);
            make.centerX.equalTo(self);
        }];

    }
    return self;
}

#pragma mark - 顶部导航
- (UIView *)cameraNavView {
    if (!_cameraNavView) {
        _cameraNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _cameraNavView.backgroundColor = [UIColor colorWithHexString:pictureNavColor alpha:1];
        
        [_cameraNavView addSubview:self.cameraCancelBtn];
        [_cameraNavView addSubview:self.cameraTitlt];
        [_cameraNavView addSubview:self.flashBtn];
    }
    return _cameraNavView;
}

#pragma mark - 取消按钮
- (UIButton *)cameraCancelBtn {
    if (!_cameraCancelBtn) {
        _cameraCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_cameraCancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_cameraCancelBtn addTarget:self action:@selector(cameraCancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cameraCancelBtn;
}

- (void)cameraCancelBtnClick {
    [self.VC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 页面标题
- (UILabel *)cameraTitlt {
    if (!_cameraTitlt) {
        _cameraTitlt = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 120, 50)];
        _cameraTitlt.textColor = [UIColor whiteColor];
        _cameraTitlt.textAlignment = NSTextAlignmentCenter;
        _cameraTitlt.text = @"拍照";
        _cameraTitlt.font = [UIFont systemFontOfSize:Font_ControllerTitle];
    }
    return _cameraTitlt;
}

#pragma mark - 闪光灯按钮
- (UIButton *)flashBtn {
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
        [_flashBtn setImage:[UIImage imageNamed:@"ic_flash off"] forState:(UIControlStateNormal)];
        [_flashBtn setImage:[UIImage imageNamed:@"ic_flash on"] forState:(UIControlStateSelected)];
        [_flashBtn addTarget:self action:@selector(flashBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _flashBtn;
}

- (void)flashBtnClick {

    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (_flashBtn.selected == NO) {
        device.flashMode = AVCaptureFlashModeOn;
        _flashBtn.selected = YES;
    
    } else if (_flashBtn.selected == YES) {
        device.flashMode = AVCaptureFlashModeOff;
        _flashBtn.selected = NO;
    }
    
    [device unlockForConfiguration];
}

#pragma mark - 拍照按钮
- (UIButton *)takePhotosBtn {
    if (!_takePhotosBtn) {
        _takePhotosBtn = [[UIButton alloc] init];
        [_takePhotosBtn setImage:[UIImage imageNamed:@"icon_capture"] forState:(UIControlStateNormal)];
        [_takePhotosBtn addTarget:self action:@selector(takePhotosBtnClick) forControlEvents:(UIControlEventTouchUpInside)];

    }
    return _takePhotosBtn;
}

- (void)takePhotosBtnClick {
    //  控制输入和输出
    AVCaptureConnection * photoConnection = [self.photosOutput connectionWithMediaType:AVMediaTypeVideo];
    //  设备的旋转方向
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOrientation = [self photoDeviceOrientation:deviceOrientation];
    [photoConnection setVideoOrientation:videoOrientation];
    //  焦距
    [photoConnection setVideoScaleAndCropFactor:1];
    
    [self.photosOutput captureStillImageAsynchronouslyFromConnection:photoConnection
                                                   completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                       NSData * photoData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                       CFDictionaryRef photoRef = CMCopyDictionaryOfAttachments(kCFAllocatorDefault,
                                                                                                                imageDataSampleBuffer,
                                                                                                                kCMAttachmentMode_ShouldNotPropagate);
                                                       
                                                       //   监测摄像头的权限
                                                       ALAuthorizationStatus photoStatus = [ALAssetsLibrary authorizationStatus];
                                                       if (photoStatus == ALAuthorizationStatusRestricted || photoStatus == ALAuthorizationStatusDenied) {
                                                           NSLog(@"请开启摄像头的权限");
                                                       }
                                                       
                                                       //   保存到相册
                                                       ALAssetsLibrary * photoLibrary = [[ALAssetsLibrary alloc] init];
                                                       [photoLibrary writeImageDataToSavedPhotosAlbum:photoData metadata:(__bridge id)photoRef completionBlock:^(NSURL *assetURL, NSError *error) {
                                                           NSLog(@"拍照成功");
                                                       }];
                                                   }];
}

#pragma mark 获取设备的方向

- (AVCaptureVideoOrientation)photoDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    return videoOrientation;
}

#pragma mark - 初始化相机
- (void)setCamere {
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    //设置闪光灯为关闭
    [device setFlashMode:AVCaptureFlashModeOff];
    [device unlockForConfiguration];
    

    //  初始化数据连接
    self.session = [[AVCaptureSession alloc] init];
    
    //  初始化设备
    AVCaptureDevice * cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //  初始化输入设备
    self.cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:nil];
    
    //  初始化图片输出
    self.photosOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //  输出图像设置
    NSDictionary * outputSet = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.photosOutput setOutputSettings:outputSet];
    
    if ([self.session canAddInput:self.cameraInput]) {
        [self.session addInput:self.cameraInput];
    }
    if ([self.session canAddOutput:self.photosOutput]) {
        [self.session addOutput:self.photosOutput];
    }
    
    //  初始化预览图层
    self.previewPhoto = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewPhoto setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //  预览图层的尺寸(4:3)
    self.previewPhoto.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH * 1.33);
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:self.previewPhoto];
}


@end
