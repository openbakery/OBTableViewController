//
// Seashell 
//
// Created by rene on 26/04/14.
// Copyright 2014 Drobnik.com. All rights reserved.
//
// 
//


#import "UITextViewPropertyBinding.h"
#import "OBProperty.h"


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