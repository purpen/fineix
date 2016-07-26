//
//  SexSheetViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/6/7.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "SexSheetViewController.h"

@interface SexSheetViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSNumber *_sex;
}
@property(nonatomic,strong) NSArray *sexAry;

@end

@implementation SexSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.navView.hidden = YES;
    self.sexPickerView.delegate = self;
    self.sexPickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)sexAry{
    if (!_sexAry) {
        _sexAry = [NSArray arrayWithObjects:NSLocalizedString(@"secret", nil),NSLocalizedString(@"men", nil),NSLocalizedString(@"women", nil), nil];
    }
    return _sexAry;
}

#pragma mark -UIPickerViewDelegate & UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:20];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return self.sexAry[row];
        }
            break;
        default:
            return @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            self.sexNum = @(row);
        }
            break;
        default:
            break;
    }
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
