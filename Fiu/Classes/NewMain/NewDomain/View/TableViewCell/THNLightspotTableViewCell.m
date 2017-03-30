//
//  THNLightspotTableViewCell.m
//  Fiu
//
//  Created by FLYang on 2017/2/19.
//  Copyright © 2017年 taihuoniao. All rights reserved.
//

#import "THNLightspotTableViewCell.h"
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "THNLightspotTextAttachment.h"

@interface THNLightspotTableViewCell () {
    CGFloat _imageHeight;
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
    [self.textMarr removeAllObjects];
    [self.imageMarr removeAllObjects];
    
    for (NSString *str in model) {
        if ([str containsString:@"[text]:!"]) {
            NSString *textStr;
            textStr = [str substringFromIndex:8];
            [self.textMarr addObject:textStr];
        }
        
        if ([str containsString:@"[img]:!"]) {
            NSString *imageStr;
            imageStr = [str substringFromIndex:7];
            [self.imageMarr addObject:imageStr];
        }
    }
    
    NSString *textStr = self.textMarr[0];
    NSString *imageStr = self.imageMarr[0];
//    _imageHeight = [self scaleImageSize:imageStr].height;
    
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
        make.width.mas_equalTo(@(SCREEN_WIDTH - 30));
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(_textLable.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.mas_bottom).with.offset(0);
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
    
    CGFloat textHeight = [self getTextFrameHeight:string];
    if (textHeight < 20) {
        textHeight = 20;
    }
    self.textLable.attributedText = attributedString;
    
    self.viewHeiight = textHeight + (SCREEN_WIDTH * 0.56);
    
    [self.textLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
}

- (CGSize)scaleImageSize:(NSString *)imageUrl {
    UIImage *firstImage = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageMarr[0]]]];
    CGFloat imageScale = firstImage.size.width / firstImage.size.height;
    CGFloat imageWidth = SCREEN_WIDTH - 30;
    CGSize imageSize = CGSizeMake(imageWidth, imageWidth / imageScale);
    
    return imageSize;
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
