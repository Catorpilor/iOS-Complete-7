//
//  ToDoListModel.h
//  ToDoLists
//
//  Created by cheshire on 14/11/11.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ONE_DAY_SECONDS 5184000

@interface ToDoListModel : NSObject

@property (nonatomic,strong) NSString *toDoGoal;
@property (nonatomic) BOOL   bOutOfDate;
@property (nonatomic) BOOL   bChecked;
@property (nonatomic,strong) NSDate *endTime;

@end
