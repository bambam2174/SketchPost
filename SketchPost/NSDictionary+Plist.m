//
//  NSDictionary+Plist.m
//  EnBW-Umzugsplaner
//
//  Created by Sedat Kilinc on 01.06.12.
//  Copyright (c) 2012 Internship. All rights reserved.
/*  All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the <organization> nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
    NSLog(@"maxIndexKey %d", maxIndexKey);
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
        NSLog(@"Error removing file %@\n%@", filename, [error description]);
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
        NSLog(@"%@ noch nicht vorhanden", filename);
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
