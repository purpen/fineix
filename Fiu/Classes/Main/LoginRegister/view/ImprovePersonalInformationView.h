//
//  ImprovePersonalInformationView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/13.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImprovePersonalInformationView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *menBtn;
@property (weak, nonatomic) IBOutlet UIView *womenView;
@property (weak, nonatomic) IBOutlet UIView *secretView;
@property (weak, nonatomic) IBOutlet UIView *manView;
@property (weak, nonatomic) IBOutlet UIButton *womenBtn;
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *IndividualitySignatureTF;

+(instancetype)getImprovePersonalInformationView;

@end
