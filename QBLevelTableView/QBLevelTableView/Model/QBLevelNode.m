//
//  QBLevelNode.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/7.
//

#import "QBLevelNode.h"

@implementation QBLevelNode

- (BOOL)isLeaf {
    BOOL ret = NO;
    if (self.childNodes == nil || self.childNodes.count == 0) {
        ret = YES;
    }
    
    return ret;
}

@end
