//
//  THNRedEnvelopeView.h
//  Fiu
//
//  Created by FLYang on 16/9/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNMacro.h"

@interface THNRedEnvelopeView : UIView

@pro_strong UIButton *closeBtn;
@pro_strong UIButton *goLook;
@pro_strong UIImageView *redEnvelopeImage;
@pro_strong UILabel *content;
@pro_strong UIView *alertView;

- (void)thn_showRedEnvelopeViewOnWindowWithText:(NSString *)text;

@end
