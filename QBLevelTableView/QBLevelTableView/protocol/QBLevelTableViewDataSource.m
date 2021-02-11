//
//  QBLevelTableViewDataSource.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import "QBLevelTableViewDataSource.h"
#import "QBLevelTableView.h"
#import "QBLevelNode.h"

@concreteprotocol(QBLevelTableViewDataSource)

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QBLevelTableView *levelTableView = (QBLevelTableView *)tableView;
    NSMutableDictionary<NSString *, NSMutableArray<QBLevelNode *> *> *allCellNodesMap = [levelTableView valueForKey:@"allCellNodesMap"];
    
    return allCellNodesMap[@(section).stringValue].count;
}

- (NSInteger)levelTableView:(nonnull QBLevelTableView *)levelTableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(QBLevelTableView *)levelTableView numberOfItemsInRow:(NSInteger)row section:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(QBLevelTableView *)levelTableView numberOfMolecularItemsInItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return 0;
}

- (NSInteger)tableView:(QBLevelTableView *)levelTableView numberOfAtomicItemsInMolecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    return 0;
}

- (nonnull UITableViewCell *)levelTableView:(nonnull QBLevelTableView *)levelTableView cellAtIndexPath:(nonnull QBLevelIndexPath *)indexPath {
    return [[UITableViewCell alloc]init];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QBLevelTableView *levelTableView = (QBLevelTableView *)tableView;
    UITableViewCell *cell;
    QBLevelIndexPath *levelIndexPath = [levelTableView transformIndexPathToLevelIndexPath:indexPath];
    
    switch (levelIndexPath.indexPathType) {
        case QBLevelIndexPathTypeRow:
        case QBLevelIndexPathTypeItem:
        case QBLevelIndexPathTypeMolecularItem:
        case QBLevelIndexPathTypeAtomicItem:
        {
            CGFloat rowHeight = 0.0f;
            if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:heightForCellAtIndexPath:)]) {
                rowHeight = [levelTableView.qbDelegate levelTableView:levelTableView heightForCellAtIndexPath:levelIndexPath];
            }
            if (rowHeight != 0) {
                if (levelTableView.qbDataSource && [levelTableView.qbDataSource respondsToSelector:@selector(levelTableView:cellAtIndexPath:)]) {
                    cell = [levelTableView.qbDataSource levelTableView:levelTableView cellAtIndexPath:levelIndexPath];
                }
            }
        }
            break;
            
        case QBLevelIndexPathTypeMolecularItemHeader:
        case QBLevelIndexPathTypeItemHeader:
        case QBLevelIndexPathTypeRowHeader:
        {
            if (levelTableView.qbDataSource && [levelTableView.qbDataSource respondsToSelector:@selector(levelTableView:headerCellAtIndexPath:)]) {
                cell = [levelTableView.qbDataSource levelTableView:levelTableView headerCellAtIndexPath:levelIndexPath];
            }
        }
            break;
        case QBLevelIndexPathTypeMolecularItemFooter:
        case QBLevelIndexPathTypeItemFooter:
        case QBLevelIndexPathTypeRowFooter:
        {
            if (levelTableView.qbDataSource && [levelTableView.qbDataSource respondsToSelector:@selector(levelTableView:footerCellAtIndexPath:)]) {
                cell = [levelTableView.qbDataSource levelTableView:levelTableView footerCellAtIndexPath:levelIndexPath];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:nullCellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
