//
//  AEMCustomCell.h
//  AEMCollapsibleTableView
//
//  Created by arthur.e.mayes on 4/8/15.
//  Copyright (c) 2015 arthur.e.mayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AEMCustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *label1;
@property (nonatomic, weak) IBOutlet UILabel *label2;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
