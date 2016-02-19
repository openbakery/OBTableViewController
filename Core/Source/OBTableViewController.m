//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBTableViewController.h"
#import "OBTableViewSection.h"

@interface OBTableViewSection()
@property (nonatomic, assign) NSInteger identifier;
@end;



@implementation OBTableViewController {
	NSMutableDictionary *_modelDictionary;
	NSMutableArray *_sections;

}

- (id)init {
	self = [super init];
	if (self) {
		_sections = [[NSMutableArray alloc] init];
		_modelDictionary = [[NSMutableDictionary alloc] init];
	}

	return self;
}


- (void)addSection:(OBTableViewSection *)section {
	if ([_sections containsObject:section]) {
		return;
	}
	section.identifier = [_sections count] + 1;
	[_sections addObject:section];
}

- (NSArray *)sections {
	return [NSArray arrayWithArray:_sections];
}

- (NSInteger)indexForSection:(OBTableViewSection *)section {
	return section.identifier-1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	OBTableViewSection *section = [self sectionAtIndex:sectionIndex];
	NSArray *models = [self modelsForSection:section];
	//NSLog(@"number rows in section %@: %@", [@(sectionIndex) stringValue], [@([models count]) stringValue]);
	return [models count];

}

- (OBTableViewSection *)sectionAtIndex:(NSInteger)section {
	if (section < [_sections count]) {
		return [_sections objectAtIndex:section];
	}
	return nil;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [_sections count];

}


- (void)addModel:(NSObject *)model toSection:(OBTableViewSection *)section {
	//NSLog(@"addModel:%@ toSection:%@", model, section);
	NSMutableArray *models = [self modelsArrayForSection:section];
	[models addObject:model];
}

- (void)addModels:(NSArray *)models toSection:(OBTableViewSection *)section {
	//NSLog(@"addModels:%@ toSection:%@", models, section);
	NSMutableArray *modelsForSection = [self modelsArrayForSection:section];
	[modelsForSection addObjectsFromArray:models];
}


- (NSMutableArray *)modelsArrayForSection:(OBTableViewSection *)section {
	//DDLogVerbose(@"model dictionary, %@", _modelDictionary);
	//DDLogVerbose(@"get model for section: %@", section);
	if (!section) {
		return nil;
	}

	NSMutableArray *result = [_modelDictionary objectForKey:section];
	if (!result) {
		//NSLog(@"no models found so create array");
		result = [[NSMutableArray alloc] init];
		[_modelDictionary setObject:result forKey:section];
		//NSLog(@"model created and added: %@", _modelDictionary);

	}
	//DDLogVerbose(@"models: %@ in section %@",result, section);
	return result;
}

- (NSArray *)modelsForSection:(OBTableViewSection *)section {
	return [NSArray arrayWithArray:[self modelsArrayForSection:section]];
}

- (NSArray *)modelsForSectionIndex:(NSInteger)sectionIndex {
	OBTableViewSection *section = [self sectionAtIndex:sectionIndex];
	return [self modelsForSection:section];
}

- (NSIndexPath *)indexPathForModel:(NSObject *)object {
	for (OBTableViewSection *section in _sections) {
		NSArray *models = [self modelsForSection:section];
		NSInteger index = [models indexOfObject:object];
		if (index != NSNotFound) {
			return [NSIndexPath indexPathForRow:index inSection:section.identifier-1];
		}
	}
	return nil;
}

- (void)insertModel:(NSObject *)model toSection:(OBTableViewSection *)section {
	//NSLog(@"insertModel:%@ toSection:%@", model, section);

	NSInteger sectionIndex = [_sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
		[self insertModel:model atIndexPath:insertIndexPath];
	}

}

- (void)insertModels:(NSArray *)models toSection:(OBTableViewSection *)section {
	//NSLog(@"insertModels:%@ toSection:%@", models, section);

	NSInteger sectionIndex = [_sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
		[self insertModels:models atIndexPath:insertIndexPath];


	}
}


- (void)appendModel:(NSObject *)model toSection:(OBTableViewSection *)section {
	[self appendModels:@[model] toSection:section];
}

- (void)appendModels:(NSArray *)models toSection:(OBTableViewSection *)section {
	//NSLog(@"appendModels:%@ toSection:%@", models, section);

	NSInteger sectionIndex = [_sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSInteger modelCount = [[self modelsArrayForSection:section] count];
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:modelCount inSection:sectionIndex];
		[self insertModels:models atIndexPath:insertIndexPath withRowAnimation:UITableViewRowAnimationAutomatic];
	}

}

- (void)insertModel:(NSObject *)model after:(NSObject *)afterModel {
	//NSLog(@"insertModel:%@ after:%@", model, afterModel);

	NSIndexPath *afterModelIndexPath = [self indexPathForModel:afterModel];
	NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:afterModelIndexPath.row+1 inSection:afterModelIndexPath.section];
	[self insertModel:model atIndexPath:insertIndexPath];
}


- (void)insertModel:(NSObject *)model before:(NSObject *)before {
	//NSLog(@"insertModel:%@ before:%@", model, before);

	NSIndexPath *beforeModelIndexPath = [self indexPathForModel:before];
	[self insertModel:model atIndexPath:beforeModelIndexPath];
}

- (void)insertModel:(NSObject *)model atIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"insertModel:%@ atIndexPath:%@", model, indexPath);

	//[self dumpModels];

	OBTableViewSection *section = [self sectionAtIndex:indexPath.section];

	NSMutableArray *models = [self modelsArrayForSection:section];
	[models insertObject:model atIndex:indexPath.row];

	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
}

- (void)insertModels:(NSArray *)modelsToInsert atIndexPath:(NSIndexPath *)indexPath  {
	[self insertModels:modelsToInsert atIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
}

- (void)insertModels:(NSArray *)modelsToInsert atIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)rowAnimation {
	//NSLog(@"insertModels:%@ atIndexPath:%@", modelsToInsert, indexPath);

	OBTableViewSection *section = [self sectionAtIndex:indexPath.section];

	NSMutableArray *models = [self modelsArrayForSection:section];

	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, [modelsToInsert count])];

	[models insertObjects:modelsToInsert atIndexes:indexes];

	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	for (int i=0; i<[modelsToInsert count]; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section]];
	}

	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:rowAnimation];
	[self.tableView endUpdates];
}


- (void)removeModel:(NSObject *)model {
	//NSLog(@"removeModel:%@", model);

	if (!model) {
		return;
	}
	[self removeModels:@[model]];
}

- (void)removeModels:(NSArray *)modelsToRemove {
	//NSLog(@"removeModels:%@", modelsToRemove);

	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

	// first grab all indexPath for the models that must be removed
	for (NSObject *model in modelsToRemove) {
		NSIndexPath *indexPath = [self indexPathForModel:model];
		if (indexPath) {
			[indexPaths addObject:indexPath];
		}
	}

	// remove the models
	for (NSObject *model in modelsToRemove) {
		NSIndexPath *indexPath = [self indexPathForModel:model];
		OBTableViewSection *section = [self sectionAtIndex:indexPath.section];
		NSMutableArray *models = [self modelsArrayForSection:section];
		[models removeObject:model];
	}

	if ([indexPaths count]) {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView endUpdates];
	}
}


- (void)setModels:(NSArray *)models toSection:(OBTableViewSection *)section {

	NSInteger sectionIndex = [_sections indexOfObject:section];
	if (sectionIndex ==  NSNotFound) {
		return;
	}

	NSMutableArray *modelsInSection = [self modelsArrayForSection:section];

	if ([self isEmpty]) {
		// no models are present in the table view controller, so do not animated it the first time
		[self addModel:models toSection:section];
		[self.tableView reloadData];
		return;
	}

	NSMutableArray  *modelsToDelete = [[NSMutableArray alloc] initWithArray:modelsInSection];
	[modelsToDelete removeObjectsInArray:models];

	NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
	for (NSObject *model in modelsToDelete) {
		NSInteger index = [modelsInSection indexOfObject:model];
		[indexPathsToDelete addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
	}


	NSMutableArray *modelsToInsert = [[NSMutableArray alloc] initWithArray:models];
	[modelsToInsert removeObjectsInArray:modelsInSection];
	NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];


	for (NSObject *model in modelsToInsert) {
		NSInteger index = [models indexOfObject:model];
		[indexPathsToInsert addObject:[NSIndexPath indexPathForRow:index inSection:sectionIndex]];
	}


	[modelsInSection setArray:models];

	if ([indexPathsToInsert count] || [indexPathsToDelete count]) {
		[self.tableView beginUpdates];
	}
	if ([indexPathsToDelete count]) {
		[self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationBottom];
	}
	if ([indexPathsToInsert count]) {
		[self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
	}
	if ([indexPathsToInsert count] || [indexPathsToDelete count]) {
		[self.tableView endUpdates];
	}
}

- (BOOL)isEmpty {
	if ([_modelDictionary count] == 0) {
		return YES;
	}
	for (OBTableViewSection *section in [_modelDictionary allKeys]) {
		NSArray *models = [_modelDictionary objectForKey:section];
		if ([models count] != 0) {
			return NO;
		}
	}
	return YES;
}


- (void)reloadCellForModel:(NSObject *)model {
	//NSLog(@"reloadCellForModel:%@", model);

	NSIndexPath *indexPath = [self indexPathForModel:model];
	if (indexPath) {
		[self.tableView beginUpdates];
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
		[self.tableView endUpdates];
	}
}

- (void)reloadTableView {
	//NSLog(@"reloadTableView");

	[self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	OBTableViewSection *tableViewSection = [self sectionAtIndex:section];
	if (tableViewSection.headerTitle) {
		return UITableViewAutomaticDimension;
	}

	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	OBTableViewSection *tableViewSection = [self sectionAtIndex:section];
	if (tableViewSection) {
		return tableViewSection.headerTitle;
	}
	return nil;
}


- (void)deleteAllModelsFromSection:(OBTableViewSection *)section {
	//NSLog(@"deleteAllModelsFromSection:%@", section);

	NSMutableArray *models = [self modelsArrayForSection:section];
	[models removeAllObjects];
}

- (void)removeAllModelsFromSection:(OBTableViewSection *)section {
	//NSLog(@"removeAllModelsFromSection:%@", section);
	NSMutableArray *modelsToRemove = [self modelsArrayForSection:section];


	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

	// first grab all indexPath for the models that must be removed
	for (NSObject *model in modelsToRemove) {
		NSIndexPath *indexPath = [self indexPathForModel:model];
		if (indexPath) {
			[indexPaths addObject:indexPath];
		}
	}

	[modelsToRemove removeAllObjects];

	if ([indexPaths count]) {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView endUpdates];
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	//NSLog(@"setEditing:%@", [@(editing) stringValue]);

	BOOL setEditing = NO;
	if (editing) {
		for (OBTableViewSection *section in _sections) {
			if (section.editable) {
				NSArray *model = [self modelsForSection:section];
				if ([model count]) {
					setEditing = YES;
					break;
				}
			}
		}
	}
	[self.tableView setEditing:setEditing animated:animated];
}


- (void)setEditing:(BOOL)editable {
	[self setEditing:editable animated:YES];
}

- (BOOL)editing {
	return self.tableView.editing;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	OBTableViewSection *section = [_sections objectAtIndex:indexPath.section];
	if (!section.editable) {
		return NO;
	}
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSObject *model = [self modelAtIndexPath:indexPath];
		[self removeModel:model];

		if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewController:didDeleteModel:)]) {

			[self.delegate tableViewController:self didDeleteModel:model];

		}
	}
}

- (void)dumpModels {
/*
	NSLog(@"OBTableViewController models:");
	for (OBTableViewSection *section in self.sections) {
		NSLog(@"\t%@", section);

		for (NSObject *model in [self modelsForSection:section]) {
			NSLog(@"\t\t%@", model);
		}

	}
*/
}
@end