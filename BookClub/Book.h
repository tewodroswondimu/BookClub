//
//  Book.h
//  BookClub
//
//  Created by Tewodros Wondimu on 1/29/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Person;

@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *recommendedPerson;
@end

@interface Book (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addRecommendedPersonObject:(Person *)value;
- (void)removeRecommendedPersonObject:(Person *)value;
- (void)addRecommendedPerson:(NSSet *)values;
- (void)removeRecommendedPerson:(NSSet *)values;

@end
