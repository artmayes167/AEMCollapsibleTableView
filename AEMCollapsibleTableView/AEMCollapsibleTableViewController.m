//
//  AEMCollapsibleTableViewController.m
//  AEMCollapsibleTableView
//
//  Created by arthur.e.mayes on 4/7/15.
//  Copyright (c) 2015 arthur.e.mayes. All rights reserved.
//

#import "AEMCollapsibleTableViewController.h"
#import "AEMCustomCell.h"

@interface AEMCollapsibleTableViewController ()

@property (nonatomic, strong) NSArray *headerViews, *rowsInSections;
@property (nonatomic) NSInteger selectedSection;
@property (nonatomic, strong) NSMutableArray *imageViews;

@end

#define NO_SELECTED_TAG -1

@implementation AEMCollapsibleTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedSection = NO_SELECTED_TAG;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.backgroundColor = self.tableViewBackgroundColor;
}

- (NSArray *)headerViews
{
    if (!self.dataSource) {
        NSException *exception = [NSException exceptionWithName:@"Need Datasource" reason:@"You need to set the dataSource variable for AEMCollapsibleTableViewController, and optionally implement arrayOfViewsForPopulatingSectionHeaders" userInfo:nil];
        @throw exception;
        return @[];
    }
    
    if ([self.dataSource respondsToSelector:@selector(arrayOfViewsForPopulatingSectionHeaders)]) {
        _headerViews = [self.dataSource arrayOfViewsForPopulatingSectionHeaders];
    } else {
        // Default views for functionality with no setup here
        NSMutableArray *array = [NSMutableArray new];
        for (int i = 0; i < [self.rowsInSections count]; i++) {
            CGRect rect = CGRectMake(0, 0, self.tableView.frame.size.width, 68);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            [view setBackgroundColor:[UIColor blackColor]];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 40, 40)];
            [imageView setImage:[UIImage imageNamed:@"arrow"]];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(58, 23, self.tableView.frame.size.width - 66, 21)];
            [label setText:[NSString stringWithFormat:@"Section %i", i]];
            [label setTextColor:[UIColor whiteColor]];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 67, self.tableView.frame.size.width, 1)];
            [lineView setBackgroundColor:[UIColor lightGrayColor]];
            
            [view addSubview:imageView];
            imageView.tag = i;
            [self.imageViews addObject:imageView];
            
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            button.tag = i;
            [button addTarget:self action:@selector(selectedSection:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:label];
            [view addSubview:lineView];
            [array addObject:view];
            [view addSubview:button];
        }
        [self.tableView setBackgroundColor:[UIColor blackColor]];
        self.imageShouldRotateOnSelection = YES;
        _headerViews = array;
    }
    return _headerViews;
}


- (NSArray *)rowsInSections
{
    if (!self.dataSource) {
        NSException *exception = [NSException exceptionWithName:@"Need Datasource" reason:@"You need to set the dataSource variable for AEMCollapsibleTableViewController, and implement arrayOfArraysOfDictionariesForPopulatingSectionRows" userInfo:nil];
        @throw exception;
        return @[];
    }
    
    if (!_rowsInSections) {
        if ([self.dataSource respondsToSelector:@selector(arrayOfArraysOfDictionariesForPopulatingSectionRows)]) {
            _rowsInSections = [self.dataSource arrayOfArraysOfDictionariesForPopulatingSectionRows];
        } else {
            NSException *exception = [NSException exceptionWithName:@"Need Datasource" reason:@"You need to set the dataSource variable for AEMCollapsibleTableViewController, and implement arrayOfArraysOfDictionariesForPopulatingSectionRows" userInfo:nil];
            @throw exception;
            return @[];
        }
    }
    return _rowsInSections;
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray new];
        for (UIView *view in self.headerViews) {
            for (id subView in view.subviews) {
                if ([subView isKindOfClass:[UIImageView class]]) {
                    UIImageView *sV = subView;
                    sV.tag = [self.headerViews indexOfObjectIdenticalTo:view];
                    [_imageViews addObject:sV];
                }
            }
        }
    }
    return _imageViews;
}

- (UIColor *)tableViewBackgroundColor
{
    if (!_tableViewBackgroundColor) {
        _tableViewBackgroundColor = [UIColor blackColor];
    }
    return _tableViewBackgroundColor;
}

- (UIColor *)rowBackgroundColor
{
    if (!_rowBackgroundColor) {
        _rowBackgroundColor = [UIColor whiteColor];
    }
    return _rowBackgroundColor;
}

- (CGFloat)sectionHeight
{
    if (!_sectionHeight) return 68;
    else return _sectionHeight;
}

- (CGFloat)rowHeight
{
    if (!_rowHeight) return 50;
    else return _rowHeight;
}

- (CGFloat)angleOfRotation
{
    if (!_angleOfRotation) _angleOfRotation = (90.0f * M_PI) / 180.0f;
    return _angleOfRotation;
}

- (void)selectedSection:(UIButton *)sender
{
    NSInteger previouslySelectedSection = NO_SELECTED_TAG;
    if (!(self.selectedSection == NO_SELECTED_TAG)) {
        previouslySelectedSection = self.selectedSection;
    }
    
    if (sender.tag == self.selectedSection) self.selectedSection = NO_SELECTED_TAG;
    else self.selectedSection = sender.tag;
    
    // Rotate imageViews
    if (self.imageShouldRotateOnSelection) {
        for (UIImageView *imageView in self.imageViews) {
            if (imageView.tag == self.selectedSection) {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.transform = CGAffineTransformMakeRotation(self.angleOfRotation);
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    imageView.transform = CGAffineTransformMakeRotation(0);
                }];
            }
        }
    }
    
    NSMutableArray *deleteArray;
    if (!(previouslySelectedSection == NO_SELECTED_TAG)) {
        deleteArray = [NSMutableArray new];
        for (int i = 0 ; i < [self.rowsInSections[previouslySelectedSection] count] ; i++) {
            [deleteArray addObject:[NSIndexPath indexPathForItem:i inSection:previouslySelectedSection]];
        }
    }
    NSMutableArray *insertArray;
    if (!(self.selectedSection == NO_SELECTED_TAG)) {
        insertArray = [NSMutableArray new];
        for (int i = 0 ; i < [self.rowsInSections[self.selectedSection] count] ; i++) {
            [insertArray addObject:[NSIndexPath indexPathForItem:i inSection:self.selectedSection]];
        }
    }
    
    [self.tableView beginUpdates];
    if (deleteArray) {
        [self.tableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
    }
    if (insertArray) {
        [self.tableView insertRowsAtIndexPaths:insertArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.headerViews) return [self.headerViews count];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.selectedSection) {
        return [self.rowsInSections[section] count];
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if  (self.reuseIdentifier) {
        AEMCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier forIndexPath:indexPath];
        
        NSArray *array = self.rowsInSections[indexPath.section];
        NSDictionary *dict = array[indexPath.row];
        
        
        cell.iconImageView.image = [UIImage imageNamed:dict[@"image"]];
        cell.label1.text = dict[@"label1"];
        cell.label2.text = dict[@"label2"];
        cell.textView.text = dict[@"textView"];
        cell.textField.text = dict[@"textField"];
        cell.contentView.backgroundColor = self.rowBackgroundColor;
        [cell.contentView setNeedsLayout];
        
        return cell;
    } else {
        NSException *exception = [NSException exceptionWithName:@"Need Reuse Identifier" reason:@"You need to set the reuseIdentifier value in AEMCollapsibleTableViewController.  You can do this in code, or in the storyboard." userInfo:nil];
        @throw exception;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerViews[section];
}

@end
