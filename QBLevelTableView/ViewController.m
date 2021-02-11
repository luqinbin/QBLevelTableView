//
//  ViewController.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import "ViewController.h"
#import "QBLevelTableView.h"

NSString *cellKey = @"test";

@interface ViewController () <QBLevelTableViewDataSource, QBLevelTableViewDelegate>

@property (strong, nonatomic) QBLevelTableView *levelTableView;
@property (assign, nonatomic) BOOL fold;
@property (strong, nonatomic) UIButton *bt;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wprotocol"
@implementation ViewController
#pragma clang diagnostic pop

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
    
}

#pragma mark - QBLevelTableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfItemsInRow:(NSInteger)row section:(NSInteger)section {
    return 3;
}

- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfMolecularItemsInItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return 2;
}

- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfAtomicItemsInMolecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return 1;
}

- (nullable UITableViewCell *)levelTableView:(QBLevelTableView *)levelTableView headerCellAtIndexPath:(QBLevelIndexPath *)indexPath {
    if (indexPath.level > 1) {
        return nil;
    }
    
    NSIndexPath *originIndexPath = [levelTableView transformLevelIndexPathToIndexPath:indexPath];
    UITableViewCell *cell = [levelTableView dequeueReusableCellWithIdentifier:cellKey forIndexPath:originIndexPath];
    
    cell.textLabel.text = @(indexPath.indexPathType).stringValue;
    cell.backgroundColor = UIColor.grayColor;
    
    return cell;
}

- (nonnull UITableViewCell *)levelTableView:(QBLevelTableView *)levelTableView cellAtIndexPath:(QBLevelIndexPath *)indexPath {
    NSIndexPath *originIndexPath = [levelTableView transformLevelIndexPathToIndexPath:indexPath];
    UITableViewCell *cell = [levelTableView dequeueReusableCellWithIdentifier:cellKey forIndexPath:originIndexPath];
    
    cell.textLabel.text = @(indexPath.indexPathType).stringValue;
    cell.backgroundColor = UIColor.whiteColor;
    
    return cell;
}

#pragma mark - QBLevelTableViewDelegate
- (CGFloat)levelTableView:(QBLevelTableView *)levelTableView heightForCellAtIndexPath:(QBLevelIndexPath *)indexPath {
    switch (indexPath.indexPathType) {
        case QBLevelIndexPathTypeRow:
            return 80.f;
        case QBLevelIndexPathTypeItem:
            return 60.f;
        case QBLevelIndexPathTypeMolecularItem:
            return 40.f;
        case QBLevelIndexPathTypeAtomicItem:
            return 30.f;
        default:
            return 20.f;
    }
}

- (CGFloat)levelTableView:(QBLevelTableView *)levelTableView heightForHeaderCellAtIndexPath:(QBLevelIndexPath *)indexPath {
    if (indexPath.level > 1) {
        return 0.f;
    }
    
    return 25.f;
}

- (BOOL)levelTableView:(QBLevelTableView *)levelTableView foldItemsInRow:(NSInteger)row section:(NSInteger)section {
    if (row == 1) {
        return NO;
    }
    return self.fold;
}

#pragma mark - Init
- (void)initSubviews {
    self.levelTableView = [[QBLevelTableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.levelTableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    self.levelTableView.qbDataSource = self;
    self.levelTableView.qbDelegate = self;
    [self.view addSubview:self.levelTableView];
    self.levelTableView.backgroundColor = UIColor.yellowColor;
    
    [self.levelTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellKey];
    
    self.bt = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.bt.frame = CGRectMake(200, 100, 50, 50);
    [self.view addSubview:self.bt];
    [self.bt addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
    self.fold = !self.fold;
    [self.levelTableView reloadData];
}

#pragma mark - Layout
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}


@end
