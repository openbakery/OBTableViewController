//
// Created by Rene Pirringer on 07.05.15.
//

#import "UITableViewStub.h"


@implementation UITableViewStub {
	BOOL _reloadData;
}

- (instancetype)init {
	self = [super init];
	_reloadData = NO;
	return self;
}


- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return self.cell;
}

- (void)insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	self.insertRows = indexPaths;
}
- (void)deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
	self.deleteRows = indexPaths;
}
- (void)reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
}

- (void)moveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {

}


- (NSArray *)insertRows {
	if (!_insertRows) {
		_insertRows = [NSArray array];
	}
	return _insertRows;
}

- (NSArray *)deleteRows {
	if (!_deleteRows) {
		_deleteRows = [NSArray array];
	}
	return _deleteRows;
}


- (void)reloadData {
	[super reloadData];
	_reloadData = YES;
}

- (BOOL)hasReloadData {
	return _reloadData;
}


@end