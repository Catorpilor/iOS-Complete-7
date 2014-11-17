//
//  ToDoListTableViewPinchToAdd.m
//  ToDoLists
//
//  Created by cheshire on 14/11/17.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListTableViewPinchToAdd.h"
#import "ToDoListTable.h"

struct TDLTouchPoints{
    CGPoint upper;
    CGPoint lower;
};

typedef struct TDLTouchPoints TDLTouchPoints;


@implementation ToDoListTableViewPinchToAdd{
    ToDoListTable *_tableView;
    ToDoListTableViewCell *_placeHolderCell;
    // the indices of the upper and lower cells that are being pinched
    int _pointOneCellindex;
    int _pointTwoCellindex;
    
    // the location of the touch points when the pinch began
    TDLTouchPoints _initialTouchPoints;
    
    // indicates that the pinch is in progress
    BOOL _pinchInProgress;
    
    // indicates that the pinch was big enough to cause a new item to be added
    BOOL _pinchExceededRequiredDistance;
}

-(id)initWithTableView:(ToDoListTable *)tableView{
    if(self = [super init]){
        _placeHolderCell = [[ToDoListTableViewCell alloc] init];
        _placeHolderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        //_tableView.scrollViewDelegate  =self;
        //add a pinch gesture recognizer
        UIGestureRecognizer *pinchRecognize = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_tableView addGestureRecognizer:pinchRecognize];
    }
    return self;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)recognize{
    if(recognize.state == UIGestureRecognizerStateBegan){
        [self pinchStarted:recognize];
    }
    if(_pinchInProgress && recognize.state == UIGestureRecognizerStateChanged && recognize.numberOfTouches == 2 ){
        [self pinchChanged:recognize];
    }
    if(recognize.state == UIGestureRecognizerStateEnded){
        [self pinchEnded:recognize];
    }
}

-(void)pinchEnded:(UIPinchGestureRecognizer *)recognize{
    _pinchInProgress = false;
    
    //remove the place holder cell
    _placeHolderCell.transform = CGAffineTransformIdentity;
    [_placeHolderCell removeFromSuperview];
    
    if(_pinchExceededRequiredDistance){
        //add a new item
        //NSLog(@"%f",_tableView.scrollView.contentOffset.y);
        //int indexOffSet = floor(_tableView.scrollView.contentOffset.y / TODOLIST_ROW_HEIGHT);
        NSLog(@"%d", _pointOneCellindex);
        [_tableView.dataSource itemAddedAtIndex:_pointOneCellindex+1];
    }else{
        //otherwise animate back to position
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             NSArray *visibleArray = [_tableView visibleCells];
                             for(ToDoListTableViewCell *cell in visibleArray){
                                 cell.transform = CGAffineTransformIdentity;
                             }
                         }
                         completion:nil];
    }
}

-(void)pinchChanged:(UIPinchGestureRecognizer *)recognize{
    //find the touch points
    TDLTouchPoints currentPoints = [self getNormalisedPoints:recognize];
    
    //determine by how much each touch point has changed and take the min delta
    float upperDelta = currentPoints.upper.y - _initialTouchPoints.upper.y;
    float lowerDelta = currentPoints.lower.y - _initialTouchPoints.lower.y;
    
    float delta = -MIN(0, MIN(upperDelta, lowerDelta));
    
    //offsets the cells negative for the cells above ,positive for those below
    NSArray *visibleArray = [_tableView visibleCells];
    int nCount = (int)[visibleArray count];
    for( int i =0;i<nCount;i++){
        UIView *cell = (UIView *)visibleArray[i];
        if(i<=_pointOneCellindex){
            cell.transform = CGAffineTransformMakeTranslation(0, -delta);
        }
        if(i>=_pointTwoCellindex){
            cell.transform = CGAffineTransformMakeTranslation(0, delta);
        }
    }
    
    //scale the placeholder cell
    float gapSize = 2*delta;
    float cappedGapSize = MIN(gapSize, TODOLIST_ROW_HEIGHT);
    _placeHolderCell.transform = CGAffineTransformMakeScale(1.0f, cappedGapSize/TODOLIST_ROW_HEIGHT);
    
    _placeHolderCell.label.text = gapSize > TODOLIST_ROW_HEIGHT ? @"Release to Add Item" : @"Pull to Add Item";
    _placeHolderCell.alpha = MIN(1.0f, gapSize/TODOLIST_ROW_HEIGHT);
    
    //determine whether they have pinched far enough
    _pinchExceededRequiredDistance = gapSize > TODOLIST_ROW_HEIGHT;
}

-(void)pinchStarted:(UIPinchGestureRecognizer *)recognize{
    //find the initial touch-points
    _initialTouchPoints = [self getNormalisedPoints:recognize];
    
    //locate the cells that these points touch
    _pointOneCellindex = -100;
    _pointTwoCellindex = -100;
    
    NSArray *visibleCells = [_tableView visibleCells];
    int nCount = (int)[visibleCells count];
    for(int i=0;i<nCount;i++){
        UIView *cell = (UIView *)visibleCells[i];
        if( [self viewContainsPoint:cell withPoint:_initialTouchPoints.upper] ){
            _pointOneCellindex = i;
            //highlight the cell -for debugging
            cell.backgroundColor = [UIColor purpleColor];
        }
        if( [self viewContainsPoint:cell withPoint:_initialTouchPoints.lower] ){
            _pointTwoCellindex = i;
            cell.backgroundColor = [UIColor purpleColor];
        }
    }
    
    //check whether theay are neighbors
    if( abs( _pointTwoCellindex - _pointOneCellindex) == 1 ){
        // if so start the pinch progress
        _pinchInProgress = YES;
        _pinchExceededRequiredDistance = NO;
        
        //show your placeholder cell
        ToDoListTableViewCell *prevCell = (ToDoListTableViewCell *)visibleCells[_pointOneCellindex];
        _placeHolderCell.frame = CGRectOffset(prevCell.frame, 0.0f, TODOLIST_ROW_HEIGHT/2.0f);
        [_tableView.scrollView insertSubview:_placeHolderCell atIndex:0];
    }
}

//returns the two touch points ordering them to ensure that upper and lower are correctly identified;
-(TDLTouchPoints)getNormalisedPoints:(UIPinchGestureRecognizer *)recognizer{
    CGPoint point1 = [recognizer locationOfTouch:0 inView:_tableView];
    CGPoint point2 = [recognizer locationOfTouch:1 inView:_tableView];
    //offset based on scrollview
    point1.y += _tableView.scrollView.contentOffset.y;
    point2.y += _tableView.scrollView.contentOffset.y;
    //ensure point1 is top most
    if(point1.y > point2.y){
        CGPoint temp = point1;
        point1 = point2;
        point2 = temp;
    }
    TDLTouchPoints points = {point1,point2};
    return points;
}

-(BOOL) viewContainsPoint:(UIView*)view withPoint:(CGPoint)point {
    CGRect frame = view.frame;
    return (frame.origin.y < point.y) && (frame.origin.y + frame.size.height) > point.y;
}

@end
