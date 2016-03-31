//
//  MyHomePageView.m
//  fineix
//
//  Created by THN-Dong on 16/3/18.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MyHomePageView.h"

@implementation MyHomePageView

+(instancetype)getMyHomePageView{
    return [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][0];
}
@end
