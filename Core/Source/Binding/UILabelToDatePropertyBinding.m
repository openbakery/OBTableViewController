//
//
// Created by Rene Pirringer.
//
// 
//


#import "UILabelToDatePropertyBinding.h"
#import "OBProperty.h"


@implementation UILabelToDatePropertyBinding {
	NSDateFormatter *_dateFormatter;
}

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	self = [super initSourceName:sourceName sourceClass:[NSDate class] destinationName:destinationName destinationClass:[UILabel class]];
	if (self) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		[_dateFormatter setTimeStyle:NSDateFormatterNoStyle];

	}
	return self;
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UILabel *label = [self.destinationProperty valueForObject:destinationObject];
	NSDate *value = [self.sourceProperty valueForObject:sourceObject];
	label.text  = [_dateFormatter stringFromDate:value];
}

- (id)copyWithZone:(NSZone *)zone {
	UILabelToDatePropertyBinding *copy = [super copyWithZone:zone];

	if (copy != nil) {
		copy->_dateFormatter = _dateFormatter;
	}

	return copy;
}

@end