//
//  QBLevelNode.h
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/7.
//

#import <Foundation/Foundation.h>
#import "QBLevelIndexPath.h"

NS_ASSUME_NONNULL_BEGIN
// 节点
@interface QBLevelNode : NSObject

// 子节点集合
@property(strong,nonatomic) NSArray<QBLevelNode *> *childNodes;
// 节点索引
@property(strong,nonatomic) QBLevelIndexPath *levelIndexPath;
// 结点层级
@property (nonatomic, assign) int level;
// 是否是叶子结点
@property (nonatomic, assign) BOOL isLeaf;

@end

NS_ASSUME_NONNULL_END
