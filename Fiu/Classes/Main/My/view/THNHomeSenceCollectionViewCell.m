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
    [self titleTextStyle:[NSString stringWithFormat:@"  %@ ",strUrl]];
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:[UIImage imageNamed:@"Defaul_Bg_500"]];
}

//  标题文字的样式
- (void)titleTextStyle:(NSString *)title {
    
    if (title.length <= 13) {
        NSString *a = [title substringWithRange:NSMakeRange(0, title.length)];
        self.titleLabel.text = a;
    }else if (title.length > 13){
        NSString *a = [title substringWithRange:NSMakeRange(0, 12)];
        NSString *b = [NSString stringWithFormat:@"%@ ",a];
        self.titleTwoLabel.text = b;
        NSString *c = [title substringWithRange:NSMakeRange(12, title.length - 12)];
        NSString *d = [NSString stringWithFormat:@"  %@",c];
        self.titleLabel.text = d;
    }
    
}

@end
