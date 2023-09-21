//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>
#import <OBTableViewController/OBPropertyBinding.h>


/**
* binds NSDate properties to the cell UILabels, e.g. NSDate *date -> UILabel *textLabel
*/
@interface UILabelToDatePropertyBinding : OBPropertyBinding

- (id)initSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName;

@end
