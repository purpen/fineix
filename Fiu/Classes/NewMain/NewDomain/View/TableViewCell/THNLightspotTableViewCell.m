//
//  THNLightspotTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNLightspotTableViewCell.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import "THNLightspotTextAttachment.h"

@interface THNLightspotTableViewCell () {

}

@end

@implementation THNLightspotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.viewHeiight = 0.0f;
        
        [self setCellUI];
    }
    return self;
}

- (void)thn_setBrightSpotData:(NSArray *)model {
//    NSMutableArray *strMarr = [NSMutableArray array];
    
    for (NSString *str in model) {
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
//            [strMarr addObject:textStr];
//            self.viewHeiight += [self getTextFrameHeight:textStr];
        }
        
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
//            [strMarr addObject:imageStr];
//            self.viewHeiight += SCREEN_WIDTH *0.58 + 10;
        }
    }
    
    NSString *textStr = self.textMarr[0];
    NSString *imageStr = self.imageMarr[0];
//
//    NSString *totalText = [strMarr componentsJoinedByString:@""] ;
//    for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
//        NSString *str = self.imageMarr[idx];
//        NSInteger location = [totalText rangeOfString:str].location;
//        totalText = [totalText stringByReplacingOccurrencesOfString:str withString:@"\n\n"];
//        [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", location]];
//    }
//
    
//    [self thn_crearBrightSpotInfoUI:self.textMarr image:self.imageMarr];
    
    [self.textImage downloadImage:imageStr place:[UIImage imageNamed:@""]];
    [self getAttributedStringWithString:textStr lineSpace:5.0];
}

- (void)setCellUI {
    [self addSubview:self.textLable];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.height.mas_equalTo(@20);
    }];
    
    [self addSubview:self.textImage];
    [_textImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30) * 0.56));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_textLable.mas_bottom).with.offset(10);
    }];
}

- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] init];
        _textLable.numberOfLines = 0;
    }
    return _textLable;
}

- (UIImageView *)textImage {
    if (!_textImage) {
        _textImage = [[UIImageView alloc] init];
    }
    return _textImage;
}

- (void)thn_crearBrightSpotInfoUI:(NSMutableArray *)textMarr image:(NSMutableArray *)imageMarr {
    NSString *textStr = [textMarr componentsJoinedByString:@"\n"];
    
    [self getAttributedStringWithString:textStr lineSpace:5.0f];
    
    [self addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-15);
    }];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        _textView.backgroundColor = [UIColor whiteColor];
    }
    return _textView;
}

- (void)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = lineSpace;
    
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
//            // 插入图片
//            THNLightspotTextAttachment *attach = [[THNLightspotTextAttachment alloc] init];
//            attach.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMarr[idx]]]];
//            attach.bounds = CGRectMake(0, 0, 15, 15);
//            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
//            [attributedString insertAttributedString:attachString atIndex:[self.imageIndexMarr[idx] integerValue]];
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.textView.attributedText = attributedString;
//        });
//    });
    
    CGFloat textHeight = [self getTextFrameHeight:string];
    if (textHeight < 20) {
        textHeight = 20;
    }
    self.textLable.attributedText = attributedString;
    [self.textLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
    
    self.viewHeiight = textHeight + (SCREEN_WIDTH - 30) * 0.56 + 10;
}

- (CGFloat)getTextFrameHeight:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5.0;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
    
    CGFloat textHeight = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 0)
                                         options:\
                       NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading |
                       NSStringDrawingUsesDeviceMetrics
                                      attributes:attribute
                                         context:nil].size.height;
    return textHeight;
}

- (NSMutableArray *)textMarr {
    if (!_textMarr) {
        _textMarr = [NSMutableArray array];
    }
    return _textMarr;
}

- (NSMutableArray *)imageMarr {
    if (!_imageMarr) {
        _imageMarr = [NSMutableArray array];
    }
    return _imageMarr;
}

- (NSMutableArray *)imageIndexMarr {
    if (!_imageIndexMarr) {
        _imageIndexMarr = [NSMutableArray array];
    }
    return _imageIndexMarr;
}

@end
