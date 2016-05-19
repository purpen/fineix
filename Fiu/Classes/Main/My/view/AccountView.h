//
//  AccountView.h
//  Fiu
//
//  Created by THN-Dong on 16/4/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIButton *nickBtn;
@property (weak, nonatomic) IBOutlet UIButton *sumBtn;
@property (weak, nonatomic) IBOutlet UIButton *adreesBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
@property (weak, nonatomic) IBOutlet UIButton *qrcodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *certificationBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *IdentityTagsLabel;


+(instancetype)getAccountView;
@end
