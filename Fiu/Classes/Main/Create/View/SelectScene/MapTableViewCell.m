//
//  MapTableViewCell.m
//  Fiu
//
//  Created by THN-Dong on 16/5/9.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MapTableViewCell.h"
#import "Fiu.h"

@interface MapTableViewCell ()<BMKMapViewDelegate>

@end


@implementation MapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUIWithAry:(NSArray *)ary{
    
    for (NSDictionary *logDict in ary) {
        NSArray *logAry = logDict[@"coordinates"];
        double la = [logAry[1] doubleValue];
        double lo = [logAry[0] doubleValue];
        // 添加一个PointAnnotation
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = la;
        coor.longitude = lo;
        annotation.coordinate = coor;
        [self.mapView addAnnotation:annotation];
    }
    
}

// BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        [newAnnotationView setSelected:YES animated:YES];
        return newAnnotationView;
    }
    return nil;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.mapView];
        [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 145));
            make.left.mas_equalTo(self.mas_left).with.offset(0);
            make.bottom.mas_equalTo(self.mas_bottom).with.offset(0);
        }];
        
        
        
    }
    return self;
}

-(void)setAry:(NSArray *)ary{
    _ary = ary;
    NSDictionary *logDict = ary[0];
    NSArray *logAry = logDict[@"coordinates"];
    double la = [logAry[1] doubleValue];
    double lo = [logAry[0] doubleValue];
    //_mapView.limitMapRegion = ;
}

-(BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
        _mapView.backgroundColor = [UIColor redColor];
        _mapView.gesturesEnabled = NO;
        _mapView.zoomLevel = 17;
    }
    return _mapView;
}

-(void)dealloc{
    _mapView.delegate = nil;
}

@end
