//
//  AEMCollapsibleTableViewController.h
//  AEMCollapsibleTableView
//
//  Created by arthur.e.mayes on 4/7/15.
//  Copyright (c) 2015 arthur.e.mayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollapsibleDataSource <NSObject>
@optional
- (NSArray *)arrayOfViewsForPopulatingSectionHeaders;

@required
// Keys: "image", "label1", "label2", "textField", "textView"
// Values should all be strings
// Each array within this array will correspond to a given section
- (NSArray *)arrayOfArraysOfDictionariesForPopulatingSectionRows;

@end

IB_DESIGNABLE

@interface AEMCollapsibleTableViewController : UITableViewController

/*
    Uses headers as initial rows, and populates collapsing rows when header is selected
    Only supports one being "open" at a time.
 */

// The image you set in the cell will not rotate by default
@property (nonatomic) IBInspectable BOOL imageShouldRotateOnSelection;

// If imageShouldRotateOnSelection, defaults to 45 degree clockwise rotation
@property (nonatomic) CGFloat angleOfRotation;

@property (nonatomic, strong) IBInspectable NSString *reuseIdentifier;

@property (nonatomic, strong) IBInspectable UIColor *tableViewBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *rowBackgroundColor;

// default to 68
@property (nonatomic) CGFloat sectionHeight;
// default to 50
@property (nonatomic) CGFloat rowHeight;

@property (nonatomic, weak) id<CollapsibleDataSource> dataSource;

@end
