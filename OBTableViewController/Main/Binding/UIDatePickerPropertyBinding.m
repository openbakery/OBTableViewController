//
//
// Created by Rene Pirringer.
//
// 
//

#import <UIKit/UIKit.h>
#import "UIDatePickerPropertyBinding.h"
#import "OBProperty.h"


@implementation UIDatePickerPropertyBinding {
	//NSObject *_sourceObject;

}

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[NSDate class] destinationName:destinationName destinationClass:[UIDatePicker class]];
}

- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UIDatePicker *datePicker = [self.destinationProperty valueForObject:destinationObject];
	NSDate *value = [self.sourceProperty valueForObject:sourceObject];
	datePicker.date = value;

	/*
	if (!_sourceObject) {
		_sourceObject = sourceObject;
		[datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	}
	*/
}

/*
- (void)valueChanged:(id)sender {
	UIDatePicker *datePicker = (UIDatePicker *)sender;
	[self.sourceProperty setValueForObject:_sourceObject toValue:datePicker.date];
}
*/


@end