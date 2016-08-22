//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBTableViewControllerDelegate.h"

@class OBModelCellBinding;
@class OBPropertyBinding;
@protocol OBTableViewCellConfigurator;
@protocol OBPropertyBinding;


typedef void (^OBTableViewControllerCellConfigurationBlock)(UITableViewCell *);

typedef enum {
	OBTableViewControllerSelectionModeNone = 0,
	OBTableViewControllerSelectionSingleSelection,
	OBTableViewControllerSelectionSingleCheck, // add checkmark if the cell is selected
	//DTTableViewControllerSelectionMultipleSelection // only single section implemented
} OBTableViewControllerSelectionMode;


@interface OBAbstractTableViewController : NSObject <UITableViewDataSource, UITableViewDelegate> {
	NSMutableDictionary *_registeredIdentifiers;
	NSMutableDictionary *_modelCellBindings;

}

@property (nonatomic, assign) OBTableViewControllerSelectionMode selectionMode;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<OBTableViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSArray* selectedModels;
@property (nonatomic, assign) BOOL dynamicCellHeight;

@property (nonatomic, strong) OBTableViewControllerCellConfigurationBlock cellConfigurationBlock;

- (void) addPropertyBinding:(OBPropertyBinding *)binding;
- (void) removeAllPropertyBindings;

- (OBModelCellBinding *)bindingForModel:(id)model andCell:(UITableViewCell *)cell;

/**
* Registers a identifier for a cell from a storyboard for a model class.
*/
- (void)registerIdentifier:(NSString *)identifier modelClass:(Class)modelClass;

- (void)registerTableViewCellClass:(Class)tableViewCellClass modelClass:(Class)modelClass;

- (NSIndexPath *)indexPathForModel:(NSObject *)object;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)setSelectedModel:(id)model;

- (NSArray *)modelsForSectionIndex:(NSInteger )section;

- (id)modelForCell:(id)cell;
- (UITableViewCell *)cellForModel:(id)model;

- (void)scrollToModel:(NSObject *)model;

- (void)deselectAll;


/**
* if the keyboard appears the table view insets are modified if this was enabled using this methods
*/
- (void)enableModifyInsetsForKeyboard;

/**
* disables the insets modification for the table view. The should be done when the view controller disappears.
*/
- (void)disableModifyInsetsForKeyboard;

@end