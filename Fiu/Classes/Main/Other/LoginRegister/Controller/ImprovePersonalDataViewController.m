//
//  ImprovePersonalDataViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/11.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "ImprovePersonalDataViewController.h"

@interface ImprovePersonalDataViewController ()<UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UIButton *menBtn;//男按钮

@property (weak, nonatomic) IBOutlet UIButton *womenBtn;//女按钮
@property (weak, nonatomic) IBOutlet UIButton *secretBtn;//保密按钮
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;//昵称
@property (weak, nonatomic) IBOutlet UITextField *IndividualitySignatureTF;//个性签名

@end

@implementation ImprovePersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"完善个人资料";
    //头像变成椭圆
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 50;
    //点击头像可以更换头像
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    singleRecognizer.numberOfTouchesRequired = 1;
}
//
//-(void)singleTap:(UITapGestureRecognizer*)recognizer{
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"更换头像" message:@"拍照或者相册" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction =
//    UIImagePickerControllerSourceType sourcetype = UIImagePickerControllerSourceTypeCamera;
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        sourcetype = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = sourcetype;
//    [self presentViewController:picker animated:YES completion:nil];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
