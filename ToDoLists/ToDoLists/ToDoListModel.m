//
//  ToDoListModel.m
//  ToDoLists
//
//  Created by cheshire on 14/11/11.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListModel.h"

@implementation ToDoListModel

-(id)initWithText:(NSString *)text{
    if(self = [super init]){
        self.toDoGoal = text;
    }
    return self;
}

+(id)toDoListWithText:(NSString *)text{
    return [[ToDoListModel alloc] initWithText:text];
}

@end
