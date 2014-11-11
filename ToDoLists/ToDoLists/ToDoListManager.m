//
//  ToDoListManager.m
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ToDoListManager.h"



@interface ToDoListManager()



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



@end
