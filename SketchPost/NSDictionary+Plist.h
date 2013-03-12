//
//  NSDictionary+Plist.h
//  EnBW-Umzugsplaner
//
//  Created by Sedat Kilinc on 01.06.12.
//  Copyright (c) 2012 Internship. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Plist)

+(BOOL)plistVorhanden:(NSString *)filename;
+(NSDictionary *)getDictFromFilename:(NSString *)filename;
+(void)setValue:(id)value forKey:(NSString *)key toFileName:(NSString *)filename;
+(void)removePlistWithFilename:(NSString *)filename;
+(BOOL)protectExistingFile:(NSString*)filename;
+(NSString *)path:(NSString *)filename;

-(void)writeToPlistWithFilename:(NSString *)filename;
-(void)appendToFilename:(NSString *)filename;
-(void)updateContentOfFilename:(NSString *)filename;

@end
