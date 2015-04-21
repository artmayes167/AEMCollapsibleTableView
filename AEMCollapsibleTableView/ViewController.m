//
//  ViewController.m
//  AEMCollapsibleTableView
//
//  Created by arthur.e.mayes on 4/7/15.
//  Copyright (c) 2015 arthur.e.mayes. All rights reserved.
//

#import "ViewController.h"
#import "AEMCollapsibleTableViewController.h"

@interface ViewController () <CollapsibleDataSource>

@property (nonatomic, strong) AEMCollapsibleTableViewController *collapsibleController;
@property (nonatomic, strong) NSArray *rowArray;

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.collapsibleController = segue.destinationViewController;
    self.collapsibleController.dataSource = self;
    
}

-(NSArray *)arrayOfArraysOfDictionariesForPopulatingSectionRows
{
    if (!self.rowArray) {
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < 4; i++) {
            NSDictionary *dict = @{@"image" : @"th.jpg", @"label1" : @"Hi!", @"label2" : @"This is default mode"};
            NSArray *insideArray = @[dict, dict];
            [array addObject:insideArray];
        }
        self.rowArray = array;
    }
    return self.rowArray;
}

@end
