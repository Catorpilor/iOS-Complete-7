//
//  ToDoListManager.m
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListManager.h"
#import "ToDoListModel.h"


@interface ToDoListManager()

@property (nonatomic,strong) NSMutableArray *toDoItems;


@end

@implementation ToDoListManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

//add todo list
-(void)addToDoListWithText:(NSString *)text{
    if(!self.toDoItems){
        self.toDoItems = [[NSMutableArray alloc] init];
    }
    [self.toDoItems addObject:[ToDoListModel toDoListWithText:text]];
//    [[NSUserDefaults standardUserDefaults] setObject:self.toDoItems forKey:@TODOITEM_LIST];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSMutableArray *)listToDoItems{
//    NSArray *lists = [[NSUserDefaults standardUserDefaults] arrayForKey:@TODOITEM_LIST];
//    return lists;
    return self.toDoItems;
}


@end
