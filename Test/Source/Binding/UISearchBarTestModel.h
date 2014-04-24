//
//
// Created by Rene Pirringer.
//
// 
//


#import <Foundation/Foundation.h>


@interface UISearchBarTestModel : NSObject
- (id)initWithSearchText:(NSString *)text;

@property (nonatomic, strong) NSString *searchText;
@end