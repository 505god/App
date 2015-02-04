#import <CoreData/CoreData.h>

@class XMPPCapsCoreDataStorageObject;


@interface XMPPCapsResourceCoreDataStorageObject : NSManagedObject

@property (nonatomic, copy) NSString * jidStr;
@property (nonatomic, copy) NSString * streamBareJidStr;

@property (nonatomic, assign) BOOL haveFailed;
@property (nonatomic, strong) NSNumber * failed;

@property (nonatomic, copy) NSString * node;
@property (nonatomic, copy) NSString * ver;
@property (nonatomic, copy) NSString * ext;

@property (nonatomic, copy) NSString * hashStr;
@property (nonatomic, copy) NSString * hashAlgorithm;

@property (nonatomic, strong) XMPPCapsCoreDataStorageObject * caps;

@end
