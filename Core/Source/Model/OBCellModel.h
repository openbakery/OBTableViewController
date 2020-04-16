//
// Created by René Pirringer on 16.04.20.
// Copyright (c) 2020 Rene Pirringer. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OBCellModel : NSObject

@property(nonatomic, readonly, nonnull) NSString *text;

- (instancetype _Nonnull)initWithText:(NSString * _Nonnull)text;

@end
