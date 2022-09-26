//
//
// Created by René Pirringer

//
// 
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCellModel : NSObject
@property(nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *detailText;
@property(nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property (nonatomic, assign) NSInteger tag;

- (NSString *)description;


@end