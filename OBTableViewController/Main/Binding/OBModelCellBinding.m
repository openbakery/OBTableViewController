//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBModelCellBinding.h"
#import "OBProperty.h"
#import "OBReflection.h"
#import "UIImageViewPropertyBinding.h"


@interface OBModelCellBinding ()
@property(nonatomic, strong) NSMutableArray *bindings;
@end

@implementation OBModelCellBinding {

}

- (id)initWithModelClass:(Class)modelClass andCellClass:(Class)cellClass andPropertyBindings:(NSArray *)propertyBindings {
	self = [super init];
	if (self) {
		self.bindings = [[NSMutableArray alloc] init];
		[self setupBindingsForModel:modelClass andCell:cellClass andPropertyBindings:propertyBindings];
	}
	return self;
}

- (void)setupBindingsForModel:(Class)modelClass andCell:(Class)cellClass andPropertyBindings:(NSArray *)propertyBindings {
	NSArray *modelProperties = [OBReflection getPropertiesForClass:modelClass];
	NSArray *cellProperties = [OBReflection getPropertiesForClass:cellClass];
	for (OBPropertyBinding * propertyBinding in propertyBindings) {
		if ([modelProperties containsObject:propertyBinding.sourceProperty] &&
			[cellProperties containsObject:propertyBinding.destinationProperty]) {
			[self.bindings addObject:[propertyBinding copy]];
		}

	}
}


- (void)setValuesForCell:(UITableViewCell *)cell usingModel:(NSObject *)model {
	for (OBPropertyBinding *binding in self.bindings) {
		[binding setValueFrom:model to:cell];
	}
}
@end