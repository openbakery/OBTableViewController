//
//  OBInsertViewController.h
//  OBTableViewController
//
//  Created by Rene Pirringer on 28.07.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OBTableViewSection;

typedef void (^InsertCompletionBlock)(NSString *name, OBTableViewSection *section);


@interface OBInsertViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIPickerView *sectionPicker;
@property (strong, nonatomic) IBOutlet UIButton *insertButton;
@property(nonatomic, strong) NSArray *sections;
@property(nonatomic, copy) InsertCompletionBlock completion;
@end
