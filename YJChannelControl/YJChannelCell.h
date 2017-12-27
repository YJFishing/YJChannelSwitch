//
//  YJChannelCell.h
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/28.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJChannelCell : UICollectionViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isFixed;

@end
