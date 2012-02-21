//
//  CoreDataController.h
//  iFamily
//
//  Created by Jason Wang on 5/21/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CoreDataProtocol.h"

@protocol CoreDataProtocol;

@interface CoreDataController : NSObject {
    @private
        NSManagedObjectModel *_managedObjectModel;
        NSManagedObjectContext *_manageObjectContext;
        NSPersistentStoreCoordinator *_persistentStoreCoordinator;
        
        NSString *_objectModel;
        NSString *_persistentStore;
    
        id<CoreDataProtocol> _cdProtocol;
}

#pragma mark - Public

- (id)initWithModel:(NSString *)_model store:(NSString *)_store;

- (id)insertNewObjectForEntityForName:(NSString *)_model context:(NSManagedObjectContext *)_targetContext;

- (BOOL)saveContext:(NSError **)error;

- (BOOL)saveTargetContext:(NSManagedObjectContext *)_targetContext error:(NSError **)error delegate:(id<CoreDataProtocol>)_cdDelegate;

- (id)saveModelObject:(NSString *)_modelName content:(NSDictionary *)_modelObject identification:(NSPredicate *)_identifaction;

- (id)saveOrUpdateModelObject:(NSString *)_modelName content:(NSDictionary *)_modelObject identification:(NSPredicate *)_identifaction;

- (void)deleteModel:(NSManagedObject *)_managedObject;

- (id)getModelByID:(NSManagedObjectID *)_modelID;

- (id)getModelByID:(NSManagedObjectID *)_modelID targetContext:(NSManagedObjectContext *)_targetContext;

- (NSArray *)getModelByRequest:(NSFetchRequest *)_request;

- (NSArray *)getModelByRequest:(NSFetchRequest *)_request targetContext:(NSManagedObjectContext *)_targetContext;

- (NSArray *)getModel:(NSString *)_modelName predicate:(NSPredicate *)_predicate sortBy:(NSString *)_sortBy isAscending:(BOOL)_isAscending;

- (NSArray *)getModel:(NSString *)_modelName predicate:(NSPredicate *)_predicate sortBy:(NSString *)_sortBy isAscending:(BOOL)_isAscending targetContext:(NSManagedObjectContext *)_targetContext;

- (NSUInteger)countForModel:(NSString *)_model error:(NSError **)error;

- (NSUInteger)countForModel:(NSString *)_model error:(NSError **)error context:(NSManagedObjectContext *)_targetContext;

- (NSUInteger)countForRequest:(NSFetchRequest *)_request error:(NSError **)error;

- (NSUInteger)countForRequest:(NSFetchRequest *)_request error:(NSError **)error context:(NSManagedObjectContext *)_targetContext;

- (NSManagedObjectContext *)getManageObjectContext;

- (NSManagedObjectContext *)getCreateManageObjectContext;

@end
