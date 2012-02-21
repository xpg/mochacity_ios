//
//  CoreDataController.m
//  iFamily
//
//  Created by Jason Wang on 5/21/11.
//  Copyright 2011 Jason Wang. All rights reserved.
//

#import "CoreDataController.h"

#import "CoreDataManager.h"

@interface CoreDataController()

@property(nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, assign) id<CoreDataProtocol> cdProtocol;

@property(nonatomic, copy) NSString *objectModel;
@property(nonatomic, copy) NSString *persistentStore;

- (NSString *)applicationDocumentDirectory;

- (void)controllerDealloc;

- (void)mergeChangesFromContextDidSave:(NSNotification *)_notification;

@end

@implementation CoreDataController

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _manageObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize cdProtocol = _cdProtocol;

@synthesize objectModel = _objectModel;
@synthesize persistentStore = _persistentStore;

#pragma mark - Public

- (id)insertNewObjectForEntityForName:(NSString *)_model context:(NSManagedObjectContext *)_targetContext {
    id target = [NSEntityDescription insertNewObjectForEntityForName:_model inManagedObjectContext:_targetContext];
    
    return target;
}

- (BOOL)saveContext:(NSError **)error {
    return [self saveTargetContext:self.managedObjectContext error:error delegate:nil];
}

- (BOOL)saveTargetContext:(NSManagedObjectContext *)_targetContext error:(NSError **)error delegate:(id<CoreDataProtocol>)_cdDelegate {
    if (_targetContext != self.managedObjectContext) {
        self.cdProtocol = _cdDelegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mergeChangesFromContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:_targetContext];
    }
    
    BOOL success = [_targetContext save:error];
    
    if (_targetContext != self.managedObjectContext) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:_targetContext];
    }
    
    return success;
}

- (id)saveModelObject:(NSString *)_modelName content:(NSDictionary *)_modelObject identification:(NSPredicate *)_identifaction {
    id target = nil;
    
    if (_identifaction) {
        NSArray *result = [self getModel:_modelName predicate:_identifaction sortBy:nil isAscending:YES];
        if (result && [result count] > 0) {
            return nil;
        }
    }
    
    target = [self insertNewObjectForEntityForName:_modelName context:self.managedObjectContext];
    
    if (!target) {
        return nil;
    }
    
    for (NSString *method in _modelObject.allKeys) {
        [target performSelector:NSSelectorFromString(method) withObject:[_modelObject objectForKey:method]];
    }
    
    NSError *error = nil;
    
    if (![self saveContext:&error]) {
        return nil;
    }
    return target;
}

- (id)saveOrUpdateModelObject:(NSString *)_modelName content:(NSDictionary *)_modelObject identification:(NSPredicate *)_identifaction {
    id target;
    
    if (_identifaction) {
        NSArray *result = [self getModel:_modelName predicate:_identifaction sortBy:nil isAscending:YES];
        if (result && [result count] > 0) {
            target = [result objectAtIndex:0];
        } else {
            target = [self insertNewObjectForEntityForName:_modelName context:self.managedObjectContext];
        }
    } else {
        target = [self insertNewObjectForEntityForName:_modelName context:self.managedObjectContext];
    }
    
    if (!target) {
        return nil;
    }
    
    for (NSString *method in _modelObject.allKeys) {
        [target performSelector:NSSelectorFromString(method) withObject:[_modelObject objectForKey:method]];
    }
    
    NSError *error = nil;
    
    if (![self saveContext:&error]) {
        return nil;
    }
    return target;
}

- (void)deleteModel:(NSManagedObject *)_managedObject {
    [self.managedObjectContext deleteObject:_managedObject];
    [self saveContext:nil];
}

- (id)getModelByID:(NSManagedObjectID *)_modelID {
    return [self getModelByID:_modelID targetContext:self.managedObjectContext];
}

- (id)getModelByID:(NSManagedObjectID *)_modelID targetContext:(NSManagedObjectContext *)_targetContext {
    return [_targetContext objectWithID:_modelID];
}

- (NSArray *)getModelByRequest:(NSFetchRequest *)_request {
    return [self getModelByRequest:_request targetContext:self.managedObjectContext];
}

- (NSArray *)getModelByRequest:(NSFetchRequest *)_request targetContext:(NSManagedObjectContext *)_targetContext {
    NSError *error = nil;
    
    NSArray *result = [_targetContext executeFetchRequest:_request error:&error];
    
    
    if (result && [result count] > 0) {
        return result;
    }
    return nil;
}

- (NSArray *)getModel:(NSString *)_modelName predicate:(NSPredicate *)_predicate sortBy:(NSString *)_sortBy isAscending:(BOOL)_isAscending {
    return [self getModel:_modelName predicate:_predicate sortBy:_sortBy isAscending:_isAscending targetContext:self.managedObjectContext];
}

- (NSArray *)getModel:(NSString *)_modelName predicate:(NSPredicate *)_predicate sortBy:(NSString *)_sortBy isAscending:(BOOL)_isAscending targetContext:(NSManagedObjectContext *)_targetContext {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_modelName inManagedObjectContext:_targetContext];
    [request setEntity:entity];
    
    if (_predicate) {
        [request setPredicate:_predicate];
    }
    
    if (_sortBy) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:_sortBy ascending:_isAscending];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        
        [sortDescriptor release];
        [sortDescriptors release];
    }
    
    NSError *error = nil;
    
    NSArray *result = [_targetContext executeFetchRequest:request error:&error];
    [request release];
    
    
    if (result && [result count] > 0) {
        return result;
    }
    return nil;
}

- (NSUInteger)countForModel:(NSString *)_model error:(NSError **)error {
    return [self countForModel:_model error:error context:self.managedObjectContext];
}

- (NSUInteger)countForModel:(NSString *)_model error:(NSError **)error context:(NSManagedObjectContext *)_targetContext {
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:_model inManagedObjectContext:_targetContext];
    [request setEntity:entity];
    
    return [_targetContext countForFetchRequest:request error:error];
}

- (NSUInteger)countForRequest:(NSFetchRequest *)_request error:(NSError **)error {
    return [self countForRequest:_request error:error context:self.managedObjectContext];
}

- (NSUInteger)countForRequest:(NSFetchRequest *)_request error:(NSError **)error context:(NSManagedObjectContext *)_targetContext {
    return [_targetContext countForFetchRequest:_request error:error];
}

- (NSManagedObjectContext *)getManageObjectContext {
    return self.managedObjectContext;
}

- (NSManagedObjectContext *)getCreateManageObjectContext {
    NSManagedObjectContext *addingContext = [[[NSManagedObjectContext alloc] init] autorelease];
    [addingContext setPersistentStoreCoordinator:[self.managedObjectContext persistentStoreCoordinator]];
    return addingContext;
}

#pragma mark - Private

- (NSString *)applicationDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return documentPath;
}

- (void)controllerDealloc {
    if (_objectModel) {
        [_objectModel release];
        _objectModel = nil;
    }
    if (_persistentStore) {
        [_persistentStore release];
        _persistentStore = nil;
    }
    if (_managedObjectModel) {
        [_managedObjectModel release];
        _managedObjectModel = nil;
    }
    if (_manageObjectContext) {
        [_manageObjectContext release];
        _manageObjectContext = nil;
    }
    if (_persistentStoreCoordinator) {
        [_persistentStoreCoordinator release];
        _persistentStoreCoordinator = nil;
    }
}

- (void)mergeChangesFromContextDidSave:(NSNotification *)_notification {
    [self.managedObjectContext mergeChangesFromContextDidSaveNotification:_notification];
    if (self.cdProtocol && [self.cdProtocol respondsToSelector:@selector(didSaveCreateManageObjectContext)]) {
        [self.cdProtocol didSaveCreateManageObjectContext];
    }
}

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.objectModel withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSString *storePath = [[self applicationDocumentDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.persistentStore]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:storePath]) {
        NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:self.persistentStore ofType:@"sqlite"];
        if (defaultStorePath) {
            [[NSFileManager defaultManager] copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
        }
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath:storePath];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Unresolved error %@, %@",error, [error userInfo]);
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_manageObjectContext) return _manageObjectContext;
    
    if (self.persistentStoreCoordinator) {
        _manageObjectContext = [[NSManagedObjectContext alloc] init];
        [_manageObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _manageObjectContext;
}

#pragma mark - lifecycle

- (id)initWithModel:(NSString *)_model store:(NSString *)_store {
    self = [super init];
    if (self) {
        self.objectModel = _model;
        self.persistentStore = _store;
    }
    return self;
}

@end
