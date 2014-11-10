//
//  DetailsViewController.h
//  Passing Data Challenge Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailsViewControllerDelegate <NSObject>

@required

-(void)didCancelPressed;
-(void)updatePressed: (NSString *)newText;

@end


@interface DetailsViewController : UIViewController

//property
@property (nonatomic, weak) id <DetailsViewControllerDelegate> delegate;

- (IBAction)didCancel:(UIButton *)sender;
- (IBAction)didUpdate:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *updateText;

@end
