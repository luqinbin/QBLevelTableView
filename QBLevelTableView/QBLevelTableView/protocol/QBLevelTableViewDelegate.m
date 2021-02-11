//
//  QBLevelTableViewDelegate.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import "QBLevelTableViewDelegate.h"
#import "QBLevelTableView.h"
#import "QBLevelNode.h"

@concreteprotocol(QBLevelTableViewDelegate)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QBLevelTableView *levelTableView = (QBLevelTableView *)tableView;
    CGFloat rowHeight = 0.0f;
    QBLevelIndexPath *levelIndexPath = [levelTableView transformIndexPathToLevelIndexPath:indexPath];
    
    if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:foldRowsInsection:)]) {
        BOOL fold = [levelTableView.qbDelegate levelTableView:levelTableView foldRowsInsection:levelIndexPath.section];
        if (fold) {
            return 0.0f;
        }
    }
    
    if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:foldItemsInRow:section:)]) {
        BOOL fold = [levelTableView.qbDelegate levelTableView:levelTableView foldItemsInRow:levelIndexPath.row section:levelIndexPath.section];
        if (fold && levelIndexPath.level > 1) {
            return 0.0f;
        }
    }
    
    if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:foldMolecularItemsInItem:row:section:)]) {
        BOOL fold = [levelTableView.qbDelegate levelTableView:levelTableView foldMolecularItemsInItem:levelIndexPath.item row:levelIndexPath.row section:levelIndexPath.section];
        if (fold && levelIndexPath.level > 2) {
            return 0.0f;
        }
    }
    
    if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:foldAtomicItemsInMolecularItem:item:row:section:)]) {
        BOOL fold = [levelTableView.qbDelegate levelTableView:levelTableView foldAtomicItemsInMolecularItem:levelIndexPath.molecularItem item:levelIndexPath.item row:levelIndexPath.row section:levelIndexPath.section];
        if (fold && levelIndexPath.level > 3) {
            return 0.0f;
        }
    }
    
    switch (levelIndexPath.indexPathType) {
        case QBLevelIndexPathTypeRow:
        case QBLevelIndexPathTypeItem:
        case QBLevelIndexPathTypeMolecularItem:
        case QBLevelIndexPathTypeAtomicItem:
        {
            if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:heightForCellAtIndexPath:)]) {
                rowHeight = [levelTableView.qbDelegate levelTableView:levelTableView heightForCellAtIndexPath:levelIndexPath];
            }
        }
            break;
            
        case QBLevelIndexPathTypeMolecularItemHeader:
        case QBLevelIndexPathTypeItemHeader:
        case QBLevelIndexPathTypeRowHeader:
        {
            if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:heightForHeaderCellAtIndexPath:)]) {
                rowHeight = [levelTableView.qbDelegate levelTableView:levelTableView heightForHeaderCellAtIndexPath:levelIndexPath];
            }
        }
            break;
        case QBLevelIndexPathTypeMolecularItemFooter:
        case QBLevelIndexPathTypeItemFooter:
        case QBLevelIndexPathTypeRowFooter:
        {
            if (levelTableView.qbDelegate && [levelTableView.qbDelegate respondsToSelector:@selector(levelTableView:heightForFooterCellAtIndexPath:)]) {
                rowHeight = [levelTableView.qbDelegate levelTableView:levelTableView heightForFooterCellAtIndexPath:levelIndexPath];
            }
        }
            break;
            
        default:
            break;
    }
    
    return rowHeight;
}



@end
