//
//  YJChannelView.m
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/29.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJChannelView.h"
#import "YJChannelHeader.h"
#import "YJChannelCell.h"

//菜单列数
static NSInteger ColumnNum = 4;
//横向和纵向的距离
static CGFloat CellMarginX = 15.0f;
static CGFloat CellMarginY = 10.0f;

@interface YJChannelView()<UICollectionViewDelegate,UICollectionViewDataSource>{
    UICollectionView *_collectionView;
    YJChannelCell *_dragingCell;   //被拖拽的Cell
    NSIndexPath *_dragingIndexPath;  //被拖拽的Indexpath
    NSIndexPath *_targetIndexPaht;   //目标Indexpath
}
@end

@implementation YJChannelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat cellWidth = (self.bounds.size.width - (ColumnNum + 1) * CellMarginX) / ColumnNum;
    flowLayout.itemSize = CGSizeMake(cellWidth, cellWidth / 2.0f);
    flowLayout.sectionInset = UIEdgeInsetsMake(CellMarginY, CellMarginX, CellMarginY, CellMarginX);
    flowLayout.minimumLineSpacing = CellMarginY;
    flowLayout.minimumInteritemSpacing = CellMarginX;
    flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 40);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _collectionView.showsHorizontalScrollIndicator = false;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[YJChannelCell class] forCellWithReuseIdentifier:NSStringFromClass([YJChannelCell class])];
    [_collectionView registerClass:[YJChannelHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([YJChannelHeader class])];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [_collectionView addGestureRecognizer:longPress];
    
    _dragingCell = [[YJChannelCell alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth/2.0f)];
    _dragingCell.hidden = YES;
    [_collectionView addSubview:_dragingCell];
    
}

- (void)longPressMethod:(UILongPressGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:_collectionView];
    switch(gesture.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self dragChanged:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self dragEnd:point];
            break;
        default:
            break;
    }
}

//拖拽开始，找到被拖拽的item
- (void)dragBegin:(CGPoint)point {
    _dragingIndexPath = [self getDragingIndexPathWithPoint:point];
    if (!_dragingIndexPath) {
        return;
    }
    [_collectionView bringSubviewToFront:_dragingCell];
    YJChannelCell *cell = (YJChannelCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
    cell.isMoving = YES;
    
    //更新cell的信息
    _dragingCell.hidden = NO;
    _dragingCell.frame = cell.frame;
    _dragingCell.title = cell.title;
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
}

//正在拖拽
- (void)dragChanged:(CGPoint)point {
    if (!_dragingIndexPath) {
        return;
    }
    _dragingCell.center = point;
    _targetIndexPaht = [self getTargetIndexPathWithPoint:point];
    //交换位置，如果没有找到_targetIndexPath则不交换位置
    if (_dragingIndexPath && _targetIndexPaht) {
        //更新数据源
        [self changeInUseTitles];
        //更新item位置
        [_collectionView moveItemAtIndexPath:_dragingIndexPath toIndexPath:_targetIndexPaht];
        _dragingIndexPath = _targetIndexPaht;
    }
}

- (void)dragEnd:(CGPoint)point {
    if (!_dragingIndexPath) {
        return;
    }
    CGRect endFrame = [_collectionView cellForItemAtIndexPath:_dragingIndexPath].frame;
    [_dragingCell setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [UIView animateWithDuration:0.3f animations:^{
        _dragingCell.frame = endFrame;
    } completion:^(BOOL finished) {
        _dragingCell.hidden = YES;
        YJChannelCell *cell = (YJChannelCell *)[_collectionView cellForItemAtIndexPath:_dragingIndexPath];
        cell.isMoving = false;
    }];
}

- (NSIndexPath *)getDragingIndexPathWithPoint:(CGPoint)point{
    NSIndexPath *dragIndexPath = nil;
    //最后剩一个不排序
    if ([_collectionView numberOfItemsInSection:0] == 1) {
        return dragIndexPath;
    }
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        //下半部分不需要排序
        if (indexPath.section > 0) {
            continue;
        }
        //在上半部分中找出对应的Item
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                dragIndexPath = indexPath;
            }
            break;
        }
    }
    return dragIndexPath;
}


- (NSIndexPath *)getTargetIndexPathWithPoint:(CGPoint)point {
    NSIndexPath *targetIndexPath = nil;
    for (NSIndexPath *indexPath in _collectionView.indexPathsForVisibleItems) {
        if ([indexPath isEqual:_dragingIndexPath]) {
            continue;
        }
        if (indexPath.section > 0) {
            continue;
        }
        if (CGRectContainsPoint([_collectionView cellForItemAtIndexPath:indexPath].frame, point)) {
            if (indexPath.row != 0) {
                targetIndexPath = indexPath;
            }
        }
    }
    return targetIndexPath;
}

- (void)changeInUseTitles {
    id obj = [_inUseTitles objectAtIndex:_dragingIndexPath.row];
    [_inUseTitles removeObject:obj];
    [_inUseTitles insertObject:obj atIndex:_targetIndexPaht.row];
}
- (void)reloadData {
    
}
@end
