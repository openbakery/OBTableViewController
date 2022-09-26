//
//
// Created by René Pirringer
//
// 
//


#import <UIKit/UIKit.h>
#import "UITextViewPropertyBinding.h"
#import <OBTableViewController/OBProperty.h>

@implementation UITextViewPropertyBinding
{

}

- (id)initWithSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[NSString class] destinationName:destinationName destinationClass:[UITextView class]];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UITextView *textView = [self.destinationProperty valueForObject:destinationObject];
	NSString *value = [self.sourceProperty valueForObject:sourceObject];
	textView.text  = value;
}

@end
