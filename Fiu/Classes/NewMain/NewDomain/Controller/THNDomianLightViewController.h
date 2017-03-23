//
//  THNDomianLightViewController.h
//  Fiu
//
//  Created by FLYang on 2017/2/24.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNViewController.h"

@interface THNDomianLightViewController : THNViewController <
    THNNavigationBarItemsDelegate
>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *textMarr;
@property (nonatomic, strong) NSMutableArray *imageMarr;
@property (nonatomic, strong) NSMutableArray *imageIndexMarr;

- (void)thn_setBrightSpotData:(NSArray *)model edit:(BOOL)edit;

@end
