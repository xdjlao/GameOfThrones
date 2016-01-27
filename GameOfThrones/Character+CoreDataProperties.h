//
//  Character+CoreDataProperties.h
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Character.h"

NS_ASSUME_NONNULL_BEGIN

@interface Character (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *hairColor;
@property (nullable, nonatomic, retain) NSString *house;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *actor;

@end

NS_ASSUME_NONNULL_END
