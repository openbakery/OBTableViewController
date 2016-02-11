//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class OBAbstractTableViewController;

@protocol OBTableViewControllerDelegate <NSObject>

@optional

/**
* this method is called when the cell for the given model was selected
*/
- (void)didSelectModel:(NSObject *)model;


/**
* this method is called when the accessory for the given model was selected
*/
- (void)tableViewController:(OBAbstractTableViewController *)tableViewController didSelectAccessoryForModel:(NSObject *)model;


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



/**
* this method is called when the cell for the given model was deleted
*/
- (void)tableViewController:(OBAbstractTableViewController *)tableViewController didDeleteModel:(NSObject *)model;


/**
* this method is called when a cell will be displayed
*/
- (void)tableViewController:(OBAbstractTableViewController *)tableViewController willDisplayCell:(UITableViewCell *)cell withModel:(NSObject *)model;




@end