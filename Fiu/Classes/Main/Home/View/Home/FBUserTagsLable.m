//
//  FBUserTagsLable.m
//  Fiu
//
//  Created by FLYang on 16/6/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBUserTagsLable.h"

@implementation FBUserTagsLable

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (IS_iOS9) {
            self.font = [UIFont fontWithName:@"PingFangSC-Light" size:10];
        } else {
            self.font = [UIFont systemFontOfSize:10];
        }
        self.textAlignment = NSTextAlignmentCenter;
//        self.layer.cornerRadius = 3;
//        self.layer.masksToBounds = YES;
//        self.layer.borderWidth = 0.5f;
//        [self setUserTagColor];
    }
    return self;
}

//- (void)setUserTagInfo:(NSString *)info {
//    self.text = info;
//    NSArray * tags = @[@"大拿",@"行家",@"行摄家",@"艺术范",@"手艺人",@"人来疯",@"赎回自由身",@"职业buyer"];
//    if ([info isEqualToString:tags[0]]) {
//        self.colorType = Color_DaNa;
//    } else if ([info isEqualToString:tags[1]]) {
//        self.colorType = Color_HangJia;
//    } else if ([info isEqualToString:tags[2]]) {
//        self.colorType = Color_XingSheJia;
//    } else if ([info isEqualToString:tags[3]]) {
//        self.colorType = Color_YiShuFan;
//    } else if ([info isEqualToString:tags[4]]) {
//        self.colorType = Color_ShouYiRen;
//    } else if ([info isEqualToString:tags[5]]) {
//        self.colorType = Color_RenLaiFeng;
//    } else if ([info isEqualToString:tags[6]]) {
//        self.colorType = Color_ShuHui;
//    } else if ([info isEqualToString:tags[7]]) {
//        self.colorType = Color_ZhiYeBuyer;
//    }
//}

//- (void)setUserTagColor {
//    switch (self.colorType) {
//        case Color_DaNa: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#E51C23"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#E51C23"];
//        }
//            break;
//        case Color_HangJia: {
//                self.layer.borderColor = [UIColor colorWithHexString:@"#E91E63"].CGColor;
//                self.textColor = [UIColor colorWithHexString:@"#E91E63"];
//            }
//            break;
//        case Color_XingSheJia: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#9C27B0"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#9C27B0"];
//        }
//            break;
//        case Color_YiShuFan: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#673AB7"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#673AB7"];
//        }
//            break;
//        case Color_ShouYiRen: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#3F51B5"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#3F51B5"];
//        }
//            break;
//        case Color_RenLaiFeng: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#00BCD4"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#00BCD4"];
//        }
//            break;
//        case Color_ZhiYeBuyer: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#FF5722"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#FF5722"];
//        }
//            break;
//        case Color_ShuHui: {
//            self.layer.borderColor = [UIColor colorWithHexString:@"#FF9800"].CGColor;
//            self.textColor = [UIColor colorWithHexString:@"#FF9800"];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

@end
