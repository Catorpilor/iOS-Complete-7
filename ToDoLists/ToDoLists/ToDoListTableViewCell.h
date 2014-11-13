//
//  ToDoListTableViewCell.h
//  ToDoLists
//
//  Created by cheshire on 14/11/13.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoListModel.h"
//@class ToDoListModel;

@protocol ToDoListTableViewCellDelegate <NSObject>

-(void)toDoItemDeleted:(ToDoListModel *)item;
//-(void)todoItemCompleted:(ToDoListModel *)item;

@end

@interface ToDoListTableViewCell : UITableViewCell

@property  (nonatomic,assign) id<ToDoListTableViewCellDelegate> delegate;
@property (nonatomic) ToDoListModel *toDoItem;

@end
