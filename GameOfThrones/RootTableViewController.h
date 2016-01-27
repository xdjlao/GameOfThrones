//
//  RootTableViewController.h
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewController : UITableViewController

@property NSMutableArray *charactersArray;
@property NSManagedObjectContext *moc;
@property NSArray *house;
@property NSArray *hair;

@end
