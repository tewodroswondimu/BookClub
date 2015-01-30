//
//  Person.h
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *recommendedBooks;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addRecommendedBooksObject:(Book *)value;
- (void)removeRecommendedBooksObject:(Book *)value;
- (void)addRecommendedBooks:(NSSet *)values;
- (void)removeRecommendedBooks:(NSSet *)values;

@end
