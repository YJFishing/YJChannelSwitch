//
//  YJChannelControl.h
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/30.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YJChannelControl : NSObject

typedef void (^ChannelBlock) (NSArray *inUseTitles,NSArray *unUseTitles);

+ (YJChannelControl *)shareControl;

- (void)showChannelViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles finish:(ChannelBlock)block;

@end


