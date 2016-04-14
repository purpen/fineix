//
//  ImprovePersonalInformationView.m
//  Fiu
//
//  Created by THN-Dong on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImprovePersonalInformationView.h"

@implementation ImprovePersonalInformationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)getImprovePersonalInformationView{
    return [[NSBundle mainBundle] loadNibNamed:@"ImproveInformation" owner:nil options:nil][0];
}

@end
