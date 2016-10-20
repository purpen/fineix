//
//  THNHomeSenceCollectionViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/8/24.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNHomeSenceCollectionViewCell.h"
#import "HomeSceneListRow.h"
#import <UIImageView+WebCache.h>
#import "UIView+FSExtension.h"

@interface THNHomeSenceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation THNHomeSenceCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HomeSceneListRow *)model{
    _model = model;
    NSString *strUrl = [model.title stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self titleTextStyle:strUrl];
    self.bgImageView.alpha = 0.0f;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:.5 animations:^{
            self.bgImageView.alpha = 1.0f;
        }];
    }];
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    
    if (title.length == 0) {
        self.titleLabel.text = @"";
        self.titleTwoLabel.text = @"";
        return;
    }
    
    NSString *str = [NSString stringWithFormat:@"  %@ ",title];
    
    
    if (str.length <= 13) {
        NSString *a = [str substringWithRange:NSMakeRange(0, str.length)];
        self.titleLabel.text = a;
        self.titleTwoLabel.text = @"";
    }else if (str.length > 13){
        NSString *a = [str substringWithRange:NSMakeRange(0, 12)];
        NSString *b = [NSString stringWithFormat:@"%@ ",a];
        self.titleTwoLabel.text = b;
        NSString *c = [str substringWithRange:NSMakeRange(12, str.length - 12)];
        NSString *d = [NSString stringWithFormat:@"  %@",c];
        self.titleLabel.text = d;
    }
    
}

@end
