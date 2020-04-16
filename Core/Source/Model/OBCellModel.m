//
// Created by René Pirringer on 16.04.20.
// Copyright (c) 2020 Rene Pirringer. All rights reserved.
//

#import "OBCellModel.h"


@interface OBCellModel ()
@property(nonatomic, strong) NSString *text;
@end

@implementation OBCellModel {

}

- (instancetype)initWithText:(NSString *_Nonnull)text {
	self = [super init];
	if (self) {
		self.text = text;
	}
	return self;
}
@end
