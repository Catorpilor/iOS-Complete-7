//
//  ToDoListTable.m
//  ToDoLists
//
//  Created by cheshire on 14/11/15.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListTable.h"


@implementation ToDoListTable{
    UIScrollView *_scrollView;
    NSMutableSet *_reuseCells;
    Class         _cellClass;
    float         _editingOffset;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)init{
    if(self = [super init]){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _reuseCells = [[NSMutableSet alloc] init];
    }
    return self;
}

-(void)layoutSubviews{
    _scrollView.frame = self.frame;
    [self refreshView];
}

-(void)registerClassForCells:(Class)cellClass{
    _cellClass = cellClass;
}

-(UIView *)dequeueResuableCell{
    //first obtain a cell from the resue pool
    UIView *cell = [_reuseCells anyObject];
    if(cell){
        //NSLog(@"Returning a cell from the pool");
        [_reuseCells removeObject:cell];
    }
    
    //otherwise create a new cell
    if(!cell){
        //NSLog(@"Creating a new cell");
        cell = [[_cellClass alloc] init];
        //cell.delegate = self;
    }
    return cell;
}



-(NSArray *)cellSubviews{
    NSMutableArray *cells = [[NSMutableArray alloc]init];
    for(UIView *subView in _scrollView.subviews){
        if([subView isKindOfClass:[ToDoListTableViewCell class]]){
            [cells addObject:subView];
        }
    }
    return cells;
}

-(void)refreshView{
//    //set the scrollview height
//    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * TODOLIST_ROW_HEIGHT);
//    
//    //add the cells
//    for(int i =0;i<[_dataSource numberOfRows]; i++){
//        //obtain a cell
//        UIView *cell = [_dataSource cellForRow:i];
//        //set it's location
//        float topEdgeForRow = i * TODOLIST_ROW_HEIGHT;
//        CGRect frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, TODOLIST_ROW_HEIGHT);
//        cell.frame = frame;
//        
//        //add to the view
//        [_scrollView addSubview:cell];
//    }
    
    //new version of this function
    if(CGRectIsNull(_scrollView.frame)) return;
    //set the scrollview height
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, [_dataSource numberOfRows] * TODOLIST_ROW_HEIGHT);
    
    //remove cells taht are no longer visible
    for(UIView *cell in [self cellSubviews]){
        //is the cell off the top of scrollview?
        if(cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y){
            [self recycleCell:cell];
        }
        
        //is the cell off the bottom oof the scrollview
        if(cell.frame.origin.y > _scrollView.contentOffset.y+_scrollView.frame.size.height){
            [self recycleCell:cell];
        }
    }
    
    //ensure you have a cell for each row
    int firstVisibleIndex = MAX(0, floor(_scrollView.contentOffset.y / TODOLIST_ROW_HEIGHT));
    int lastVisibleIndex = MIN([_dataSource numberOfRows], firstVisibleIndex+1+ceil(_scrollView.frame.size.height / TODOLIST_ROW_HEIGHT));
    for(int row = firstVisibleIndex; row<lastVisibleIndex; row++){
        UIView *cell = [self cellForRow:row];
        if(!cell){
            //create a new cell
            UIView *cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * TODOLIST_ROW_HEIGHT;
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, TODOLIST_ROW_HEIGHT);
            //[_scrollView addSubview:cell]; check later
            [_scrollView insertSubview:cell atIndex:0];
        }
    }
    
}

//recycle a cell by adding it to the set of resue cells and removing it from the view
-(void)recycleCell:(UIView *)cell{
    [_reuseCells addObject:cell];
    [cell removeFromSuperview];
}
//returns the cell for the given row, or nil if it dosen't exists
-(UIView *)cellForRow:(NSInteger)row{
    float topEdgeForRow = row * TODOLIST_ROW_HEIGHT;
    for(UIView *cell in [self cellSubviews]){
        if(cell.frame.origin.y == topEdgeForRow) return cell;
    }
    return nil;
}

-(NSArray *)visibleCells{
    NSMutableArray *cells = [[NSMutableArray alloc] init];
    for(UIView *cell in [self cellSubviews]) [cells addObject:cell];
    NSArray *sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2) {
        UIView *view1 = (UIView *)obj1;
        UIView *view2 = (UIView *)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if(result > 0.0 ){
            return NSOrderedAscending;
        }else if (result < 0.0){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

-(void)reloadData{
    //remove all subviews
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

-(UIScrollView *)scrollView{
    return _scrollView;
}



#pragma mark - property setters
-(void)setDataSource:(id<ToDoListTableDateSource>)dataSource{
    _dataSource = dataSource;
    [self refreshView];
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self refreshView];
    //forward the delegate method
    if([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate forwarding
-(BOOL)respondsToSelector:(SEL)aSelector{
    if([self.scrollViewDelegate respondsToSelector:aSelector]){
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

-(id)forwardingTargetForSelector:(SEL)aSelector{
    if( [self.scrollViewDelegate respondsToSelector:aSelector] ){
        return self.scrollViewDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - ToDoListTableViewCellDelegate

-(void)cellDidBeginEditing:(ToDoListTableViewCell *)cell{
    //self.editingOffset = self.tableView.scrollView.contentOffset.y - cell.frame.origin.y;
//    _editingOffset = self.scrollView.contentOffset.y - cell.frame.origin.y;
//    for(ToDoListTableViewCell *tCell in [self visibleCells]){
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             tCell.frame = CGRectOffset(tCell.frame, 0.0f, _editingOffset);
//                             if(tCell != cell) tCell.alpha = 0.3;
//                         }];
//    }
    return [self.delegate cellDidBeginEditing:cell];
}

-(void)cellDidEndEditing:(ToDoListTableViewCell *)cell{
//    for(ToDoListTableViewCell *tCell in [self visibleCells]){
//        [UIView animateWithDuration:0.3
//                         animations:^{
//                             tCell.frame = CGRectOffset(tCell.frame, 0.0f, -_editingOffset);
//                             if(tCell != cell) tCell.alpha = 1.0f;
//                         }];
//    }
    return [self.delegate cellDidEndEditing:cell];
}

-(void)deleteCell:(ToDoListTableViewCell *)cell{
    //delete the cell for row
    
}

-(void)toDoItemDeleted:(ToDoListModel *)item{
    //old school ways using UITtableViewRowAnimationFade
    //    NSUInteger index = [self.list indexOfObject:item];
    //    [self.tableView beginUpdates];
    //    [self.list removeObject:item];
    //    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
    //new way manually animate the cell's location
//    float delay = 0.0;
//    //remote the model object
//    [self.list removeObject:item];
//    //find the visible cells
//    NSArray *visibleCells = [self.cTableView visibleCells];
//    
//    UIView *lastView = [visibleCells lastObject];
//    bool startAnimation = false;
//    
//    //iterator over all the cells
//    int index = 0;
//    for(ToDoListTableViewCell *cell in visibleCells){
//        if(startAnimation){
//            [UIView animateWithDuration:0.3
//                                  delay:delay
//                                options:UIViewAnimationOptionCurveEaseInOut
//                             animations:^{
//                                 cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
//                                 //cell.backgroundColor = [self colorForIndex:index-1];
//                             }
//                             completion:^(BOOL finished){
//                                 if(cell == lastView ){
//                                     [self.cTableView reloadData];
//                                 }
//                             }];
//            delay += 0.03;
//        }
//        if( cell.toDoItem == item ){
//            startAnimation = true;
//            cell.hidden = YES;
//        }
//        index ++;
//    }
    return [self.delegate toDoItemDeleted:item];
}


@end
