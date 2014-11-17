//
//  ToDoListTableViewCell.h
//  ToDoLists
//
//  Created by cheshire on 14/11/13.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoListModel.h"
#import "ToDoListStrikeThroughLable.h"
//@class ToDoListModel;

@class ToDoListTableViewCell;

@protocol ToDoListTableViewCellDelegate <NSObject>

-(void)toDoItemDeleted:(ToDoListModel *)item;
//-(void)todoItemCompleted:(ToDoListModel *)item;

//indicates that the edit process has begun for the given cell
-(void)cellDidBeginEditing:(ToDoListTableViewCell *)cell;

//indicates that the edit process has committed for the given cell
-(void)cellDidEndEditing:(ToDoListTableViewCell *)cell;

////delete the specified cell
//-(void)deleteCell:(ToDoListTableViewCell *)cell;


@end

@interface ToDoListTableViewCell : UITableViewCell <UITextFieldDelegate>

@property  (nonatomic,assign) id<ToDoListTableViewCellDelegate> delegate;
@property (nonatomic) ToDoListModel *toDoItem;
@property (nonatomic,strong,readonly) ToDoListStrikeThroughLable *label;


@end
