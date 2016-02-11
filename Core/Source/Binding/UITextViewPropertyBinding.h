//
//
// Created by René Pirringer
//
// 
//


#import <Foundation/Foundation.h>
#import "OBPropertyBinding.h"


@interface UITextViewPropertyBinding : OBPropertyBinding

- (id)initWithSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName;

@end