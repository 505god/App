#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE
  #import "DDXML.h"
#endif

@class XMPPCapsResourceCoreDataStorageObject;


@interface XMPPCapsCoreDataStorageObject : NSManagedObject

@property (nonatomic, strong) NSXMLElement *capabilities;

@property (nonatomic, copy) NSString * hashStr;
@property (nonatomic, copy) NSString * hashAlgorithm;
@property (nonatomic, copy) NSString * capabilitiesStr;

@property (nonatomic, strong) NSSet * resources;

@end


@interface XMPPCapsCoreDataStorageObject (CoreDataGeneratedAccessors)

- (void)addResourcesObject:(XMPPCapsResourceCoreDataStorageObject *)value;
- (void)removeResourcesObject:(XMPPCapsResourceCoreDataStorageObject *)value;
- (void)addResources:(NSSet *)value;
- (void)removeResources:(NSSet *)value;

@end
