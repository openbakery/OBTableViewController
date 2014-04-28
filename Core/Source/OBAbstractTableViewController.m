//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBAbstractTableViewController.h"
#import "OBModelCellBinding.h"
#import "UILabelPropertyBinding.h"
#import "UIImageViewPropertyBinding.h"
#import "UILabelToDatePropertyBinding.h"
#import "UIDatePickerPropertyBinding.h"
#import "OBAccessoryPropertyBinding.h"
#import "DDLog.h"


@interface OBAbstractTableViewController ()
@end

@implementation OBAbstractTableViewController {
	NSMutableDictionary *_cellHeightForModelClass;
	NSMutableArray *_propertyBindings;
	NSObject *_selectedModel;
}


- (id)init {
	self = [super init];
	if (self) {
		_modelCellBindings = [[NSMutableDictionary alloc] init];
		_propertyBindings = [[NSMutableArray alloc] init];

		[self setupBinding];


	}
	return self;
}


- (void)setupBinding {
	[self addPropertyBinding:[[UILabelPropertyBinding alloc] initWithSourceName:@"text" andDestinationName:@"textLabel"]];
	[self addPropertyBinding:[[UIImageViewPropertyBinding alloc] initSourceName:@"image" andDestinationName:@"imageView"]];
	[self addPropertyBinding:[[UILabelToDatePropertyBinding alloc] initSourceName:@"date" andDestinationName:@"detailTextLabel"]];
	[self addPropertyBinding:[[UIDatePickerPropertyBinding alloc] initSourceName:@"date" andDestinationName:@"datePicker"]];
	[self addPropertyBinding:[[OBAccessoryPropertyBinding alloc] initSourceName:@"accessoryType" andDestinationName:@"accessoryType"]];
	[self addPropertyBinding:[[UILabelPropertyBinding alloc] initWithSourceName:@"title" andDestinationName:@"titleLabel"]];

}

- (void) removeAllPropertyBindings {
	_propertyBindings = [[NSMutableArray alloc] init];
}

- (void) addPropertyBinding:(OBPropertyBinding *)binding {
	[_propertyBindings addObject:binding];
}



- (void)setTableView:(UITableView *)tableView {
	_tableView = tableView;
	_tableView.dataSource = self;
	_tableView.delegate = self;
}

- (void)registerIdentifier:(NSString *)identifier modelClass:(Class)clazz {
	if (!_registeredIdentifiers) {
		_registeredIdentifiers = [[NSMutableDictionary alloc] init];
	}
	[_registeredIdentifiers setObject:identifier forKey:NSStringFromClass(clazz)];
}

- (OBModelCellBinding *)bindingForModel:(NSObject *)model andCell:(UITableViewCell *)cell {

	Class modelClass = [model class];
	OBModelCellBinding *binding = [_modelCellBindings objectForKey:NSStringFromClass(modelClass)];
	if (!binding) {
		binding = [[OBModelCellBinding alloc] initWithModelClass:modelClass andCellClass:[cell class] andPropertyBindings:_propertyBindings];
		[_modelCellBindings setObject:binding forKey:NSStringFromClass(modelClass)];
	}
	return binding;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSArray *models = [self modelsForSectionIndex:section];
	return [models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *model = [self modelAtIndexPath:indexPath];
	if (!model) {
		DDLogDebug(@"No model found at indexPath[row=%d, section=%d] so return an empty cell", (int)indexPath.row, (int)indexPath.section);
		return [[UITableViewCell alloc] init];
	}

	UITableViewCell *cell;
	NSString *identifier = [_registeredIdentifiers objectForKey:NSStringFromClass([model class])];
	if (identifier) {
		cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	} else {
		DDLogDebug(@"No identifer is registered for model class '%@', so using UITableViewCell", [model class]);
	}

	if (!cell) {
		DDLogDebug(@"Using UITableViewCell");
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}




	OBModelCellBinding *binding = [self bindingForModel:model andCell:cell];
	[binding setValuesForCell:cell usingModel:model];


	if (self.selectionMode == OBTableViewControllerSelectionSingleCheck) {
		if ([model isEqual:_selectedModel]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}

	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.delegate respondsToSelector:@selector(tableViewController:willDisplayCell:)]) {
		[self.delegate tableViewController:self willDisplayCell:cell];
	}
	NSObject *model = [self modelAtIndexPath:indexPath];
	if (self.selectionMode == OBTableViewControllerSelectionSingleSelection) {
		cell.selected = [model isEqual:_selectedModel];
	}

}


- (id) modelAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *models = [self modelsForSectionIndex:indexPath.section];
	if (models && [models count] > indexPath.row) {
		return [models objectAtIndex:indexPath.row];
	}
	return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject *model = [self modelAtIndexPath:indexPath];
	if (model) {
		return [self heightForRowWithModel:model];
	}
	return 44.0f;

}

- (CGFloat)heightForRowWithModel:(NSObject *)model {
	NSString *className = NSStringFromClass([model class]);

	if (!_cellHeightForModelClass) {
		// lazy initialize heights
		_cellHeightForModelClass = [[NSMutableDictionary alloc] init];

		[_registeredIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString *className, NSString *identifier, BOOL *stop) {
			UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
			[_cellHeightForModelClass setObject:[NSNumber numberWithFloat:cell.frame.size.height] forKey:className];
		}];


	}
	NSNumber *value = (NSNumber *)[_cellHeightForModelClass objectForKey:className];
	if (value) {
		return [value floatValue];
	}
	return 44.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	NSObject *model = [self modelAtIndexPath:indexPath];

	if (self.selectionMode == OBTableViewControllerSelectionModeNone) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}

	if (self.selectionMode == OBTableViewControllerSelectionSingleSelection
		) {
		BOOL shouldSelect = YES;
		if ([self.delegate respondsToSelector:@selector(shouldSelectModel:)]) {
			shouldSelect = [self.delegate shouldSelectModel:model];
		}
		if (shouldSelect) {
			[self setSelectedModel:model];
		}
	}

	if (self.selectionMode == OBTableViewControllerSelectionSingleCheck) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		if (model == _selectedModel) {
			BOOL shouldDeselect = YES;
			if ([self.delegate respondsToSelector:@selector(shouldDeselectModel:)]) {
				shouldDeselect = [self.delegate shouldDeselectModel:_selectedModel];
			}
			if (shouldDeselect) {
				_selectedModel = nil;
				[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
		else {
			BOOL shouldSelect = YES;
			if ([self.delegate respondsToSelector:@selector(shouldSelectModel:)]) {
				shouldSelect = [self.delegate shouldSelectModel:model];
			}
			if (shouldSelect) {
				[self setSelectedModel:model];

			}
		}
	}


	/*
	if (self.selectionMode == OBTableViewControllerSelectionSingleCheck) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];

		if (model == _selectedModel) {
			BOOL shouldDeselect = YES;
			if ([self.delegate respondsToSelector:@selector(shouldDeselectModel:)]) {
				shouldDeselect = [self.delegate shouldDeselectModel:_selectedModel];
			}
			if (shouldDeselect) {
				_selectedModel = nil;
				[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
		else {
			BOOL shouldSelect = YES;
			if ([self.delegate respondsToSelector:@selector(shouldSelectModel:)]) {
				shouldSelect = [self.delegate shouldSelectModel:model];
			}
			if (shouldSelect) {
				[self setSelectedModel:model];
				//NSMutableArray *indicesToUpdate = [[NSMutableArray alloc] init];
				//NSIndexPath *oldIndexPath = [self indexPathForModel:_selectedModel];
				//if (oldIndexPath != nil) {
				//	[indicesToUpdate addObject:oldIndexPath];
				//}
				//[indicesToUpdate addObject:indexPath];
				//_selectedModel = model;
				//[self.tableView reloadRowsAtIndexPaths:indicesToUpdate withRowAnimation:UITableViewRowAnimationAutomatic];
			}
		}
	}
	*/


	if ([self.delegate respondsToSelector:@selector(didSelectModel:)]) {
		[self.delegate didSelectModel:model];
	}

}

- (NSIndexPath *)indexPathForModel:(id)object {
	return nil;
}


- (void)setSelectedModel:(id)model {
	if ([model isEqual:_selectedModel]) {
		// already selected
		return;
	}
	NSMutableArray *indicesToUpdate = [[NSMutableArray alloc] init];
	NSIndexPath *oldIndexPath = [self indexPathForModel:_selectedModel];
	if (oldIndexPath) {
		[indicesToUpdate addObject:oldIndexPath];
	}
	NSIndexPath *newIndexPath = [self indexPathForModel:model];
	if (newIndexPath) {
		[indicesToUpdate addObject:newIndexPath];
		_selectedModel = model;
	} else {
		_selectedModel = nil; // model not found
	}

	if ([indicesToUpdate count]) {
		[self.tableView reloadRowsAtIndexPaths:indicesToUpdate withRowAnimation:UITableViewRowAnimationAutomatic];
	}

}


- (id)modelForCell:(id)cell {
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	if (indexPath) {
		return [self modelAtIndexPath:indexPath];
	}
	return nil;
}

- (UITableViewCell *)cellForModel:(id)model {
	NSIndexPath *indexPath = [self indexPathForModel:model];
	return [self.tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - Methods to override

/**
* Must be overriden
*/
- (NSArray *)modelsForSectionIndex:(NSInteger )section {
	return nil;
}

- (NSArray *)selectedModels {
	if (_selectedModel) {
		return @[_selectedModel];
	}
	return [NSArray array];
}



@end