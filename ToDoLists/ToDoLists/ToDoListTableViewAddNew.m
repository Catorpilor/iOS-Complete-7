//
//  ToDoListTableViewAddNew.m
//  ToDoLists
//
//  Created by cheshire on 14/11/17.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListTableViewAddNew.h"
#import "ToDoListTable.h"

@implementation ToDoListTableViewAddNew{
    //a cell that rendered as a placeholder to indicate where a new item is added
    ToDoListTableViewCell * _placeHolderCell;
    //indicates the state of this behavior
    BOOL _pullDownInProgress;
    ToDoListTable *_tableView;
}

-(id)initWithTableView:(ToDoListTable *)tableView{
    if(self = [super init]){
        _placeHolderCell = [[ToDoListTableViewCell alloc] init];
        _placeHolderCell.backgroundColor = [UIColor redColor];
        _tableView = tableView;
        _tableView.scrollViewDelegate =self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //this behavior starts when a user pulls down while at the top of the table
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if(_pullDownInProgress){
        //add your place holder
        [_tableView insertSubview:_placeHolderCell atIndex:0];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[super scrollViewDidScroll:scrollView];
    
    if(_pullDownInProgress && _tableView.scrollView.contentOffset.y <= 0.0f) {
        //maintain the location of the placeholder
        _placeHolderCell.frame = CGRectMake(0, - _tableView.scrollView.contentOffset.y - TODOLIST_ROW_HEIGHT,_tableView.frame.size.width, TODOLIST_ROW_HEIGHT);
        _placeHolderCell.label.text = -_tableView.scrollView.contentOffset.y > TODOLIST_ROW_HEIGHT ?
        @"Release to Add Item" : @"Pull to Add Item";
        _placeHolderCell.alpha = MIN(1.0f, - _tableView.scrollView.contentOffset.y / TODOLIST_ROW_HEIGHT);
    }else{
        _pullDownInProgress = false;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //check whether the user pulled down far enough
    if(_pullDownInProgress && -_tableView.scrollView.contentOffset.y > TODOLIST_ROW_HEIGHT){
        //add new item
        [_tableView.dataSource itemAdded];
    }
    _pullDownInProgress = false;
    [_placeHolderCell removeFromSuperview];
}

@end
