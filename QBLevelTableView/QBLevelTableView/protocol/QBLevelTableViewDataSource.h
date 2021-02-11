//
//  QBLevelTableViewDataSource.h
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "QBLevelIndexPath.h"
#import "EXTConcreteProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class QBLevelTableView;

@protocol QBLevelTableViewDataSource <UITableViewDataSource>

@required
/// row的个数
/// @param levelTableView levelTableView
/// @param section section num
/// @return row的个数
- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section NS_UNAVAILABLE;

/// cell
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return cell tableViewCell
- (nonnull UITableViewCell *)levelTableView:(QBLevelTableView *)levelTableView cellAtIndexPath:(QBLevelIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath NS_UNAVAILABLE;

@optional

/// item个数
/// @param levelTableView levelTableView
/// @param row row num
/// @param section section num
/// @return item个数
- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfItemsInRow:(NSInteger)row section:(NSInteger)section;

/// molecularItem个数
/// @param levelTableView levelTableView
/// @param item item num
/// @param row row num
/// @param section section num
/// @return molecularItem个数
- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfMolecularItemsInItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;

/// atomicItem个数
/// @param levelTableView levelTableView
/// @param molecularItem molecularItem num
/// @param item item num
/// @param row row num
/// @param section section num
/// @return atomicItem个数
- (NSInteger)levelTableView:(QBLevelTableView *)levelTableView numberOfAtomicItemsInMolecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;

/// 头部cell-在row item molecularItem 等层级使用cell 实现类型Section的HeaderView类似功能
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return 头部cell
- (nullable UITableViewCell *)levelTableView:(QBLevelTableView *)levelTableView headerCellAtIndexPath:(QBLevelIndexPath *)indexPath;

/// 底部cell-在row item molecularItem 等层级使用cell 实现类型Section的FooterView类似功能
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return 底部cell
- (nullable UITableViewCell *)levelTableView:(QBLevelTableView *)levelTableView footerCellAtIndexPath:(QBLevelIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
