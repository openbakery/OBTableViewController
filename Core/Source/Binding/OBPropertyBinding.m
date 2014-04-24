//
//
// Created by Rene Pirringer.
//
// 
//


#import "OBPropertyBinding.h"
#import "OBProperty.h"


@implementation OBPropertyBinding {
}

- (id)initSourceName:(NSString *)sourceName sourceClass:(Class)sourceClass destinationName:(NSString *)destinationName destinationClass:(Class)destinationClass {
	self = [super init];
	if (self) {
		self.sourceProperty = [[OBProperty alloc] initWithName:sourceName andClass:sourceClass];
		self.destinationProperty = [[OBProperty alloc] initWithName:destinationName andClass:destinationClass];
	}
	return self;
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
}


- (id)copyWithZone:(NSZone *)zone {
	OBPropertyBinding *copy = [[self class] allocWithZone:zone];
	if (copy) {
		copy.sourceProperty = self.sourceProperty;
		copy.destinationProperty = self.destinationProperty;
	}
	return copy;
}


@end