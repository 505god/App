//
//  XMPPvCardTemp.h
//  XEP-0054 vCard-temp
//
//  Created by Eric Chamberlain on 3/9/11.
//  Copyright 2011 RF.com. All rights reserved.
//  Copyright 2010 Martin Morrison. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "XMPPIQ.h"
#import "XMPPJID.h"
#import "XMPPUser.h"
#import "XMPPvCardTempAdr.h"
#import "XMPPvCardTempBase.h"
#import "XMPPvCardTempEmail.h"
#import "XMPPvCardTempLabel.h"
#import "XMPPvCardTempTel.h"


typedef enum _XMPPvCardTempClass {
	XMPPvCardTempClassNone,
	XMPPvCardTempClassPublic,
	XMPPvCardTempClassPrivate,
	XMPPvCardTempClassConfidential,
} XMPPvCardTempClass;


extern NSString *const kXMPPNSvCardTemp;
extern NSString *const kXMPPvCardTempElement;


/*
 * Note: according to the DTD, every fields bar N and FN can appear multiple times.
 * The provided accessors only support this for the field types where multiple
 * entries make sense - for the others, if required, the NSXMLElement accessors
 * must be used.
 */
@interface XMPPvCardTemp : XMPPvCardTempBase


@property (nonatomic, strong) NSDate *bday;
@property (nonatomic, strong) NSData *photo;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *formattedName;
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *givenName;
@property (nonatomic, copy) NSString *middleName;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *suffix;

@property (nonatomic, strong) NSArray *addresses;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *telecomsAddresses;
@property (nonatomic, strong) NSArray *emailAddresses;

@property (nonatomic, strong) XMPPJID *jid;
@property (nonatomic, copy) NSString *mailer;

@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, strong) NSData *logo;
@property (nonatomic, strong) XMPPvCardTemp *agent;
@property (nonatomic, copy) NSString *orgName;

/*
 * ORGUNITs can only be set if there is already an ORGNAME. Otherwise, changes are ignored.
 */
@property (nonatomic, strong) NSArray *orgUnits;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *prodid;
@property (nonatomic, strong) NSDate *revision;
@property (nonatomic, copy) NSString *sortString;
@property (nonatomic, copy) NSString *phoneticSound;
@property (nonatomic, strong) NSData *sound;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) XMPPvCardTempClass privacyClass;
@property (nonatomic, strong) NSData *key;
@property (nonatomic, copy) NSString *keyType;

+ (XMPPvCardTemp *)vCardTempFromElement:(NSXMLElement *)element;
+ (XMPPvCardTemp *)vCardTemp;
+ (XMPPvCardTemp *)vCardTempSubElementFromIQ:(XMPPIQ *)iq;
+ (XMPPvCardTemp *)vCardTempCopyFromIQ:(XMPPIQ *)iq;
+ (XMPPIQ *)iqvCardRequestForJID:(XMPPJID *)jid;


- (void)addAddress:(XMPPvCardTempAdr *)adr;
- (void)removeAddress:(XMPPvCardTempAdr *)adr;
- (void)clearAddresses;


- (void)addLabel:(XMPPvCardTempLabel *)label;
- (void)removeLabel:(XMPPvCardTempLabel *)label;
- (void)clearLabels;


- (void)addTelecomsAddress:(XMPPvCardTempTel *)tel;
- (void)removeTelecomsAddress:(XMPPvCardTempTel *)tel;
- (void)clearTelecomsAddresses;


- (void)addEmailAddress:(XMPPvCardTempEmail *)email;
- (void)removeEmailAddress:(XMPPvCardTempEmail *)email;
- (void)clearEmailAddresses;


@end
