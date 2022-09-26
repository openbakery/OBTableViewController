//
//
// Created by René Pirringer
//
// 
//




#import "OBSimpleTableViewController.h"
#import <OBTableViewController/OBModelCellBinding.h>


@interface OBSimpleTableViewController ()
@end

@implementation OBSimpleTableViewController {

	NSMutableArray *_models;
}

- (id)init {
	self = [super init];
	if (self) {
		_models = [[NSMutableArray alloc] init];
	}
	return self;
}


- (NSArray *)modelsForSectionIndex:(NSInteger)section {
	return _models;
}


- (NSObject *)modelAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row <= [_models count]) {
		return [_models objectAtIndex:indexPath.row];
	}
	return nil;
}



- (void)addModel:(NSObject *)model {
	[_models addObject:model];
}

- (void)addModels:(NSArray *)models {
	[_models addObjectsFromArray:models];
}


- (void)setModels:(NSArray *)models {
	_models = [[NSMutableArray alloc] initWithArray:models];
}


- (void)removeAllModels {
	[_models removeAllObjects];
}


- (NSIndexPath *)indexPathForModel:(NSObject *)object {
	NSInteger index = [_models indexOfObject:object];
	if (index != NSNotFound) {
		return  [NSIndexPath indexPathForRow:index inSection:0];
	}
	return nil;
}


@end
