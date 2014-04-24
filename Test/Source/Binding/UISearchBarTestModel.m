//
//
// Created by Rene Pirringer.
//
// 
//


#import "UISearchBarTestModel.h"


@implementation UISearchBarTestModel {

}
- (id)initWithSearchText:(NSString *)text {
	self = [super init];
	if (self) {
		self.searchText = text;
	}
	return self;

}
@end