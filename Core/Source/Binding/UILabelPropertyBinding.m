//
//
// Created by Rene Pirringer.
//
// 
//


#import "UILabelPropertyBinding.h"
#import "OBProperty.h"
#import "OBReflection.h"


@implementation UILabelPropertyBinding {

}

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[NSString class] destinationName:destinationName destinationClass:[UILabel class]];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UILabel *label = [self.destinationProperty valueForObject:destinationObject];
	NSString *value = [self.sourceProperty valueForObject:sourceObject];
	label.text  = value;
}

@end