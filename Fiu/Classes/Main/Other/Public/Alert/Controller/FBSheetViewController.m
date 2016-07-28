//
//  FBSheetViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBSheetViewController.h"
#import "Fiu.h"

@interface FBSheetViewController ()

@end

@implementation FBSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.3];
    [self.view addSubview:self.sheetView];
}

-(UIView *)sheetView{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 1070*0.5/667.0*SCREEN_HEIGHT, SCREEN_WIDTH, 132/667.0*SCREEN_HEIGHT)];
        _sheetView.backgroundColor = [UIColor colorWithHexString:lineGrayColor];
    }
    return _sheetView;
}

-(void)initFBSheetVCWithNameAry:(NSArray *)ary{
    for (int i = 0; i<ary.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 44/667.0*SCREEN_HEIGHT*i, SCREEN_WIDTH, 44/667.0*SCREEN_HEIGHT)];
        [btn setTitle:ary[i] forState:UIControlStateNormal];
        if (IS_iOS9) {
            btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        } else {
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sheetView addSubview:btn];
        
        UIView *linview = [[UIView alloc] init];
        linview.backgroundColor = [UIColor lightGrayColor];
        linview.alpha = 0.5;
        [btn addSubview:linview];
        [linview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
            make.left.mas_equalTo(btn.mas_left).with.offset(0);
            make.bottom.mas_equalTo(btn.mas_bottom).with.offset(0);
        }];
    }
}

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
