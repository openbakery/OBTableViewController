//
//
// Created by René Pirringer

//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBAbstractTableViewController.h>

/**
* Simple TableViewController that supports only one section
*/
@interface OBSimpleTableViewController : OBAbstractTableViewController


/**
 * Appends a single model.
 */
- (void)addModel:(NSObject *)model;

/**
* Appends the given list of models.
*/
- (void)addModels:(NSArray *)models;

/**
* replaces all models
*/
- (void)setModels:(NSArray *)models;

/**
* Deletes all modles, so the table view is empty after calling this method
*/
- (void)removeAllModels;
@end
