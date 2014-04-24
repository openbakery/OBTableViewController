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
@property (nonatomic, assign) id<OBTableViewControllerDelegate> delegate;
@property (nonatomic, readonly) NSArray* selectedModels;


- (void) addPropertyBinding:(OBPropertyBinding *)binding;
- (void) removeAllPropertyBindings;

- (OBModelCellBinding *)bindingForModel:(id)model andCell:(UITableViewCell *)cell;
- (void)registerIdentifier:(NSString *)string modelClass:(Class)class;

- (NSIndexPath *)indexPathForModel:(NSObject *)object;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)setSelectedModel:(id)model;

- (NSArray *)modelsForSectionIndex:(NSInteger )section;

- (id)modelForCell:(id)cell;
- (UITableViewCell *)cellForModel:(id)model;


@end