//
//  SortViewController.m
//  Valhalla
//
//  Created by mademao on 2018/8/16.
//  Copyright © 2018年 mademao. All rights reserved.
//

#import "SortViewController.h"
#import "SortTool.h"

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = NSLocalizedString(@"Bubble Sort", nil);
            break;
        }
        case 1: {
            cell.textLabel.text = NSLocalizedString(@"Cocktail Sort", nil);
            break;
        }
        case 2: {
            cell.textLabel.text = NSLocalizedString(@"Selection Sort", nil);
            break;
        }
        case 3: {
            cell.textLabel.text = NSLocalizedString(@"Insertion Sort", nil);
            break;
        }
        case 4: {
            cell.textLabel.text = NSLocalizedString(@"Insertion Sort Dichotomy", nil);
            break;
        }
        case 5: {
            cell.textLabel.text = NSLocalizedString(@"Shell Sort", nil);
            break;
        }
        case 6: {
            cell.textLabel.text = NSLocalizedString(@"Merge Sort Recursion", nil);
            break;
        }
        case 7: {
            cell.textLabel.text = NSLocalizedString(@"Merge Sort Iteration", nil);
            break;
        }
        case 8: {
            cell.textLabel.text = NSLocalizedString(@"Heap Sort", nil);
            break;
        }
        case 9: {
            cell.textLabel.text = NSLocalizedString(@"Quick Sort", nil);
            break;
        }
        default: {
            cell.textLabel.text = @"";
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int number[] = {6, 5, 3, 1, 8, 7, 2, 4};
    int count = sizeof(number) / sizeof(int);
    
    NSMutableString *beforeString = [NSMutableString string];
    
    for (int i = 0; i < count; i++) {
        [beforeString appendString:[NSString stringWithFormat:@"%d ", number[i]]];
    }
    
    switch (indexPath.row) {
        case 0: {
            BubbleSort(number, count);
            break;
        }
        case 1: {
            CocktailSort(number, count);
            break;
        }
        case 2: {
            SelectionSort(number, count);
            break;
        }
        case 3: {
            InsertionSort(number, count);
            break;
        }
        case 4: {
            InsertionSortDichotomy(number, count);
            break;
        }
        case 5: {
            ShellSort(number, count);
            break;
        }
        case 6: {
            MergeSortRecursion(number, 0, count - 1);
            break;
        }
        case 7: {
            MergeSortIteration(number, count);
            break;
        }
        case 8: {
            HeapSort(number, count);
            break;
        }
        case 9: {
            QuickSort(number, 0, count - 1);
            break;
        }
        default: {
            break;
        }
    }
    
    NSMutableString *afterString = [NSMutableString string];
    
    for (int i = 0; i < count; i++) {
        [afterString appendString:[NSString stringWithFormat:@"%d ", number[i]]];
    }
    
    NSString *message = [NSString stringWithFormat:@"%@:\t%@\n%@:\t%@", NSLocalizedString(@"Before", nil), beforeString, NSLocalizedString(@"After", nil), afterString];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Result", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dnoeAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Done", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:dnoeAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
