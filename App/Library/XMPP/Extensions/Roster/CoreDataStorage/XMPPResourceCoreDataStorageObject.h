#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "XMPPResource.h"

@class XMPPStream;
@class XMPPPresence;
@class XMPPUserCoreDataStorageObject;


@interface XMPPResourceCoreDataStorageObject : NSManagedObject <XMPPResource>

@property (nonatomic, strong) XMPPJID *jid;
@property (nonatomic, strong) XMPPPresence *presence;

@property (nonatomic, assign) int priority;
@property (nonatomic, assign) int intShow;

@property (nonatomic, copy) NSString * jidStr;
@property (nonatomic, copy) NSString * presenceStr;

@property (nonatomic, copy) NSString * streamBareJidStr;

@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * show;
@property (nonatomic, copy) NSString * status;

@property (nonatomic, strong) NSDate * presenceDate;

@property (nonatomic, strong) NSNumber * priorityNum;
@property (nonatomic, strong) NSNumber * showNum;

@property (nonatomic, strong) XMPPUserCoreDataStorageObject * user;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc
                      withPresence:(XMPPPresence *)presence
                  streamBareJidStr:(NSString *)streamBareJidStr;

- (void)updateWithPresence:(XMPPPresence *)presence;

- (NSComparisonResult)compare:(id <XMPPResource>)another;

@end
