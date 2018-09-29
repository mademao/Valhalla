//
//  ImageTableViewViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/29.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "ImageTableViewViewController.h"

static const NSInteger kImageViewTag = 11111;

@interface ImageTableViewViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ImageTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    UIImage *image = [UIImage imageNamed:@"Valhalla"];
    CGFloat imageHeight = self.tableView.plt_width / image.size.width * image.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -imageHeight, self.tableView.plt_width, imageHeight)];
    imageView.tag = kImageViewTag;
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.contentInset = UIEdgeInsetsMake(imageHeight, 0, 0, 0);
    [self.tableView addSubview:imageView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell plt_cellReuseIdentifier] forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld--%ld", indexPath.section, indexPath.row];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.y < -scrollView.contentInset.top) {
        CGRect rect = [self.tableView viewWithTag:kImageViewTag].frame;
        rect.origin.y = point.y;
        rect.size.height = -point.y;
        [self.tableView viewWithTag:kImageViewTag].frame = rect;
    }
}


#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:PltScreenBounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell plt_cellReuseIdentifier]];
    }
    return _tableView;
}

@end
