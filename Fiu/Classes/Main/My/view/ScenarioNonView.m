//
//  ScenarioNonView.m
//  Fiu
//
//  Created by THN-Dong on 16/6/6.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ScenarioNonView.h"
#import "PictureToolViewController.h"

@implementation ScenarioNonView

+(instancetype)getScenarioNonView{
    ScenarioNonView *view = [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:nil options:nil][4];
    view.creatBtn.layer.masksToBounds = YES;
    view.creatBtn.layer.cornerRadius = 3;
    
    return view;
}

- (IBAction)creatBtnClick:(id)sender {
    PictureToolViewController * pictureToolVC = [[PictureToolViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pictureToolVC animated:YES completion:nil];
}


@end
