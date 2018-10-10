//
//  ImageOrientationViewController.m
//  Valhalla
//
//  Created by mademao on 2018/10/8.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "ImageOrientationViewController.h"
#import "ImageOrientationDetailViewController.h"

@interface ImageOrientationViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ImageOrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationUp", nil);
            break;
        }
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationDown", nil);
            break;
        }
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationLeft", nil);
            break;
        }
        case 3: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationRight", nil);
            break;
        }
        case 4: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationUpMirrored", nil);
            break;
        }
        case 5: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationDownMirrored", nil);
            break;
        }
        case 6: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationLeftMirrored", nil);
            break;
        }
        case 7: {
            cell.textLabel.text = NSLocalizedString(@"UIImageOrientationRightMirrored", nil);
            break;
        }
        default: {
            cell.textLabel.text = @"";
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ImageOrientationDetailViewController *viewController = [[ImageOrientationDetailViewController alloc] initWithImageOrientation:indexPath.row];
    viewController.title = cell.textLabel.text;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - lazy load

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    return _tableView;
}

@end
