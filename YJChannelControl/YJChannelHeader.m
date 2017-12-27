//
//  YJChannelHeader.m
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/27.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJChannelHeader.h"

@interface YJChannelHeader(){
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation YJChannelHeader

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI {
    CGFloat marginX = 15.0f;
    CGFloat labelWidth = (self.bounds.size.width - 2 * marginX) / 2.0f;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, labelWidth, self.bounds.size.height)];
    _titleLabel.textColor = [UIColor blackColor];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + marginX, 0, labelWidth, self.bounds.size.height)];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    _subtitleLabel.textAlignment = NSTextAlignmentRight;
    _subtitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_subtitleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
}

@end
