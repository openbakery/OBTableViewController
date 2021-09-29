//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBAbstractTableViewController.h>

@class OBTableViewSection;


@interface OBTableViewController : OBAbstractTableViewController

@property(nonatomic) BOOL editing;

- (void)addSection:(OBTableViewSection *)section;

- (NSArray *)sections;

- (NSInteger)indexForSection:(OBTableViewSection *)section;

- (OBTableViewSection *)sectionAtIndex:(NSInteger)section;

/**
* Adds a model to the table into the given section
* Added models does not trigger a reload of the table, therefor adding can be done before the table is shown,
* or a reloadTableView muss be called afterwards, so that the items are displayed
*/
- (void)addModel:(NSObject *)model toSection:(OBTableViewSection *)section;


/**
* Adds the given list of models to the table into the given section
* Added models does not trigger a reload of the table, therefor adding can be done before the table is shown,
* or a reloadTableView muss be called afterwards, so that the items are displayed
*/
- (void)addModels:(NSArray *)models toSection:(OBTableViewSection *)section;

/*
 *	Deletes all the models from the given section
 *  Here no table animation is triggered
 */
- (void)deleteAllModelsFromSection:(OBTableViewSection *)section;

- (NSArray *)modelsForSection:(OBTableViewSection *)section;

/**
* Inserts the model to the section on the first position. Insert means that the item is animated into the visible table.
*/
- (void)insertModel:(NSObject *)model toSection:(OBTableViewSection *)section;

/**
* Inserts the model from the given array to the section on the first position.
*/
- (void)insertModels:(NSArray *)models toSection:(OBTableViewSection *)section;


/**
* Inserts the model at the end of the given section. When appending models to the table, the a new cell is animated with the table data into the table.
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


/**
 * Sets the given models to the section. Here the models are merged with the current models. Here the missing modeles are inserted, and removed models are removed.
 * So this method takes care that everything is properly animated.
 */
- (void)setModels:(NSArray *)models toSection:(OBTableViewSection *)section;

- (void)reloadCellForModel:(NSObject *)object;

- (void)reloadTableView;


- (void)removeAllModelsFromSection:(OBTableViewSection *)section;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated;



@end
