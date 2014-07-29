//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBTableViewController.h"
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

- (void)dealloc {
	_tableView.dataSource = nil;
	_tableView.delegate = nil;
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
	NSObject *model = [self modelAtIndexPath:indexPath];
	if ([self.delegate respondsToSelector:@selector(tableViewController:willDisplayCell:withModel:)]) {
		[self.delegate tableViewController:self willDisplayCell:cell withModel:model];
	}
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
		  CGFloat height = cell.frame.size.height;
		  if (height == 0) {
				height = 44.0f;
		  }
		  [_cellHeightForModelClass setObject:@(height) forKey:className];
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

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (self.selectionMode) {
		case OBTableViewControllerSelectionModeNone:
			break;
		case OBTableViewControllerSelectionSingleSelection: {
			BOOL shouldSelect = YES;
			if ([self.delegate respondsToSelector:@selector(shouldSelectModel:)]) {
				shouldSelect = [self.delegate shouldSelectModel:model];
			}
			if (shouldSelect) {
				[self setSelectedModel:model];
			}
			break;
		}
		case OBTableViewControllerSelectionSingleCheck: {
			if (model == _selectedModel) {
				BOOL shouldDeselect = YES;
				if ([self.delegate respondsToSelector:@selector(shouldDeselectModel:)]) {
					shouldDeselect = [self.delegate shouldDeselectModel:_selectedModel];
				}
				if (shouldDeselect) {
					_selectedModel = nil;
					[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
			break;
		}

	}

	if ([self.delegate respondsToSelector:@selector(didSelectModel:)]) {
		[self.delegate didSelectModel:model];
	}

}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	NSObject *model = [self modelAtIndexPath:indexPath];
	if ([self.delegate respondsToSelector:@selector(tableViewController:didSelectAccessoryForModel:)]) {
		[self.delegate tableViewController:self didSelectAccessoryForModel:model];
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
		[self.tableView reloadRowsAtIndexPaths:indicesToUpdate withRowAnimation:UITableViewRowAnimationNone];
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


- (void)scrollToModel:(NSObject *)model {
	NSIndexPath *indexPath = [self indexPathForModel:model];
	if (indexPath) {
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
	}

}


- (void)deselectAll {
	_selectedModel = nil;
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	if (indexPath) {
		[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	}
}
@end