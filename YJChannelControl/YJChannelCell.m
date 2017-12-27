//
//  YJChannelCell.m
//  YJCHannelSwitch
//
//  Created by 包宇津 on 2017/12/28.
//  Copyright © 2017年 baoyujin. All rights reserved.
//

#import "YJChannelCell.h"

@interface YJChannelCell(){
    UILabel *_textLabel;
    CAShapeLayer *_borderLayer;
}

@end

@implementation YJChannelCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI {
    self.userInteractionEnabled = YES;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [self backgroundColor];
    
    _textLabel = [UILabel new];
    _textLabel.frame = self.bounds;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [self textColor];
    _textLabel.adjustsFontSizeToFitWidth = true;
    _textLabel.userInteractionEnabled = true;
    [self addSubview:_textLabel];
    [self addBorderLayer];
}

-(UIColor*)backgroundColor{
    return [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
}

-(UIColor*)textColor{
    return [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1];
}

-(UIColor*)lightTextColor{
    return [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];
}

-(void)addBorderLayer {
    _borderLayer = [CAShapeLayer layer];
    _borderLayer.bounds = self.bounds;
    _borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds));
    _borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:_borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    _borderLayer.lineWidth = 1;
    _borderLayer.fillColor = [UIColor clearColor].CGColor;
    _borderLayer.strokeColor = [self backgroundColor].CGColor;
    _borderLayer.lineDashPattern = @[@5,@3];
    [self.layer addSublayer:_borderLayer];
    _borderLayer.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

-(void)setTitle:(NSString *)title {
    _title = title;
    _textLabel.text = title;
}

-(void)setIsMoving:(BOOL)isMoving {
    _isMoving = isMoving;
    if (isMoving) {
        self.backgroundColor = [UIColor clearColor];
        _borderLayer.hidden = false;
    }else {
        self.backgroundColor = [self backgroundColor];
        _borderLayer.hidden = YES;
    }
}

-(void)setIsFixed:(BOOL)isFixed {
    _isFixed = isFixed;
    if (isFixed) {
        _textLabel.textColor = [self lightTextColor];
    }else {
        _textLabel.textColor = [self textColor];
    }
}
@end
