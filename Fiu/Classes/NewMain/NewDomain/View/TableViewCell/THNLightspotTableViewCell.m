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
    }
    return self;
}

- (void)thn_setBrightSpotData:(NSArray *)model {
    NSMutableArray *strMarr = [NSMutableArray array];
    
    for (NSString *str in model) {
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
            [strMarr addObject:textStr];
            self.viewHeiight += [self getTextFrameHeight:textStr];
        }
        
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
            [strMarr addObject:imageStr];
            self.viewHeiight += 230;
        }
    }
    
    NSString *totalText = [strMarr componentsJoinedByString:@""] ;
    for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
        NSString *str = self.imageMarr[idx];
        NSInteger location = [totalText rangeOfString:str].location;
        totalText = [totalText stringByReplacingOccurrencesOfString:str withString:@"\n\n\n"];
        [self.imageIndexMarr addObject:[NSString stringWithFormat:@"%zi", location]];
    }
    
    [self thn_crearBrightSpotInfoUI:self.textMarr image:self.imageMarr];
}

- (void)thn_crearBrightSpotInfoUI:(NSMutableArray *)textMarr image:(NSMutableArray *)imageMarr {
    NSString *textStr = [textMarr componentsJoinedByString:@"\n\n"];
    
    [self getAttributedStringWithString:textStr lineSpace:5.0f];
    
    [self addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).with.offset(15);
        make.bottom.right.equalTo(self).with.offset(-15);
    }];
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger idx = 0; idx < self.imageMarr.count; ++ idx) {
            // 插入图片
            THNLightspotTextAttachment *attach = [[THNLightspotTextAttachment alloc] init];
            attach.image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMarr[idx]]]];
            attach.bounds = CGRectMake(0, 0, 15, 15);
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString insertAttributedString:attachString atIndex:[self.imageIndexMarr[idx] integerValue]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.attributedText = attributedString;
        });
    });
}

- (CGFloat)getTextFrameHeight:(NSString *)text {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
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
