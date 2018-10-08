//
//  MDMRootViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/10.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "MDMRootViewController.h"
#import "MDMSectionModel.h"

@interface MDMRootViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<MDMSectionModel *> *sectionModelArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MDMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Main List", nil);
    
    [self createSectionArray];
    
    [self setupUI];
}

- (void)createSectionArray {
    MDMSectionModel *sectionModel = nil;
    MDMRowModel *rowModel = nil;
    
    //iOS
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"iOS", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Keychain", nil);
    rowModel.viewControllerName = @"KeychainViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Store Review", nil);
    rowModel.viewControllerName = @"StoreReviewViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Digit ScrollView", nil);
    rowModel.viewControllerName = @"DigitScrollViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Form TableView", nil);
    rowModel.viewControllerName = @"FormTableViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"TableView Cell Extension", nil);
    rowModel.viewControllerName = @"TableViewCellExtensionViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Image TableView", nil);
    rowModel.viewControllerName = @"ImageTableViewViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Pick Up Color", nil);
    rowModel.viewControllerName = @"PickUpColorViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Create QR Code", nil);
    rowModel.viewControllerName = @"CreateQRCodeViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Create PDF", nil);
    rowModel.viewControllerName = @"CreatePDFViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Video Player", nil);
    rowModel.viewControllerName = @"VideoPlayerViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
    
    //CollectionViewFlowLayout
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"CollectionViewFlowLayout", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Left Justify Layout", nil);
    rowModel.viewControllerName = @"LeftJustifyLayoutViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Waterflow Layout", nil);
    rowModel.viewControllerName = @"WaterflowLayoutViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Cyclic Card Layout", nil);
    rowModel.viewControllerName = @"CyclicCardLayoutViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
    
    //Image and Graphics
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"Image and Graphics", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"GIF Speed", nil);
    rowModel.viewControllerName = @"GIFSpeedViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Image Orientation", nil);
    rowModel.viewControllerName = @"ImageOrientationViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
    
    //Algorithm
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"Algorithm", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Sort", nil);
    rowModel.viewControllerName = @"SortViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
    
    //Objective-C
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"Objective-C", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Message Forwarding", nil);
    rowModel.viewControllerName = @"MessageForwardingViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
    
    //Animation
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"Animation", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Glutinous View", nil);
    rowModel.viewControllerName = @"GlutinousViewViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Turn Around Button", nil);
    rowModel.viewControllerName = @"TurnAroundButtonViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Navigation Animation", nil);
    rowModel.viewControllerName = @"NavigationAnimationViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"Point to Screen Transtion", nil);
    rowModel.viewControllerName = @"PointToScreenTranstionViewController";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
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


#pragma mark - lazy load

- (NSMutableArray<MDMSectionModel *> *)sectionModelArray {
    if (!_sectionModelArray) {
        _sectionModelArray = [NSMutableArray array];
    }
    return _sectionModelArray;
}

@end
