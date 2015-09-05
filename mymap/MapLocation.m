//
//  MapLocation.m
//  mymap
//
//  Created by 陈洪 on 15/9/2.
//  Copyright (c) 2015年 chenhong. All rights reserved.
//

#import "MapLocation.h"
@implementation MapLocation
@synthesize  city;
@synthesize coordinate;
@synthesize state;
@synthesize streetAddress;
@synthesize zip;

- (NSString *)title {
    return @"您的位置!";
}
- (NSString *)subtitle {
    
    NSMutableString *ret = [NSMutableString string];
    if (streetAddress)
        [ret appendString:streetAddress];
    if (streetAddress && (city || state || zip))
        [ret appendString:@" • "];
    if (city)
        [ret appendString:city];
    if (city && state)
        [ret appendString:@", "];
    if (state)
        [ret appendString:state];
    if (zip)
        [ret appendFormat:@", %@", zip];
    
    return ret;
}
#pragma mark -
- (void)dealloc {
    [streetAddress release];
    [city release];
    [state release];
    [zip release];
    [super dealloc];
}
#pragma mark -
#pragma mark NSCoding Methods
- (void) encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject: [self streetAddress] forKey: @"streetAddress"];
    [encoder encodeObject: [self city] forKey: @"city"];
    [encoder encodeObject: [self state] forKey: @"state"];
    [encoder encodeObject: [self zip] forKey: @"zip"];
}
- (id) initWithCoder: (NSCoder *)decoder  {
    if (self = [super init]) {
        [self setStreetAddress: [decoder decodeObjectForKey: @"streetAddress"]];
        [self setCity: [decoder decodeObjectForKey: @"city"]];
        [self setState: [decoder decodeObjectForKey: @"state"]];
        [self setZip: [decoder decodeObjectForKey: @"zip"]];
    }
    return self;
}

@end