//
//  ViewController.m
//  ToDoLists
//
//  Created by cheshire on 14/11/10.
//  Copyright (c) 2014年 cheshire. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "ToDoListManager.h"


@interface ViewController ()

@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic,strong) NSDateFormatter *dayFormatter;
@property (nonatomic,strong) NSDateFormatter *originalFormatter;

@end

@implementation ViewController

- (id)init {
    if (self = [super init]) {
        _dayFormatter = [[NSDateFormatter alloc] init];
        _dayFormatter.dateFormat = @"hh:mm:ss";
        
        _originalFormatter = [[NSDateFormatter  alloc] init];
        _originalFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //init the view
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect headerFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    
    UIImage *image = [UIImage imageNamed:@"bg.png"];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:image ];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // 3
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:image blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    // 4
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = header;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)configureActiveToDoCell:(UITableViewCell *)cell withModel:(ToDoListModel *)model {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = model.toDoGoal;
    if([model.endTime timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] < ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Today " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    if([model.endTime timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970] < 2*ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Tomorrow " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    cell.imageView.image = nil;
}

- (void)configureOverdueToDoCell:(UITableViewCell *)cell withModel:(ToDoListModel *)model {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = model.toDoGoal;
    if([[NSDate date] timeIntervalSince1970] - [model.endTime timeIntervalSince1970]  < ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Today " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    if([[NSDate date] timeIntervalSince1970] - [model.endTime timeIntervalSince1970]   < 2*ONE_DAY_SECONDS ){
        cell.detailTextLabel.text = [@"Yesterday " stringByAppendingString:[self.dayFormatter stringFromDate:model.endTime]];
    }
    cell.imageView.image = nil;
}


#pragma make - UITableViewController DataSource
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"List Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

#pragma mark -UITableViewController Delegate

@end
