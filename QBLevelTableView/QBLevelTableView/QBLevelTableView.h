//
//  QBLevelTableView.h
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import <UIKit/UIKit.h>
#import "QBLevelIndexPath.h"
#import "QBLevelTableViewDataSource.h"
#import "QBLevelTableViewDelegate.h"

static NSString * _Nonnull const nullCellIdentifier = @"nullCellId";

NS_ASSUME_NONNULL_BEGIN

@interface QBLevelTableView : UITableView

@property (nonatomic, weak, nullable) id <QBLevelTableViewDataSource> qbDataSource;
@property (nonatomic, weak, nullable) id <QBLevelTableViewDelegate> qbDelegate;

#pragma mark IndexPath转化
/// 将levelIndexPath转化为标准的NSIndexPath
/// @param levelIndexPath levelIndexPath
/// @return NSIndexPath
- (NSIndexPath *)transformLevelIndexPathToIndexPath:(QBLevelIndexPath *)levelIndexPath;

/// 将NSIndexPath转化为levelIndexPath
/// @param indexPath indexPath
/// @return levelIndexPath
- (QBLevelIndexPath *)transformIndexPathToLevelIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
