//
//  DetailsViewController.m
//  Passing Data Challenge Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didCancel:(UIButton *)sender {
    [self.delegate didCancelPressed];
}

- (IBAction)didUpdate:(UIButton *)sender {
    if(![self.updateText.text  isEqual: @""]){
        [self.delegate updatePressed:self.updateText.text];
    }else{
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Update String can't be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertV show];
    }
}
@end
