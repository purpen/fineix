//
//  PersonLabelPickerViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/7/20.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PersonLabelPickerViewController.h"

@interface PersonLabelPickerViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong) NSArray *sexAry;
@end

@implementation PersonLabelPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    self.navView.hidden = YES;
    _personLabelstr = self.sexAry[0];
}

-(NSArray *)sexAry{
    if (!_sexAry) {
        _sexAry = [NSArray arrayWithObjects:@"创业先锋",@"IT互联网",@"设计师",@"女神",@"公务员",@"职场新人",@"女强人",@"白领",@"学生",@"买手",@"程序猿",@"BOSS",@"直男",@"驴友",@"吃货",@"单身",@"文艺范", nil];
    }
    return _sexAry;
}

#pragma mark -UIPickerViewDelegate & UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.sexAry.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:20];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
- (IBAction)oterBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.personDelegate respondsToSelector:@selector(personLabelStr:)]) {
            [self.personDelegate personLabelStr:self.personLabelstr];
        }
    }];
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
            self.personLabelstr = _sexAry[row];
        }
            break;
        case 1:
        {
        }
            break;
        default:
            break;
    }
}

@end
