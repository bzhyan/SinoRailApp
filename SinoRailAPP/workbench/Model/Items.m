//
//  Items.m
//
//  Created by 瑞胜 杜 on 2017/7/14
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "Items.h"


NSString *const kItemsItemTitle = @"itemTitle";
NSString *const kItemsImageName = @"imageName";
NSString *const kItemsItemStaue = @"itemStaue";
NSString *const kItemsItemCount = @"itemCount";
NSString *const kItemsSiteId = @"SiteId";
NSString *const kItemsWebId = @"WebId";
NSString *const kItemsListId = @"ListId";
NSString *const kItemsApproveType = @"approveType";
@interface Items ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Items

@synthesize itemTitle = _itemTitle;
@synthesize imageName = _imageName;
@synthesize itemStaue = _itemStaue;
@synthesize itemCount = _itemCount;
@synthesize SiteId = _SiteId;
@synthesize WebId = _WebId;
@synthesize ListId = _ListId;
@synthesize approveType = _approveType;
+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.itemTitle = [self objectOrNilForKey:kItemsItemTitle fromDictionary:dict];
            self.imageName = [self objectOrNilForKey:kItemsImageName fromDictionary:dict];
            self.itemStaue = [[self objectOrNilForKey:kItemsItemStaue fromDictionary:dict] integerValue];
           self.itemCount = [self objectOrNilForKey:kItemsItemCount fromDictionary:dict];
        self.SiteId = [self objectOrNilForKey:kItemsSiteId fromDictionary:dict];
        self.WebId = [self objectOrNilForKey:kItemsWebId fromDictionary:dict];
        self.ListId = [self objectOrNilForKey:kItemsListId fromDictionary:dict];
        self.approveType = [self objectOrNilForKey:kItemsApproveType fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.itemTitle forKey:kItemsItemTitle];
    [mutableDict setValue:self.imageName forKey:kItemsImageName];
    [mutableDict setValue:[NSNumber numberWithInteger:self.itemStaue] forKey:kItemsItemStaue];
    [mutableDict setValue:self.itemCount forKey:kItemsItemCount];
    [mutableDict setValue:self.SiteId forKey:kItemsSiteId];
    [mutableDict setValue:self.WebId forKey:kItemsWebId];
    [mutableDict setValue:self.ListId forKey:kItemsListId];
    [mutableDict setValue:self.approveType forKey:kItemsApproveType];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.itemTitle = [aDecoder decodeObjectForKey:kItemsItemTitle];
    self.imageName = [aDecoder decodeObjectForKey:kItemsImageName];
    self.itemStaue = [aDecoder decodeIntegerForKey:kItemsItemStaue];
    self.itemCount = [aDecoder decodeObjectForKey:kItemsItemCount];
self.SiteId = [aDecoder decodeObjectForKey:kItemsSiteId];
self.WebId = [aDecoder decodeObjectForKey:kItemsWebId];
self.ListId = [aDecoder decodeObjectForKey:kItemsListId];
    self.approveType = [aDecoder decodeObjectForKey:kItemsApproveType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_itemTitle forKey:kItemsItemTitle];
    [aCoder encodeObject:_imageName forKey:kItemsImageName];
    [aCoder encodeInteger:_itemStaue forKey:kItemsItemStaue];
    [aCoder encodeObject:_itemCount forKey:kItemsItemCount];
    [aCoder encodeObject:_SiteId forKey:kItemsSiteId];
    [aCoder encodeObject:_WebId forKey:kItemsWebId];
    [aCoder encodeObject:_ListId forKey:kItemsListId];
    [aCoder encodeObject:_approveType forKey:kItemsApproveType];
}

- (id)copyWithZone:(NSZone *)zone
{
    Items *copy = [[Items alloc] init];
    
    if (copy) {

        copy.itemTitle = [self.itemTitle copyWithZone:zone];
        copy.imageName = [self.imageName copyWithZone:zone];
        copy.itemStaue = self.itemStaue;
        copy.itemCount = [self.itemCount copyWithZone:zone];
        copy.SiteId = [self.SiteId copyWithZone:zone];
        copy.WebId = [self.WebId copyWithZone:zone];
        copy.ListId = [self.ListId copyWithZone:zone];
        copy.approveType = [self.approveType copyWithZone:zone];
    }
    
    return copy;
}


@end
