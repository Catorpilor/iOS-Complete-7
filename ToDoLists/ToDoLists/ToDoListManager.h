//
//  ToDoListManager.h
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoListModel.h"

@interface ToDoListManager : NSObject

+ (instancetype)sharedManager;

//@property (nonatomic, strong, readonly) NSArray *toDoListArray;
//@property (nonatomic, strong, readonly) NSArray *doneListArray;

@end
