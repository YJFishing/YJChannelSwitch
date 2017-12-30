//
//  YJChannelControl.m
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/30.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJChannelControl.h"
#import "YJChannelView.h"

@interface YJChannelControl() {
    UINavigationController *_nav;
    YJChannelView *_channelView;
    ChannelBlock _channelBlock;
}
@end

@implementation YJChannelControl

+ (YJChannelControl *)shareControl {
    static YJChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[YJChannelControl alloc] init];
    });
    return  control;
}

- (instancetype)init {
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

- (void)buildChannelView {
    _channelView = [[YJChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _nav.topViewController.title = @"频道管理";
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.view = _channelView;
    _nav.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
}

- (void)backMethod {
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = _nav.view.bounds.size.height;
        _nav.view.frame = frame;
    } completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
    _channelBlock(_channelView.inUseTitles,_channelView.unUseTitles);
}

- (void)showChannelViewWithInUseTitles:(NSArray *)inUseTitles unUseTitles:(NSArray *)unUseTitles finish:(ChannelBlock)block {
    _channelBlock = block;
    _channelView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _channelView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_channelView reloadData];
    
    CGRect frame = _nav.view.frame;
    frame.origin.y = _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3f animations:^{
        _nav.view.alpha = 1;
        _nav.view.frame = [UIScreen mainScreen].bounds;
    } completion:^(BOOL finished) {
        nil;
    }];
}

@end


