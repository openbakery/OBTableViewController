//
//
// Created by Rene Pirringer.
//
// 
//

#import <UIKit/UIKit.h>
#import "UIImageViewPropertyBinding.h"
#import "OBReflection.h"
#import "OBProperty.h"


@implementation UIImageViewPropertyBinding {

}


- (id)initWithSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[UIImage class] destinationName:destinationName destinationClass:[UIImageView class]];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	NSObject *object = [self.destinationProperty valueForObject:destinationObject];
	if ([object isKindOfClass:[UIImageView class]]) {
		NSObject *value = [self.sourceProperty valueForObject:sourceObject];
		if ([value isKindOfClass:[UIImage class]]) {
			UIImageView *imageView = (UIImageView *)object;
			imageView.image = (UIImage *)value;
		}
	}
}

@end