//
//  ViewController.h
//  NSUserDefaut Segue and Protocols Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *password;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pass;

@end

