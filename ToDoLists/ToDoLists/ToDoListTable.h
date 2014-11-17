//
//  ToDoListTable.h
//  ToDoLists
//
//  Created by cheshire on 14/11/15.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoListTableViewCell.h"


@protocol ToDoListTableDateSource <NSObject>

-(NSInteger)numberOfRows;
-(UIView *)cellForRow:(NSInteger) row;
-(void)itemAdded;
-(void)itemAddedAtIndex:(NSInteger)index;
-(void)itemDeletedAtIndex:(NSInteger)index;

@end

//@class ToDoListModel;

@protocol TodoListTableViewDelegate <NSObject>

-(void)cellDidBeginEditing:(ToDoListTableViewCell *)cell;
-(void)cellDidEndEditing:(ToDoListTableViewCell *)cell;
-(void)toDoItemDeleted:(ToDoListModel *)item;

@end

#define TODOLIST_ROW_HEIGHT  88.0f
#define TODOLIST_ROW_WITH_REMAINDER_HEIGHT  80.0f

@interface ToDoListTable : UIView <UIScrollViewDelegate, ToDoListTableViewCellDelegate>

@property (nonatomic,assign) id<ToDoListTableDateSource> dataSource;
@property (nonatomic, assign) id<TodoListTableViewDelegate> delegate;
@property  (nonatomic,weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nonatomic,assign,readonly) UIScrollView *scrollView;

//methods

//dequeues a cell that can be reused
-(UIView *)dequeueResuableCell;
//registers a class for use as new cells
-(void)registerClassForCells:(Class)cellClass;

//an array of cells that are currently visible, sorted from top to bottom
-(NSArray *)visibleCells;


//forces the table to dispose of all the cells and rebuild the table
-(void)reloadData;

@end
