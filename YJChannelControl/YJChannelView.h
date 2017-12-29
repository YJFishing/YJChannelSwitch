//
//  YJChannelView.h
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/29.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJChannelView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;
@property (nonatomic, strong) NSMutableArray *unUseTitles;

- (void)reloadData;

@end
