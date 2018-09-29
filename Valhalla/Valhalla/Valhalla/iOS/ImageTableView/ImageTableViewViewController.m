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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -image.size.height, self.tableView.plt_width, image.size.height)];
    imageView.tag = kImageViewTag;
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.contentInset = UIEdgeInsetsMake(image.size.height, 0, 0, 0);
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
