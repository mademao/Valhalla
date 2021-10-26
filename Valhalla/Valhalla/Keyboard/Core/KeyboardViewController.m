//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by mademao on 2021/7/28.
//  Copyright © 2021 mademao. All rights reserved.
//

#import "KeyboardViewController.h"
#import "MDMSectionModel.h"
#import "KeyboardBaseView.h"
#import "KbdConfig+ForKVC.h"

@interface KeyboardViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@property (nonatomic, strong) NSMutableArray<MDMSectionModel *> *sectionModelArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Perform custom UI setup here
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
    [self.nextKeyboardButton sizeToFit];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    [self.view addSubview:self.nextKeyboardButton];
    
    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    [self createSectionArray];
    
    [self setupUI];
    
    [self.view bringSubviewToFront:self.nextKeyboardButton];
    
    [KbdConfig sharedInstance].hasFullAccess = self.hasFullAccess;
}

- (void)viewWillLayoutSubviews
{
    if (@available(iOS 11.0, *)) {
        self.nextKeyboardButton.hidden = !self.needsInputModeSwitchKey;
    }
    [super viewWillLayoutSubviews];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)createSectionArray {
    MDMSectionModel *sectionModel = nil;
    MDMRowModel *rowModel = nil;
    
    //iOS
    sectionModel = [[MDMSectionModel alloc] init];
    sectionModel.name = NSLocalizedString(@"Common", nil);
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"mmap", nil);
    rowModel.viewControllerName = @"MMapView";
    [sectionModel.rowModelArray addObject:rowModel];
    
    rowModel = [[MDMRowModel alloc] init];
    rowModel.name = NSLocalizedString(@"MMKV", nil);
    rowModel.viewControllerName = @"MMKVView";
    [sectionModel.rowModelArray addObject:rowModel];
    
    [self.sectionModelArray addObject:sectionModel];
}

- (void)setupUI {
    self.tableView = [[UITableView alloc] initWithFrame:self.inputView.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    
    KeyboardBaseView *baseView = [[NSClassFromString(rowModel.viewControllerName) alloc] initWithFrame:self.view.bounds title:rowModel.name];
    if (baseView) {
        [self.view addSubview:baseView];
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
