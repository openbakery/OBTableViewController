//
//
// Created by Rene Pirringer.
//
//
//

#import <objc/runtime.h>
#import "OBTableViewController.h"
#import "OBModelCellBinding.h"
#import "UILabelPropertyBinding.h"
#import "UIImageViewPropertyBinding.h"
#import "UILabelToDatePropertyBinding.h"
#import "UIDatePickerPropertyBinding.h"
#import "OBAccessoryPropertyBinding.h"
#import "OBModelBasedCell.h"

@interface OBAbstractTableViewController ()
@property(nonatomic) UIEdgeInsets defaultTableInset;
@property(nonatomic, strong) NSMutableDictionary *cellHeightForModelClass;
@end

@implementation OBAbstractTableViewController {
	NSMutableArray *_propertyBindings;
	NSObject *_selectedModel;
}


- (id)init {
	self = [super init];
	if (self) {
		self.dynamicCellHeight = NO;
		_modelCellBindings = [[NSMutableDictionary alloc] init];
		_propertyBindings = [[NSMutableArray alloc] init];
		[self setupBinding];
		self.defaultTableInset = UIEdgeInsetsZero;
	}
	return self;
}

- (void)dealloc {
	[self disableModifyInsetsForKeyboard];
	_tableView.dataSource = nil;
	_tableView.delegate = nil;

}

- (void)enableModifyInsetsForKeyboard {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)disableModifyInsetsForKeyboard {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setupBinding {
	[self addPropertyBinding:[[UILabelPropertyBinding alloc] initWithSourceName:@"text" andDestinationName:@"textLabel"]];
	[self addPropertyBinding:[[UILabelPropertyBinding alloc] initWithSourceName:@"detailText" andDestinationName:@"detailTextLabel"]];
	[self addPropertyBinding:[[UIImageViewPropertyBinding alloc] initWithSourceName:@"image" andDestinationName:@"imageView"]];
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

	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
		_tableView.estimatedRowHeight = 44.0;
		_tableView.rowHeight = UITableViewAutomaticDimension;
	}

}

- (void)registerIdentifier:(NSString *)identifier modelClass:(Class)modelClass {
	if (!_registeredIdentifiers) {
		_registeredIdentifiers = [[NSMutableDictionary alloc] init];
	}
	[_registeredIdentifiers setObject:identifier forKey:[self identifierForClass:modelClass]];
}

- (void)registerTableViewCellClass:(Class)tableViewCellClass modelClass:(Class)modelClass {
	NSString *identifier = [self identifierForClass:tableViewCellClass];
	[self registerIdentifier:identifier modelClass:modelClass];
	[self.tableView registerClass:tableViewCellClass forCellReuseIdentifier:identifier];
}

- (OBModelCellBinding *)bindingForModel:(NSObject *)model andCell:(UITableViewCell *)cell {

	Class modelClass = [model class];
	OBModelCellBinding *binding = [_modelCellBindings objectForKey:[self identifierForClass:modelClass]];
	if (!binding) {
		binding = [[OBModelCellBinding alloc] initWithModelClass:modelClass andCellClass:[cell class] andPropertyBindings:_propertyBindings];
		[_modelCellBindings setObject:binding forKey:[self identifierForClass:modelClass]];
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
		//NSLog(@"No model found at indexPath[row=%d, section=%d] so return an empty cell", (int)indexPath.row, (int)indexPath.section);
		return [[UITableViewCell alloc] init];
	}

	UITableViewCell *cell;
	NSString *identifier = [_registeredIdentifiers objectForKey:[self identifierForObject:model]];
	if (identifier) {
		cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	}

	if (!cell) {
		// make sure that there is a cell instance
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	}


	// a cell instance should only be configured once
	// for every new instance of a cell the cellConfigurationBlock is called where the layout and other stuff of the cell can be configured
	if (![self cellIsConfigured:cell]) {
		if (self.cellConfigurationBlock) {
			self.cellConfigurationBlock(cell);
		}
		[self setCellConfigured:cell];
	}

	if ([cell conformsToProtocol:@protocol(OBModelBasedCell)]) {
		UITableViewCell<OBModelBasedCell> *modelBasedCell = (UITableViewCell<OBModelBasedCell> *)cell;
		[modelBasedCell setModel:model];
	} else {
		OBModelCellBinding *binding = [self bindingForModel:model andCell:cell];
		[binding setValuesForCell:cell usingModel:model];
	}

	[cell setNeedsUpdateConstraints];
	[cell updateConstraintsIfNeeded];


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

static char constCellConfiguredAssociatedObject;

- (void)setCellConfigured:(UITableViewCell *)cell {
	objc_setAssociatedObject(cell, &constCellConfiguredAssociatedObject, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)cellIsConfigured:(UITableViewCell *)cell {
	NSNumber *value = objc_getAssociatedObject(cell, &constCellConfiguredAssociatedObject);
	if (value) {
		return [value boolValue];
	}
	return NO;
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

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
	if ([self.delegate respondsToSelector:@selector(tableViewController:willDisplayHeader:forSection:)]) {
		[self.delegate tableViewController:self willDisplayHeader:view forSection:section];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
	if ([self.delegate respondsToSelector:@selector(tableViewController:willDisplayFooter:forSection:)]) {
		[self.delegate tableViewController:self willDisplayFooter:view forSection:section];
	}
}


- (id) modelAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *models = [self modelsForSectionIndex:indexPath.section];
	if (models && [models count] > indexPath.row) {
		return [models objectAtIndex:indexPath.row];
	}
	return nil;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.dynamicCellHeight) {
		if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
			return UITableViewAutomaticDimension;
		}
	}
	NSObject *model = [self modelAtIndexPath:indexPath];
	if (model) {
		return [self heightForRowWithModel:model];
	}
	return 44.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.dynamicCellHeight) {
		if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
			return UITableViewAutomaticDimension;
		}
	}

	NSObject *model = [self modelAtIndexPath:indexPath];
	if (model) {
		return [self heightForRowWithModel:model];
	}
	return 44.0f;

}

- (CGFloat)heightForRowWithModel:(NSObject *)model {
	NSString *className = [self identifierForObject:model];

	if (!self.cellHeightForModelClass) {
		// lazy initialize heights
		self.cellHeightForModelClass = [[NSMutableDictionary alloc] init];

		__weak OBAbstractTableViewController *weakSelf = self;

		[_registeredIdentifiers enumerateKeysAndObjectsUsingBlock:^(NSString *className, NSString *identifier, BOOL *stop) {
			UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

		  CGFloat height = cell.frame.size.height;
		  if (height == 0) {
				height = 44.0f;
		  }
		  [weakSelf.cellHeightForModelClass setObject:@(height) forKey:className];
		}];


	}
	NSNumber *value = (NSNumber *)[self.cellHeightForModelClass objectForKey:className];
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
	if (indexPath) {
		return [self.tableView cellForRowAtIndexPath:indexPath];
	}
	return nil;
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

- (NSString *)identifierForObject:(NSObject *)object {
	return [self identifierForClass:[object class]];
}


- (NSString *)identifierForClass:(Class) clazz {
	if ([clazz isKindOfClass:[NSString class]]) {
		return @"NSString";
	}
	NSString *result = NSStringFromClass(clazz);;
	if ([result isEqualToString:@"__NSCFConstantString"] || [result isEqualToString:@"__NSCFString"]) {
		return @"NSString";
	}
	return result;
}


- (void)keyboardDidShow:(NSNotification *)notification {
	NSDictionary *keyInfo = [notification userInfo];
	CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
	keyboardFrame = [self.tableView convertRect:keyboardFrame fromView:nil];
	CGRect intersect = CGRectIntersection(keyboardFrame, self.tableView.bounds);
	if (!CGRectIsNull(intersect)) {
		NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
		if (UIEdgeInsetsEqualToEdgeInsets(self.defaultTableInset,UIEdgeInsetsZero)) {
			self.defaultTableInset = self.tableView.contentInset;
		}
		__weak OBAbstractTableViewController *weakSelf = self;
		[UIView animateWithDuration:duration animations:^{
				weakSelf.tableView.contentInset = UIEdgeInsetsMake(weakSelf.defaultTableInset.top, weakSelf.defaultTableInset.left, weakSelf.defaultTableInset.bottom+intersect.size.height, weakSelf.defaultTableInset.right);
				weakSelf.tableView.scrollIndicatorInsets = self.tableView.contentInset;
		}];
	}
}

- (void)keyboardWillHide:(NSNotification *)notification {
	NSDictionary *keyInfo = [notification userInfo];
	NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
	[UIView animateWithDuration:duration animations:^{
			self.tableView.contentInset = self.defaultTableInset;
			self.tableView.scrollIndicatorInsets = self.defaultTableInset;
	}];
}
@end
