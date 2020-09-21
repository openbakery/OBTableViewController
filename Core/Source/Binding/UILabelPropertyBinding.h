//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBPropertyBinding.h>

@class OBProperty;

/**
* binds NString properties to the cell UILabels, e.g. NSString *text -> UILabel *textLabel
*/
@interface UILabelPropertyBinding : OBPropertyBinding

	- (id)initWithSourceName:(NSString *)string andDestinationName:(NSString *)name;

@end
