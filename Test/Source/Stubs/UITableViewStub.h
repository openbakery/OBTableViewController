//
// Created by Rene Pirringer on 07.05.15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewStub : UITableView


@property (nonatomic, strong) UITableViewCell *cell;

@property(nonatomic, strong) NSArray *insertRows;
@property(nonatomic, strong) NSArray *deleteRows;

@property(nonatomic, readonly) BOOL hasReloadData;


@end