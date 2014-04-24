//
//  OBAppDelegate.h
//  OBTableViewController
//
//  Created by Rene Pirringer on 24.04.14.
//  Copyright (c) 2014 Rene Pirringer. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
