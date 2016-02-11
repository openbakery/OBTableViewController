//
//
// Created by Rene Pirringer.
//
// 
//

#import <UIKit/UIKit.h>
#import "UISearchBarPropertyBinding.h"
#import "OBProperty.h"


@implementation UISearchBarPropertyBinding {

}

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName {
	return [super initSourceName:sourceName sourceClass:[NSString class] destinationName:destinationName destinationClass:[UISearchBar class]];
}


- (void)setValueFrom:(NSObject *)sourceObject to:(NSObject *)destinationObject {
	UISearchBar *searchBar = [self.destinationProperty valueForObject:destinationObject];
	NSString *value = [self.sourceProperty valueForObject:sourceObject];
	searchBar.text  = value;
}
@end