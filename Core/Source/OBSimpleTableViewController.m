//
// ELO 
//
// Created by rene on 19.02.14.

//
// 
//


#import <objc/runtime.h>
#import "OBSimpleTableViewController.h"
#import "OBModelCellBinding.h"


@interface OBSimpleTableViewController ()
@property(nonatomic, strong) NSMutableArray *models;
@end

@implementation OBSimpleTableViewController {

}

- (id)init {
	self = [super init];
	if (self) {
		self.models = [[NSMutableArray alloc] init];
	}
	return self;
}



- (NSArray *)modelsForSectionIndex:(NSInteger)section {
	return self.models;
}


- (NSObject *)modelAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row <= [self.models count]) {
		return [self.models objectAtIndex:indexPath.row];
	}
	return nil;
}



- (void)addModel:(NSObject *)model {
	[self.models addObject:model];
}


- (NSIndexPath *)indexPathForModel:(NSObject *)object {
	NSInteger index = [self.models indexOfObject:object];
	if (index != NSNotFound) {
		return  [NSIndexPath indexPathForRow:index inSection:0];
	}
	return nil;
}


@end