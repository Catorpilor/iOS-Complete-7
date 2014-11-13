//
//  ToDoListTableViewCell.m
//  ToDoLists
//
//  Created by cheshire on 14/11/13.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ToDoListTableViewCell.h"
#import "ToDoListStrikeThroughLable.h"

@implementation ToDoListTableViewCell{
    CAGradientLayer *_gradientLayer;
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    BOOL _completeOnDragRelease;
    ToDoListStrikeThroughLable *_label;
    CALayer *_itemCompleteLayer;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _label = [[ToDoListStrikeThroughLable alloc] initWithFrame:CGRectNull];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:16];
        _label.backgroundColor =[UIColor clearColor];
        [self addSubview:_label];
        //remove the default blue highlight for selected cells
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        UIGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
        _itemCompleteLayer = [CALayer layer];
        _itemCompleteLayer.backgroundColor = [[[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0]CGColor];
        _itemCompleteLayer.hidden = YES;
        [self.layer insertSublayer:_itemCompleteLayer atIndex:0];
    }
    return self;
}


#pragma mark - horizontal pan gesture methods

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    if(fabsf(translation.x) > fabsf(translation.y)){
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognize{
    if(recognize.state == UIGestureRecognizerStateBegan){
        //if the gesture has just started , record the current center loction
        _originalCenter = self.center;
    }
    
    if(recognize.state == UIGestureRecognizerStateChanged){
        //translate the center
        CGPoint tranlation = [recognize translationInView:self];
        self.center = CGPointMake( _originalCenter.x +tranlation.x, _originalCenter.y);
        //determine whether the item has been dragged far enough to init a delete/complte
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width/2;
        _completeOnDragRelease = self.frame.origin.x > self.frame.size.width/2;
    }
    
    if(recognize.state == UIGestureRecognizerStateEnded){
        //the frame this cell would have had before the drag
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
        if(!_deleteOnDragRelease||!_completeOnDragRelease){
            //if the item is not being deleted snap back to the original state
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = originalFrame;
            }];
        }
        if(_deleteOnDragRelease){
            [self.delegate toDoItemDeleted:self.toDoItem];
        }
        if(_completeOnDragRelease){
            self.toDoItem.bChecked = YES;
            _itemCompleteLayer.hidden = NO;
            _label.bStrikeThrough = YES;
        }
    }
}

const float LABEL_LEFT_MARGIN = 15.0f;

-(void) layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
    _gradientLayer.frame = self.bounds;
    _itemCompleteLayer.frame = self.bounds;
    _label.frame = CGRectMake(LABEL_LEFT_MARGIN, 0, self.bounds.size.width - LABEL_LEFT_MARGIN, self.bounds.size.height);
}

-(void)setToDoItem:(ToDoListModel *)toDoItem{
    _toDoItem = toDoItem;
    //we must update all the visual state associated with the model item
    _label.text = toDoItem.toDoGoal;
    _label.bStrikeThrough = toDoItem.bChecked;
    _itemCompleteLayer.hidden = !toDoItem.bChecked;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
