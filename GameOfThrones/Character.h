//
//  Character.h
//  GameOfThrones
//
//  Created by Jerry on 1/26/16.
//  Copyright © 2016 Jerry Lao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Character : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
//- (instancetype)initWithCharacter:(NSString *)character withActor:(NSString *)actor;

@end

NS_ASSUME_NONNULL_END

#import "Character+CoreDataProperties.h"
