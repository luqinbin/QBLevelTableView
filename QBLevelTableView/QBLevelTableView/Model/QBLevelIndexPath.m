//
//  QBLevelIndexPath.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/7.
//

#import "QBLevelIndexPath.h"

@implementation QBLevelIndexPath

+ (instancetype)indexPathWithAtomicItem:(NSInteger)atomicItem molecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row  section:(NSInteger)section type:(QBLevelIndexPathType)indexPathType level:(NSInteger)level {
    QBLevelIndexPath *indexPath = [[QBLevelIndexPath alloc]init];
    indexPath.atomicItem = atomicItem;
    indexPath.molecularItem = molecularItem;
    indexPath.item = item;
    indexPath.row = row;
    indexPath.section = section;
    indexPath.indexPathType = indexPathType;
    indexPath.level = level;
    
    return indexPath;
}

- (BOOL)isEqualToLevelIndexPath:(QBLevelIndexPath *)leveIndexPath {
    if (leveIndexPath == self) {
        return YES;
    }
    
    if (self.indexPathType == leveIndexPath.indexPathType) {
        if (self.level == leveIndexPath.level &&
            self.section == leveIndexPath.section &&
            self.row == leveIndexPath.row &&
            self.item == leveIndexPath.item &&
            self.molecularItem == leveIndexPath.molecularItem &&
            self.atomicItem == leveIndexPath.atomicItem) {
            
            return YES;
        }
    }
    
    return NO;
}

@end
