//
//  TalentCertificationViewController.h
//  Fiu
//
//  Created by THN-Dong on 16/4/25.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBViewController.h"

@interface TalentCertificationViewController : FBViewController
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITextView *certificationTFV;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UIButton *businessCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *idCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end
