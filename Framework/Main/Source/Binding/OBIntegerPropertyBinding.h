//
// Created by Rene Pirringer
//

#import "OBPropertyBinding.h"
#import <Foundation/Foundation.h>

@interface OBIntegerPropertyBinding : OBPropertyBinding

- (id)initWithSourceName:(NSString *)sourceName
         destinationName:(NSString *)destinationName;

@end
