//
//  THNActiveRuleViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/8/22.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNActiveRuleViewController.h"
#import "FBAPI.h"
#import "FBRequest.h"
#import <SVProgressHUD.h>
#import "UIView+FSExtension.h"
#import "UIColor+Extension.h"
#import <Masonry.h>

@interface THNActiveRuleViewController ()

/**  */
@property(nonatomic,copy) NSString *summary;
/**  */
@property (nonatomic, strong) UIScrollView *contentView;
/**  */
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation THNActiveRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view insertSubview:self.contentView atIndex:0];
    
    FBRequest *request = [FBAPI postWithUrlString:@"/scene_subject/view" requestDictionary:@{
                                                                                             @"id" : self.id
                                                                                             } delegate:self];
    [request startRequestSuccess:^(FBRequest *request, id result) {
        if (result[@"success"]) {
            self.textLabel.text = result[@"data"][@"summary"];
            [self.contentView addSubview:self.textLabel];
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView.mas_top).offset(10);
                make.left.mas_equalTo(self.contentView.mas_left).offset(10);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            }];
            _contentView.contentSize = CGSizeMake(0, self.textLabel.height);
        }else{
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
        }
    } failure:nil];
}

-(UIScrollView *)contentView{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _contentView.showsVerticalScrollIndicator = NO;
    }
    return _contentView;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor colorWithHexString:@"#676767"];
        _textLabel.numberOfLines = 0;
    }
    return _textLabel;
}

@end
