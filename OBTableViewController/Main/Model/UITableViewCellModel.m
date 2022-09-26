//
//
// Created by René Pirringer

//
// 
//


#import "UITableViewCellModel.h"


@implementation UITableViewCellModel {

}

- (NSString *)description {
	NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
	[description appendFormat:@"self.text=%@", self.text];
	[description appendString:@">"];
	return description;
}


@end