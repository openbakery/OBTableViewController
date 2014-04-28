//
// Seashell 
//
// Created by rene on 26/04/14.
// Copyright 2014 Drobnik.com. All rights reserved.
//
// 
//


#import <Foundation/Foundation.h>
#import "OBPropertyBinding.h"


@interface UITextViewPropertyBinding : OBPropertyBinding

- (id)initWithSourceName:(NSString *)sourceName andDestinationName:(NSString *)destinationName;

@end