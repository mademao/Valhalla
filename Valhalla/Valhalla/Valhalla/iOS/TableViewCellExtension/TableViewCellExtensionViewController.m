//
//  TableViewCellExtensionViewController.m
//  Valhalla
//
//  Created by mademao on 2018/9/26.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "TableViewCellExtensionViewController.h"
#import "TableViewCellExtensionHeaderView.h"

@interface TableViewCellExtensionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation TableViewCellExtensionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[self.listArray objectAtIndex:section] objectForKey:@"flag"] isEqualToString:@"NO"]) {
        return 0;
    } else {
        return [[[self.listArray objectAtIndex:section] objectForKey:@"city"] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableViewCellExtensionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TableViewCellExtensionHeaderView class])];
    view.label.text = [[self.listArray objectAtIndex:section] objectForKey:@"name"];
    view.tag = section;
    
    if (view.gestureRecognizers == nil) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewClicked:)];
        [view addGestureRecognizer:tap];
    }
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell plt_cellReuseIdentifier] forIndexPath:indexPath];
    cell.textLabel.text = [[[[self.listArray objectAtIndex:indexPath.section] objectForKey:@"city"] objectAtIndex:indexPath.row] objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [[[[self.listArray objectAtIndex:indexPath.section] objectForKey:@"city"] objectAtIndex:indexPath.row] objectForKey:@"name"]);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)headerViewClicked:(UITapGestureRecognizer *)sender {
    if ([[[self.listArray objectAtIndex:sender.view.tag] objectForKey:@"flag"] isEqualToString:@"NO"]) {
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"YES" forKey:@"flag"];
    } else {
        [[self.listArray objectAtIndex:sender.view.tag] setObject:@"NO" forKey:@"flag"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sender.view.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark - lazy load

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:PltScreenBounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell plt_cellReuseIdentifier]];
        [_tableView registerClass:[TableViewCellExtensionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TableViewCellExtensionHeaderView class])];
    }
    return _tableView;
}

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *pathString = [bundle pathForResource:@"list" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:pathString];
        NSArray *rootArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary *dic in rootArray) {
            NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dicc setObject:@"NO" forKey:@"flag"];
            [_listArray addObject:dicc];
        }
    }
    return _listArray;
}

@end
