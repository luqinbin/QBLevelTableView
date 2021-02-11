//
//  QBLevelTableViewDelegate.h
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "QBLevelIndexPath.h"
#import <libextobjc/EXTConcreteProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@class QBLevelTableView;

@protocol QBLevelTableViewDelegate <UITableViewDelegate>

@optional

#pragma mark - Height
/// cell高度
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return cell高度
- (CGFloat)levelTableView:(QBLevelTableView *)levelTableView heightForCellAtIndexPath:(QBLevelIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath NS_UNAVAILABLE;

/// row item molecularItem 等层级HeaderCell
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return row item molecularItem 等层级HeaderCell
- (CGFloat)levelTableView:(QBLevelTableView *)levelTableView heightForHeaderCellAtIndexPath:(QBLevelIndexPath *)indexPath;

/// row item molecularItem 等层级FooterCell
/// @param levelTableView levelTableView
/// @param indexPath 索引
/// @return row item molecularItem 等层级FooterCell
- (CGFloat)levelTableView:(QBLevelTableView *)levelTableView heightForFooterCellAtIndexPath:(QBLevelIndexPath *)indexPath;

#pragma mark - fold/unFold
/// 展开/折叠rows
/// @param levelTableView levelTableView
/// @param section section
/// @return 是否折叠
- (BOOL)levelTableView:(QBLevelTableView *)levelTableView foldRowsInsection:(NSInteger)section;

/// 展开/折叠items
/// @param levelTableView levelTableView
/// @param row row
/// @param section section
/// @return 是否折叠
- (BOOL)levelTableView:(QBLevelTableView *)levelTableView foldItemsInRow:(NSInteger)row section:(NSInteger)section;

/// 展开/折叠molecularItems
/// @param levelTableView levelTableView
/// /// @param item item
/// @param row row
/// @param section section
/// @return 是否折叠
- (BOOL)levelTableView:(QBLevelTableView *)levelTableView foldMolecularItemsInItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;

/// 展开/折叠atomicItems
/// @param levelTableView levelTableView
///  @param molecularItem molecularItem
/// @param item item
/// @param row row
/// @param section section
/// @return 是否折叠
- (BOOL)levelTableView:(QBLevelTableView *)levelTableView foldAtomicItemsInMolecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
