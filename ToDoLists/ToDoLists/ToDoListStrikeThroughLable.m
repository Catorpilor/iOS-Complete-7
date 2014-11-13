//
//  ToDoListStrikeThroughLable.m
//  ToDoLists
//
//  Created by cheshire on 14/11/13.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ToDoListStrikeThroughLable.h"

@implementation ToDoListStrikeThroughLable{
    bool _bStrikeThrough;
    CALayer *_strikeThroughLayer;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

const float STRIKEOUT_THICKNESS = 2.0f;

-(id)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        _strikeThroughLayer = [CALayer layer];
        _strikeThroughLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        _strikeThroughLayer.hidden = YES;
        [self.layer addSublayer:_strikeThroughLayer];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

-(void)setText:(NSString *)text{
    [super setText:text];
    [self resizeStrikeThrough];
}

//resize the strikethrough layer to match the current lable text
-(void)resizeStrikeThrough{
    CGSize textSize = [self.text sizeWithAttributes:@{@"font":self.font}];
    _strikeThroughLayer.frame = CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKEOUT_THICKNESS);
}

#pragma mark - property setter
-(void)setBStrikeThrough:(bool)bStrikeThrough{
    _bStrikeThrough = bStrikeThrough;
    _strikeThroughLayer.hidden = !bStrikeThrough;
}

@end
