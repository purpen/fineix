//
//  QRCodeScanViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@protocol SystemScandfVCDelegate <NSObject>

-(void)getTheScanfMessage:(NSString*)message;

@end

@interface QRCodeScanViewController : FBViewController

@property(nonatomic,strong) id<SystemScandfVCDelegate>delegate1;

@end
