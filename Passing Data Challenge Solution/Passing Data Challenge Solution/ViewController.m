//
//  ViewController.m
//  Passing Data Challenge Solution
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.destinationViewController isKindOfClass:[DetailsViewController class]]){
        DetailsViewController *detailsVC = segue.destinationViewController;
       // detailsVC.updateText.text= self.myText.text;
        NSLog(@"%@",self.myText.text);
        detailsVC.delegate = self;
    }

}


#pragma mark - DetaisViewController Delegate

-(void)didCancelPressed{
    NSLog(@"cancel pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)updatePressed:(NSString *)newText{
    self.myText.text = newText;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
