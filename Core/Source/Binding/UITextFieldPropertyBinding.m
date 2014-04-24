//
//
// Created by Rene Pirringer.
//
// 
//


#import "UITextFieldPropertyBinding.h"
#import "OBProperty.h"

@implementation UITextFieldPropertyBinding {
}


- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[NSString class] destinationName:destinationName destinationClass:[UITextField class]];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UITextField *textField = [self.destinationProperty valueForObject:destinationObject];
	NSString *value = [self.sourceProperty valueForObject:sourceObject];
	textField.text  = value;
}

@end