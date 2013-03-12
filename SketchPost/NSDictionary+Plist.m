//
//  NSDictionary+Plist.m
//  EnBW-Umzugsplaner
//
//  Created by Sedat Kilinc on 01.06.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//

#import "NSDictionary+Plist.h"

@implementation NSDictionary (Plist)


-(void)writeToPlistWithFilename:(NSString *)filename {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSString *szPlistPath = [documentPath stringByAppendingPathComponent:filename];
    
    [self writeToFile:szPlistPath atomically:YES];
    
}

+(NSDictionary *)getDictFromFilename:(NSString *)filename {

    NSDictionary *erg = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSString *szPlistPath = [documentPath stringByAppendingPathComponent:filename];
    
    NSError *error;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *dir = [filemanager contentsOfDirectoryAtPath:documentPath error:&error];
    
    if ([[NSString stringWithFormat:@"%@", dir] rangeOfString:filename].location != NSNotFound) {
        erg = [NSDictionary dictionaryWithContentsOfFile:szPlistPath];
    } 
    
    return erg;
}

-(void)appendToFilename:(NSString *)filename {
    NSDictionary *plist;
    NSMutableDictionary *dict;
    
    plist = [NSDictionary getDictFromFilename:filename];
    
    if (plist)
        dict = [[NSMutableDictionary alloc] initWithDictionary:plist];
    else 
        dict = [[NSMutableDictionary alloc] init];
    NSArray *plistKeys = [dict allKeys];
    NSInteger maxIndexKey=0;
    for (int j=0; j<[plistKeys count]; j++) {
        maxIndexKey = ([[plistKeys objectAtIndex:j] integerValue]>maxIndexKey)?[[plistKeys objectAtIndex:j] integerValue]:maxIndexKey;
    }
    maxIndexKey++;
    DLOG(@"maxIndexKey %d", maxIndexKey);
    NSArray *keys = [self allKeys];
    NSString *key;
    NSString *value;
    for (int i=0; i<[keys count]; i++) {
        key = [keys objectAtIndex:i];
        value = [self objectForKey:key];
        [dict setObject:value forKey:[NSString stringWithFormat:@"%d", maxIndexKey]];
        maxIndexKey++;
    }
    [dict writeToPlistWithFilename:filename];
}

-(void)updateContentOfFilename:(NSString *)filename {
    NSDictionary *plist;
    NSMutableDictionary *dict;
    
    plist = [NSDictionary getDictFromFilename:filename];
    
    if (plist)
        dict = [[NSMutableDictionary alloc] initWithDictionary:plist];
    else 
        dict = [[NSMutableDictionary alloc] init];
    NSArray *keys = [self allKeys];
    NSString *key;
    NSString *value;
    for (int i=0; i<[keys count]; i++) {
        key = [keys objectAtIndex:i];
        value = [self objectForKey:key];
        [dict setObject:value forKey:key];
    }
    
    [dict writeToPlistWithFilename:filename];
}

+(void)removePlistWithFilename:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *szPlistPath = [documentPath stringByAppendingPathComponent:filename];
    NSError *error;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *dir = [filemanager contentsOfDirectoryAtPath:documentPath error:&error];
    
    if ([[NSString stringWithFormat:@"%@", dir] rangeOfString:filename].location != NSNotFound) {
        [filemanager removeItemAtPath:szPlistPath error:&error];
    }
    if (error) {
        DLOG(@"Error removing file %@\n%@", filename, [error description]);
    }
}

+(void)setValue:(id)value forKey:(NSString *)key toFileName:(NSString *)filename {
    NSDictionary *plist;
    NSMutableDictionary *dict;
    
    plist = [NSDictionary getDictFromFilename:filename];
    
    if (plist)
        dict = [[NSMutableDictionary alloc] initWithDictionary:plist];
    else 
        dict = [[NSMutableDictionary alloc] init];

    [dict setValue:value forKey:key];
   
    [dict writeToPlistWithFilename:filename];
}

+(BOOL)plistVorhanden:(NSString *)filename {
    BOOL erg;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSError *error;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *dir = [filemanager contentsOfDirectoryAtPath:documentPath error:&error];
    
    if ([[NSString stringWithFormat:@"%@", dir] rangeOfString:filename].location == NSNotFound) {
        DLOG(@"%@ noch nicht vorhanden", filename);
        erg = NO;
    } else
        erg = YES;
    
    return erg;
}

+(NSString *)path:(NSString *)filename {
    NSString *path = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSError *error;
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *dir = [filemanager contentsOfDirectoryAtPath:documentPath error:&error];
    
    if ([[NSString stringWithFormat:@"%@", dir] rangeOfString:filename].location != NSNotFound) {
        path = [documentPath stringByAppendingPathComponent:filename];
    }
    
    return path;
}

+(BOOL)protectExistingFile:(NSString*)filename
{
    bool protected = false;
    NSString *path = [NSDictionary path:filename];
    NSError* err;
    NSDictionary* attr = [NSDictionary dictionaryWithObject:NSFileProtectionComplete
                                                     forKey:NSFileProtectionKey];
    if(path)
        protected = [[NSFileManager defaultManager] setAttributes:attr ofItemAtPath:path error:&err];
    return protected;
}

@end
