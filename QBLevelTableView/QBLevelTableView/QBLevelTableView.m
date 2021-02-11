//
//  QBLevelTableView.m
//  QBLevelTableView
//
//  Created by 覃斌 卢    on 2021/2/5.
//

#import "QBLevelTableView.h"
#import "QBLevelNode.h"

@interface QBLevelTableView ()

// section节点数据源
@property(strong,nonatomic) NSArray<QBLevelNode *> *sectionNodes;
/// 所有的QBLevelIndexPathType cell节点数据源
/// @note: key:@(section).stringValue
@property(strong,nonatomic) NSMutableDictionary<NSString *, NSMutableArray<QBLevelNode *> *> *allCellNodesMap;
/// indexPath Map
/// @note: value: NSIndexPath.row
@property(strong,nonatomic) NSMutableDictionary<NSString *, NSNumber *> *indexPathMap;

@end

@implementation QBLevelTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self setup];
        [self uiAction];
    }
    
    return self;
}

#pragma mark - Public
#pragma mark IndexPath转化
- (NSIndexPath *)transformLevelIndexPathToIndexPath:(QBLevelIndexPath *)levelIndexPath {
    NSInteger currentSection = levelIndexPath.section;
    NSInteger currentRow = [self orderOfRowWithLevelIndexPath:levelIndexPath];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:currentRow inSection:currentSection];
    
    return indexPath;
}

- (QBLevelIndexPath *)transformIndexPathToLevelIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentSection = indexPath.section;
    NSInteger currentRow = indexPath.row;
    QBLevelNode *node = [self.allCellNodesMap valueForKey:@(currentSection).stringValue][currentRow];
    QBLevelIndexPath *levelIndexPath = node.levelIndexPath;
    
    return levelIndexPath;
}

#pragma mark - Private
- (void)setup {
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:nullCellIdentifier];
    [self reloadData];
}

- (void)uiAction {
    //
}

#pragma mark - 模型数据加载
- (void)reloadModelData {
    [self.indexPathMap removeAllObjects];
    [self.allCellNodesMap removeAllObjects];
    self.sectionNodes = [self generateNodes];
}

#pragma mark - Override
- (void)reloadData {
    [self reloadModelData];
    [super reloadData];
}

- (void)insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadModelData];
    [super insertSections:sections withRowAnimation:animation];
}

- (void)deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadModelData];
    [super deleteSections:sections withRowAnimation:animation];
}

- (void)reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.sectionNodes];
    [sections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        self.allCellNodesMap[@(idx).stringValue] = [NSMutableArray array];
        QBLevelNode *sectionNode = [self generateSectionNodesWithSection:idx];
        [array replaceObjectAtIndex:idx withObject:sectionNode];
    }];
    self.sectionNodes = array;
    
    [super reloadSections:sections withRowAnimation:animation];
}

- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    [self reloadModelData];
    [super moveSection:section toSection:newSection];
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadModelData];
    [super insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadModelData];
    [super deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    [self reloadModelData];
    [super reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self reloadModelData];
    [super moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

#pragma mark - 数据模型生成
// 生成节点数组
- (NSArray<QBLevelNode *> *)generateNodes {
    NSInteger sectionCount = [self numberOfSections];//section 数量
    NSMutableArray *nodes = [NSMutableArray array];
    for(NSInteger section = 0 ; section < sectionCount ; section++){
        self.allCellNodesMap[@(section).stringValue] = [NSMutableArray array];
        QBLevelNode *sectionNode = [self generateSectionNodesWithSection:section];
        [nodes addObject:sectionNode];
    }
    
    return nodes;
}

/// 生成section的坐标节点
/// @param section section
/// @return section根节点
- (QBLevelNode *)generateSectionNodesWithSection:(NSInteger)section {
    QBLevelNode *sectionNode = [[QBLevelNode alloc]init];
    NSMutableArray *sectionChildNodes = [NSMutableArray array];
    NSInteger rowCount = [self numberOfLevelRowsInSection:section];
    for (NSInteger row = 0; row < rowCount ; row++) {
        [self generateRowNodesWithSection:section row:row childNodes:sectionChildNodes];
    }
    sectionNode.childNodes = sectionChildNodes;
    sectionNode.level = 0;
    
    return sectionNode;
}

/// 生成row的坐标节点
/// @param section section
/// @param row row
/// @param childNodes 子节点数组
- (void)generateRowNodesWithSection:(NSInteger)section row:(NSInteger)row childNodes:(NSMutableArray *)childNodes {
    if ([self isHaveHeaderInSection:section row:row]) {
        QBLevelNode *headerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:0 row:row section:section type:QBLevelIndexPathTypeRowHeader level:1];
        headerNode.levelIndexPath = levelIndexPath;
        headerNode.level = 1;
        
        [childNodes addObject:headerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:headerNode];
        
    }
    
    QBLevelNode *rowNode = [[QBLevelNode alloc]init];
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:0 row:row section:section type:QBLevelIndexPathTypeRow level:1];
    rowNode.levelIndexPath = levelIndexPath;
    rowNode.level = 1;
    
    [childNodes addObject:rowNode];
    [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
    [self.allCellNodesMap[@(section).stringValue] addObject:rowNode];
    
    NSInteger itemCount = [self numberOfLevelItemForRow:row section:section];
    NSMutableArray *rowChildNodes = [NSMutableArray array];
    for (NSInteger item = 0; item < itemCount ; item++) {
        [self generateItemNodesWithSection:section row:row item:item childNodes:rowChildNodes];
    }
    
    rowNode.childNodes = rowChildNodes;
    
    if ([self isHaveFooterInSection:section row:row]) {
        QBLevelNode *footerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:0 row:row section:section type:QBLevelIndexPathTypeRowFooter level:1];
        footerNode.levelIndexPath = levelIndexPath;
        footerNode.level = 1;
        
        [childNodes addObject:footerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:footerNode];
    }
}

/// 生成item的坐标节点
/// @param section section
/// @param row row
/// @param item item
/// @param childNodes 子节点数组
- (void)generateItemNodesWithSection:(NSInteger)section row:(NSInteger)row item:(NSInteger)item childNodes:(NSMutableArray *)childNodes {
    if ([self isHaveHeaderInSection:section row:row item:item]) {
        QBLevelNode *headerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:item row:row section:section type:(QBLevelIndexPathTypeItemHeader) level:2];
        headerNode.levelIndexPath = levelIndexPath;
        headerNode.level = 2;
        
        [childNodes addObject:headerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:headerNode];
    }
    
    QBLevelNode *itemNode = [[QBLevelNode alloc]init];
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:item row:row section:section type:QBLevelIndexPathTypeItem level:2];
    itemNode.levelIndexPath = levelIndexPath;
    itemNode.level = 2;
    
    [childNodes addObject:itemNode];
    [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
    [self.allCellNodesMap[@(section).stringValue] addObject:itemNode];
    
    NSInteger molecularItemCount = [self numberOfLevelMolecularItemForItem:item row:row section:section];
    NSMutableArray *itemChildNodes = [NSMutableArray array];
    for (NSInteger molecularItem = 0; molecularItem < molecularItemCount ; molecularItem++) {
        [self generateMolecularItemNodesWithSection:section row:row item:item molecularItem:molecularItem childNodes:itemChildNodes];
    }
    
    itemNode.childNodes = itemChildNodes;
    
    if ([self isHaveFooterInSection:section row:row item:item]) {
        QBLevelNode *footerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:item row:row section:section type:(QBLevelIndexPathTypeItemFooter) level:2];
        footerNode.levelIndexPath = levelIndexPath;
        footerNode.level = 2;
        
        [childNodes addObject:footerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:footerNode];
    }
}

/// 生成molecularItem的坐标节点
/// @param section section
/// @param row row
/// @param item item
/// @param molecularItem molecularItem
/// @param childNodes 子节点数组
- (void)generateMolecularItemNodesWithSection:(NSInteger)section row:(NSInteger)row item:(NSInteger)item molecularItem:(NSInteger )molecularItem childNodes:(NSMutableArray *)childNodes {
    if ([self isHaveHeaderInSection:section row:row item:item molecularItem:molecularItem]) {
        QBLevelNode *headerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:(QBLevelIndexPathTypeMolecularItemHeader) level:3];
        headerNode.levelIndexPath = levelIndexPath;
        headerNode.level = 3;
        
        [childNodes addObject:headerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:headerNode];
    }
    
    QBLevelNode *molecularItemNode = [[QBLevelNode alloc]init];
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:QBLevelIndexPathTypeMolecularItem level:3];
    molecularItemNode.levelIndexPath = levelIndexPath;
    molecularItemNode.level = 3;
    
    [childNodes addObject:molecularItemNode];
    [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
    [self.allCellNodesMap[@(section).stringValue] addObject:molecularItemNode];
    
    NSInteger atomicItemCount = [self numberOfLevelAtomicItemForMolecularItem:molecularItem item:item row:row section:section];
    NSMutableArray *molecularItemChildNodes = [NSMutableArray array];
    for (NSInteger atomicItem = 0; atomicItem < atomicItemCount ; atomicItem++) {
        [self generateAtomicItemNodesWithSection:section row:row item:item molecularItem:molecularItem atomicItem:atomicItem childNodes:molecularItemChildNodes];
    }
    
    molecularItemNode.childNodes = molecularItemChildNodes;
    
    
    if ([self isHaveFooterInSection:section row:row item:item molecularItem:molecularItem]) {
        QBLevelNode *footerNode = [[QBLevelNode alloc]init];
        QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:(QBLevelIndexPathTypeMolecularItemFooter) level:3];
        footerNode.levelIndexPath = levelIndexPath;
        footerNode.level = 3;
        
        [childNodes addObject:footerNode];
        [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
        [self.allCellNodesMap[@(section).stringValue] addObject:footerNode];
    }
}

/// 生成atomicItem的坐标节点
/// @param section section
/// @param row row
/// @param item item
/// @param molecularItem molecularItem
/// @param atomicItem atomicItem
/// @param childNodes 子节点数组
- (void)generateAtomicItemNodesWithSection:(NSInteger)section row:(NSInteger)row item:(NSInteger)item molecularItem:(NSInteger )molecularItem atomicItem:(NSInteger)atomicItem childNodes:(NSMutableArray *)childNodes {
    QBLevelNode *atomicItemNode = [[QBLevelNode alloc]init];
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:(QBLevelIndexPathTypeAtomicItem) level:4];
    atomicItemNode.levelIndexPath = levelIndexPath;
    atomicItemNode.level = 4;
    
    [childNodes addObject:atomicItemNode];
    [self cacheIndexPathWithRow:self.allCellNodesMap[@(section).stringValue].count levelIndexPath:levelIndexPath];
    [self.allCellNodesMap[@(section).stringValue] addObject:atomicItemNode];
}


#pragma mark - IndexPath数据缓存
- (void)cacheIndexPathWithRow:(NSInteger)row levelIndexPath:(QBLevelIndexPath *)levelIndexPath {
    [self setRow:row withLevelIndexPath:levelIndexPath];
}

- (void)setRow:(NSInteger)row withLevelIndexPath:(QBLevelIndexPath *)levelIndexPath {
    NSString *key = [self indexPathMapKey:levelIndexPath];
    [self.indexPathMap setObject:@(row) forKey:key];
}

- (NSInteger)orderOfRowWithLevelIndexPath:(QBLevelIndexPath *)levelIndexPath {
    NSString *key = [self indexPathMapKey:levelIndexPath];
    NSNumber *rowNum = [self.indexPathMap objectForKey:key];
    if (!rowNum) {
        rowNum = @(0);
    }
    return rowNum.integerValue;
}

- (NSString *)indexPathMapKey:(QBLevelIndexPath *)levelIndexPath {
    NSString *key = [NSString stringWithFormat:@"%@-%@-%@-%@-%@-%@-%@",@(levelIndexPath.level),@(levelIndexPath.indexPathType),@(levelIndexPath.section),@(levelIndexPath.row),@(levelIndexPath.item),@(levelIndexPath.molecularItem),@(levelIndexPath.atomicItem)];
    
    return key;
}

#pragma mark - 获取子层级数量
// 获取section个数
- (NSInteger)numberOfSections {
    NSInteger currentSections = 0;
    if (self.qbDataSource && [self.qbDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        currentSections = [self.qbDataSource numberOfSectionsInTableView:self];
    }
    
    return currentSections;
}

 /// 获取自定义row个数
 /// @param section section
 /// @return 自定义row个数
- (NSInteger)numberOfLevelRowsInSection:(NSInteger)section {
    NSInteger currentRows = 0;
    if (self.qbDataSource && [self.qbDataSource respondsToSelector:@selector(levelTableView:numberOfRowsInSection:)]) {
        currentRows=[self.qbDataSource levelTableView:self numberOfRowsInSection:section];
    }
    
    return currentRows;
}

/// 获取自定义item个数
/// @param row row
/// @param section section
/// @return 自定义item个数
- (NSInteger)numberOfLevelItemForRow:(NSInteger)row section:(NSInteger)section {
    NSInteger currentitems = 0;
    if (self.qbDataSource && [self.qbDataSource respondsToSelector:@selector(levelTableView:numberOfItemsInRow:section:)]) {
        currentitems = [self.qbDataSource levelTableView:self numberOfItemsInRow:row section:section];
    }
    
    return currentitems;
}

/// 获取自定义molecularItem个数
/// @param item item
/// @param row row
/// @param section section
/// @return 自定义molecularItem个数
- (NSInteger)numberOfLevelMolecularItemForItem:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    NSInteger currentAtomicItems = 0;
    if (self.qbDataSource && [self.qbDataSource respondsToSelector:@selector(levelTableView:numberOfMolecularItemsInItem:row:section:)]) {
        currentAtomicItems = [self.qbDataSource levelTableView:self numberOfMolecularItemsInItem:item row:row section:section];
    }
    
    return currentAtomicItems;
}

/// 获取自定义atomicItem个数
///  @param molecularItem molecularItem
///  @param item item
///  @param row row
///  @param section section
///  @return 自定义atomicItem个数
- (NSInteger)numberOfLevelAtomicItemForMolecularItem:(NSInteger)molecularItem item:(NSInteger)item row:(NSInteger)row section:(NSInteger)section {
    NSInteger currentAtomicItems = 0;
    if (self.qbDataSource && [self.qbDataSource respondsToSelector:@selector(levelTableView:numberOfAtomicItemsInMolecularItem:item:row:section:)]) {
        currentAtomicItems = [self.qbDataSource levelTableView:self numberOfAtomicItemsInMolecularItem:molecularItem item:item row:row section:section];
    }
    
    return currentAtomicItems;
}

#pragma mark - 是否存在HeaderFooter
/// row级别是否有header
/// @param section section
/// @param row row
/// @return 是否有header
- (BOOL)isHaveHeaderInSection:(NSInteger)section row:(NSInteger)row {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:0 row:row section:section type:QBLevelIndexPathTypeRowHeader level:1];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForHeaderCellAtIndexPath:)]) {
        if ([self.qbDelegate levelTableView:self heightForHeaderCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

/// item级别是否有header
/// @param section section
/// @param row row
/// @param item item
/// @return 是否有header
- (BOOL)isHaveHeaderInSection:(NSInteger)section row:(NSInteger)row item:(NSInteger )item {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:item row:row section:section type:QBLevelIndexPathTypeItemHeader level:2];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForHeaderCellAtIndexPath:)]) {
        if ([self.qbDelegate levelTableView:self heightForHeaderCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

///molecularItem级别是否有header
/// @param section section
/// @param row row
/// @param item item
/// /// @param molecularItem molecularItem
/// @return 是否有header
- (BOOL)isHaveHeaderInSection:(NSInteger)section row:(NSInteger)row item:(NSInteger )item molecularItem:(NSInteger )molecularItem {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:QBLevelIndexPathTypeMolecularItemHeader level:3];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForHeaderCellAtIndexPath:)] ) {
        if ([self.qbDelegate levelTableView:self heightForHeaderCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

/// row级别是否有footer
/// @param section section
/// @param row row
/// @return 是否有footer
- (BOOL)isHaveFooterInSection:(NSInteger)section row:(NSInteger)row {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:0 row:row section:section type:QBLevelIndexPathTypeRowFooter level:1];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForFooterCellAtIndexPath:)]) {
        if ([self.qbDelegate levelTableView:self heightForFooterCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

/// item级别是否有footer
/// @param section section
/// @param row row
/// @param item item
/// @return 是否有footer
- (BOOL)isHaveFooterInSection:(NSInteger)section row:(NSInteger)row item:(NSInteger )item {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:0 item:item row:row section:section type:QBLevelIndexPathTypeItemFooter level:2];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForFooterCellAtIndexPath:)]) {
        if ([self.qbDelegate levelTableView:self heightForFooterCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

/**
 atomicItem级别是否有footer
 
 @param section section
 @param row row
 @param item item
 @param molecularItem molecularItem
 @return 是否有footer
 */
- (BOOL)isHaveFooterInSection:(NSInteger)section row:(NSInteger)row item:(NSInteger )item molecularItem:(NSInteger )molecularItem {
    QBLevelIndexPath *levelIndexPath = [QBLevelIndexPath indexPathWithAtomicItem:0 molecularItem:molecularItem item:item row:row section:section type:QBLevelIndexPathTypeMolecularItemFooter level:3];
    BOOL isHave = NO;
    if (self.qbDelegate && [self.qbDelegate respondsToSelector:@selector(levelTableView:heightForFooterCellAtIndexPath:)]) {
        if ([self.qbDelegate levelTableView:self heightForFooterCellAtIndexPath:levelIndexPath] > 0) {
            isHave = YES;
        } else {
            isHave = NO;
        }
    } else {
        isHave = NO;
    }
    
    return isHave;
}

#pragma mark - Setter

#pragma mark - Getter
- (NSArray<QBLevelNode *> *)sectionNodes {
    if (!_sectionNodes) {
        _sectionNodes = [NSArray array];
    }
    return _sectionNodes;
}

- (NSMutableDictionary<NSString *, NSMutableArray<QBLevelNode *> *> *)allCellNodesMap {
    if (!_allCellNodesMap) {
        _allCellNodesMap = [NSMutableDictionary dictionary];
    }
    
    return _allCellNodesMap;
}

- (NSMutableDictionary<NSString *, NSNumber *> *)indexPathMap {
    if (!_indexPathMap){
        _indexPathMap =  [NSMutableDictionary dictionary];
    }
    
    return _indexPathMap;
}

- (void)setQbDataSource:(id<QBLevelTableViewDataSource>)qbDataSource {
    _qbDataSource = qbDataSource;
    
    self.dataSource = _qbDataSource;
}

- (void)setQbDelegate:(id<QBLevelTableViewDelegate>)qbDelegate {
    _qbDelegate = qbDelegate;
    
    self.delegate = qbDelegate;
}

#pragma mark - Init
- (void)initSubviews {
    //
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    //
}

@end
