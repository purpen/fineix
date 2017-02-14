//
//  THNSelecteCityViewController.h
//  Fiu
//
//  Created by THN-Dong on 2017/2/14.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THNViewController.h"

@protocol selectedCityDelegate <NSObject>

-(void)setSelectedCityStr:(NSString*)str;

@end

@interface THNSelecteCityViewController : THNViewController

/**  */
@property (nonatomic, weak) id <selectedCityDelegate> selectedCityDelegate;

@end
