//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBAbstractTableViewController.h"

@class OBTableViewSection;


@interface OBTableViewController : OBAbstractTableViewController

@property(nonatomic) BOOL editing;

- (void)addSection:(OBTableViewSection *)section;

- (void)addModel:(NSObject *)model toSection:(OBTableViewSection *)section;
- (void)addModels:(NSArray *)models toSection:(OBTableViewSection *)section;

- (void)deleteAllModelsFromSection:(OBTableViewSection *)section;

- (NSArray *)modelsForSection:(OBTableViewSection *)section;

/**
* Inserts the model to the section on the first position.
*/
- (void)insertModel:(NSObject *)model toSection:(OBTableViewSection *)section;

/**
* Inserts the model from the given array to the section on the first position.
*/
- (void)insertModels:(NSArray *)models toSection:(OBTableViewSection *)section;


/**
* Inserts the model at the end of the given section
*/
- (void)appendModel:(NSObject *)model toSection:(OBTableViewSection *)section;

/**
* Inserts the model at the end of the given section
*/
- (void)appendModels:(NSArray *)models toSection:(OBTableViewSection *)section;


- (void)insertModel:(NSObject *)model after:(NSObject*)after;
- (void)insertModel:(NSObject *)model before:(NSObject *)before;

- (void)removeModel:(NSObject *)model;

- (void)removeModels:(NSArray *)modelsToRemove;

- (void)reloadCellForModel:(NSObject *)object;

- (void)reloadTableView;


- (void)removeAllModelsFromSection:(OBTableViewSection *)section;

- (void)setEditing:(BOOL)b animated:(BOOL)animated;

@end