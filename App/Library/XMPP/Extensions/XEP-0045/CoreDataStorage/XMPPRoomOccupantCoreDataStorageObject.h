#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "XMPP.h"
#import "XMPPRoom.h"


@interface XMPPRoomOccupantCoreDataStorageObject : NSManagedObject <XMPPRoomOccupant>

/**
 * The properties below are documented in the XMPPRoomOccupant protocol.
**/

@property (nonatomic, strong) XMPPPresence * presence; // Transient (proper type, not on disk) 
@property (nonatomic, copy) NSString * presenceStr;  // Shadow (binary data, written to disk)

@property (nonatomic, strong) XMPPJID * roomJID;       // Transient (proper type, not on disk)
@property (nonatomic, copy) NSString * roomJIDStr;   // Shadow (binary data, written to disk)

@property (nonatomic, strong) XMPPJID * jid;           // Transient (proper type, not on disk)
@property (nonatomic, copy) NSString * jidStr;       // Shadow (binary data, written to disk)

@property (nonatomic, copy) NSString * nickname;

@property (nonatomic, copy) NSString * role;
@property (nonatomic, copy) NSString * affiliation;

@property (nonatomic, strong) XMPPJID * realJID;       // Transient (proper type, not on disk)
@property (nonatomic, copy) NSString * realJIDStr;   // Shadow (binary data, written to disk)

@property (nonatomic, strong) NSDate * createdAt;

/**
 * If a single instance of XMPPRoomCoreDataStorage is shared between multiple xmppStream's,
 * this may be needed to distinguish between the streams.
**/
@property (nonatomic, copy) NSString * streamBareJidStr;

@end
