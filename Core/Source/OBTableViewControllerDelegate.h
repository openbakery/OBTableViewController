//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>

@class OBAbstractTableViewController;

@protocol OBTableViewControllerDelegate <NSObject>

@optional

- (void)didSelectModel:(NSObject *)model;

/**
* Method to ask the delegate if the given model should be selected
* If return NO the given model is not selected
*/
- (BOOL)shouldSelectModel:(NSObject *)model;


/**
* Method to ask the delegete if the given model should be deselected.
* If the table view controller is in single selection mode, this method is not called when another model is selected and current selected is deselected.
*/
- (BOOL)shouldDeselectModel:(NSObject *)model;


- (void)tableViewController:(OBAbstractTableViewController *)tableViewController willDisplayCell:(UITableViewCell *)cell;
@end