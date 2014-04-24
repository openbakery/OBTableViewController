//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBTableViewController.h"
#import "OBTableViewSection.h"


@interface OBTableViewController ()
@property(nonatomic, strong) NSMutableDictionary *modelDictionary;
@property(nonatomic, strong) NSMutableArray *sections;

@end

@implementation OBTableViewController {

}

- (id)init {
	self = [super init];
	if (self) {
		self.sections = [[NSMutableArray alloc] init];
		self.modelDictionary = [[NSMutableDictionary alloc] init];
	}

	return self;
}


- (void)addSection:(OBTableViewSection *)section {
	if ([self.sections containsObject:section]) {
		return;
	}
	section.identifier = [self.sections count] + 1;
	[self.sections addObject:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
	OBTableViewSection *section = [self sectionAtIndex:sectionIndex];
	NSArray *models = [self modelsForSection:section];

	return [models count];

}

- (OBTableViewSection *)sectionAtIndex:(NSInteger)section {
	if (section < [self.sections count]) {
		return [self.sections objectAtIndex:section];
	}
	return nil;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.sections count];

}


- (void)addModel:(NSObject *)model toSection:(OBTableViewSection *)section {
	NSMutableArray *models = [self modelsArrayForSection:section];
	[models addObject:model];
}

- (void)addModels:(NSArray *)models toSection:(OBTableViewSection *)section {
	NSMutableArray *modelsForSection = [self modelsArrayForSection:section];
	[modelsForSection addObjectsFromArray:models];
}


- (NSMutableArray *)modelsArrayForSection:(OBTableViewSection *)section {
	//DDLogVerbose(@"model dictionary, %@", self.modelDictionary);
	//DDLogVerbose(@"get model for section: %@", section);
	if (!section) {
		return nil;
	}

	NSMutableArray *result = [self.modelDictionary objectForKey:section];
	if (!result) {
		//DDLogDebug(@"no models found so create array");
		result = [[NSMutableArray alloc] init];
		[self.modelDictionary setObject:result forKey:section];
		//DDLogDebug(@"model created and added: %@", self.modelDictionary);

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
	for (OBTableViewSection *section in self.sections) {
		NSArray *models = [self modelsForSection:section];
		NSInteger index = [models indexOfObject:object];
		if (index != NSNotFound) {
			return [NSIndexPath indexPathForRow:index inSection:section.identifier-1];
		}
	}
	return nil;
}

- (void)insertModel:(NSObject *)model toSection:(OBTableViewSection *)section {

	NSInteger sectionIndex = [self.sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
		[self insertModel:model atIndexPath:insertIndexPath];
	}

}

- (void)insertModels:(NSArray *)models toSection:(OBTableViewSection *)section {
	NSInteger sectionIndex = [self.sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
		[self insertModels:models atIndexPath:insertIndexPath];


	}
}


- (void)appendModel:(NSObject *)model toSection:(OBTableViewSection *)section {
	NSInteger sectionIndex = [self.sections indexOfObject:section];
	if (sectionIndex !=  NSNotFound) {
		NSInteger modelCount = [[self modelsArrayForSection:section] count];
		NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:modelCount inSection:sectionIndex];
		[self insertModel:model atIndexPath:insertIndexPath];
	}

}


- (void)insertModel:(NSObject *)model after:(NSObject *)afterModel {
	NSIndexPath *afterModelIndexPath = [self indexPathForModel:afterModel];
	NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:afterModelIndexPath.row+1 inSection:afterModelIndexPath.section];
	[self insertModel:model atIndexPath:insertIndexPath];
}


- (void)insertModel:(NSObject *)model before:(NSObject *)before {
	NSIndexPath *beforeModelIndexPath = [self indexPathForModel:before];
	[self insertModel:model atIndexPath:beforeModelIndexPath];
}

- (void)insertModel:(NSObject *)model atIndexPath:(NSIndexPath *)indexPath {
	OBTableViewSection *section = [self sectionAtIndex:indexPath.section];

	NSMutableArray *models = [self modelsArrayForSection:section];
	[models insertObject:model atIndex:indexPath.row];

	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
}

- (void)insertModels:(NSArray *)modelsToInsert atIndexPath:(NSIndexPath *)indexPath {
	OBTableViewSection *section = [self sectionAtIndex:indexPath.section];

	NSMutableArray *models = [self modelsArrayForSection:section];

	NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row, [modelsToInsert count])];

	[models insertObjects:modelsToInsert atIndexes:indexes];

	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	for (int i=0; i<[modelsToInsert count]; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section]];
	}

	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView endUpdates];
}


- (void)removeModel:(NSObject *)model {
	if (!model) {
		return;
	}
	[self removeModels:@[model]];
}

- (void)removeModels:(NSArray *)modelsToRemove {

	NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
	for (NSObject *model in modelsToRemove) {
		NSIndexPath *indexPath = [self indexPathForModel:model];
		if (indexPath) {
			[indexPaths addObject:indexPath];
			OBTableViewSection *section = [self sectionAtIndex:indexPath.section];
			NSMutableArray *models = [self modelsArrayForSection:section];
			[models removeObject:model];
		}
	}

	if ([indexPaths count]) {
		[self.tableView beginUpdates];
		[self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView endUpdates];
	}
}



- (void)reloadCellForModel:(NSObject *)model {
	NSIndexPath *indexPath = [self indexPathForModel:model];

	[self.tableView beginUpdates];
	[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];

}

- (void)reloadTableView {
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



@end