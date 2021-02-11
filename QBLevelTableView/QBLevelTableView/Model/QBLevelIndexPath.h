//
//  QBLevelIndexPath.h
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 索引类型
typedef NS_ENUM(NSInteger, QBLevelIndexPathType) {
    QBLevelIndexPathTypeRow = 0,
    QBLevelIndexPathTypeItem,
    QBLevelIndexPathTypeMolecularItem,
    QBLevelIndexPathTypeAtomicItem,
    QBLevelIndexPathTypeRowHeader,
    QBLevelIndexPathTypeItemHeader,
    QBLevelIndexPathTypeMolecularItemHeader,
    QBLevelIndexPathTypeRowFooter,
    QBLevelIndexPathTypeItemFooter,
    QBLevelIndexPathTypeMolecularItemFooter,
};

@interface QBLevelIndexPath : NSObject

// indexPath 索引类型
@property (assign, nonatomic) QBLevelIndexPathType indexPathType;
// 0级
@property (assign, nonatomic) NSInteger section;
// 1级
@property (assign, nonatomic) NSInteger row;
// 2级
@property (assign, nonatomic) NSInteger item;
// 3级
@property(assign,nonatomic) NSInteger molecularItem;
// 4级
@property(assign, nonatomic) NSInteger atomicItem;
// 层级
@property (nonatomic, assign) NSInteger level;

/**
 MCLevelIndexPath
 
 @param atomicItem          4级
 @param molecularItem        3级
 @param item              2级
 @param row               1级
 @param section           0级
 @param indexPathType     坐标类型
 @return QBLevelIndexPath
 */
+ (instancetype)indexPathWithAtomicItem:(NSInteger)atomicItem molecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row  section:(NSInteger)section type:(QBLevelIndexPathType)indexPathType level:(NSInteger)level;

/**
 是否相等

 @param leveIndexPath 坐标
 @return 结果
 */
- (BOOL)isEqualToLevelIndexPath:(QBLevelIndexPath *)leveIndexPath;

@end

NS_ASSUME_NONNULL_END
