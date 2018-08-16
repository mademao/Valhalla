//
//  SortViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/16.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "SortViewController.h"

@interface SortViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MDMSectionModel *sectionModel = [self.sectionModelArray objectAtIndex:section];
    return sectionModel.rowModelArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MDMSectionModel *sectionModel = [self.sectionModelArray objectAtIndex:section];
    return sectionModel.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    MDMSectionModel *sectionModel = [self.sectionModelArray objectAtIndex:indexPath.section];
    MDMRowModel *rowModel = [sectionModel.rowModelArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = rowModel.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MDMSectionModel *sectionModel = [self.sectionModelArray objectAtIndex:indexPath.section];
    MDMRowModel *rowModel = [sectionModel.rowModelArray objectAtIndex:indexPath.row];
    
    UIViewController *viewC = [[NSClassFromString(rowModel.viewControllerName) alloc] init];
    if (viewC) {
        viewC.title = rowModel.name;
        [self.navigationController pushViewController:viewC animated:YES];
    }
}

@end
