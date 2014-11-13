//
//  ToDoListManager.h
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoListModel.h"

#define TODOITEM_LIST "to do list item"

@interface ToDoListManager : NSObject

+ (instancetype)sharedManager;

-(void)addToDoListWithText:(NSString *)text;

//@property (nonatomic, strong, readonly) NSArray *toDoListArray;
//@property (nonatomic, strong, readonly) NSArray *doneListArray;
-(NSMutableArray *)listToDoItems;

@end
