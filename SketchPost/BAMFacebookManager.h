//
//  BAMFacebookManager.h
//  SketchPost
//
//  Created by Sedat Kilinc on 06.03.13.
//  Copyright (c) 2013 adrodev GmbH. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

/*
@protocol BAMUser <FBGraphUser>

@property (readonly, nonatomic, getter = favoriteTeams) NSArray *favoriteTeams;

@end
*/

@protocol BAMFacebookManagerDelegate <NSObject>

-(void)userDetailsFetched:(NSDictionary<FBGraphUser> *)user;
-(void)friendspickerDoneWasPressed:(id)sender;
-(void)friendspickerCancelWasPressed:(id)sender;
-(void)fbRequestDidFinishWithResult:(id)result error:(NSError *)err;

@end

@interface BAMFacebookManager : NSObject <FBFriendPickerDelegate, UIAlertViewDelegate /*, BAMUser*/> {
    NSDictionary<FBGraphUser> *_user;
    FBFriendPickerViewController *_friendsPickerController;
    NSString *_currentSource;
    UIAlertView *_av;

}

@property (unsafe_unretained) id<BAMFacebookManagerDelegate> delegate;
@property (readonly) FBFriendPickerViewController *friendsPickerController;
@property (strong, nonatomic) NSArray *selectedFriends;

/*@property (strong, nonatomic) NSDictionary<BAMUser> *bamUser;*/

+(BAMFacebookManager *)shared;

-(void)getUserDetails;

-(NSString *)getUserBio;
-(NSArray *)getUserEducation;
-(NSArray *)getFavouriteAthletes;
-(NSArray *)getFavouriteTeams;
-(void)uploadImage:(UIImage *)image;
-(void)uploadImage:(UIImage *)image delegate:(id<BAMFacebookManagerDelegate>)delegate;
-(void)publishMessage:(NSString *)message withSource:(NSString *)source withPicture:(NSString *)pic withLink:(NSString *)link toUser:(NSString *)user;
-(void)foobar;

@end
