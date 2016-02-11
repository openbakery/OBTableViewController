//
//
// Created by Rene Pirringer.
//
// 
//

#import <UIKit/UIKit.h>
#import "UITextFieldPropertyBinding.h"
#import "OBProperty.h"

@interface UITextFieldPropertyBinding ()
@property(nonatomic, strong) OBProperty *placeholderProperty;
@end

@implementation UITextFieldPropertyBinding {
}


- (id)initWithSourceName:(NSString *)sourceName placeholderName:(NSString *)placeholderName andDestinationName:(NSString *)destinationName {
	self = [super initSourceName:sourceName sourceClass:[NSString class] destinationName:destinationName destinationClass:[UITextField class]];
	if (self) {
		if (placeholderName) {
			self.placeholderProperty = [[OBProperty alloc] initWithName:placeholderName andClass:[NSString class]];
		}
	}
	return self;

}

- (id)initWithSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [self initWithSourceName:sourceName placeholderName:nil andDestinationName:destinationName];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UITextField *textField = [self.destinationProperty valueForObject:destinationObject];
	NSString *value = [self.sourceProperty valueForObject:sourceObject];
	textField.text  = value;

	NSString *placeholder = [self.placeholderProperty valueForObject:sourceObject];
	textField.placeholder = placeholder;
}


- (id)copyWithZone:(NSZone *)zone {
	UITextFieldPropertyBinding *copy = [super copyWithZone:zone];
	if (copy) {
		copy.placeholderProperty = self.placeholderProperty;
	}
	return copy;
}

@end