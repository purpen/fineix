//
//  PhotoAlbumsView.m
//  fineix
//
//  Created by FLYang on 16/3/14.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PhotoAlbumsView.h"
#import "PhotoAlbumsTableViewCell.h"

@implementation PhotoAlbumsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photoAlbums = [NSMutableArray array];
        
        //  from "PictureView.m"
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoAlbums:) name:@"photoAlbums" object:nil];
        
    }
    return self;
}

- (void)getPhotoAlbums:(NSNotification *)photoAlbums {
    self.photoAlbums = [photoAlbums object];
    [self addSubview:self.photoAlbumsTableView];
}

#pragma mark - 相册列表
- (UITableView *)photoAlbumsTableView {
    if (!_photoAlbumsTableView) {
        _photoAlbumsTableView = [[UITableView alloc] initWithFrame:self.bounds];
        _photoAlbumsTableView.delegate = self;
        _photoAlbumsTableView.dataSource = self;
        _photoAlbumsTableView.backgroundColor = [UIColor blackColor];
        
        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        footView.backgroundColor = [UIColor blackColor];
        _photoAlbumsTableView.tableFooterView = footView;
        
    }
    return _photoAlbumsTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photoAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"PhotoAlbumsTableViewCell";
    PhotoAlbumsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[PhotoAlbumsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    [cell setPhotoAlbumsData:self.photoAlbums[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"=====打开相册 %zi", indexPath.row);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photoAlbums" object:nil];
}


@end
