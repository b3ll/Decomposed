//
//  Decomposed.h
//  Decomposed
//
//  Created by Adam Bell on 5/26/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for Decomposed.
FOUNDATION_EXPORT double DecomposedVersionNumber;

//! Project version string for Decomposed.
FOUNDATION_EXPORT const unsigned char DecomposedVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Decomposed/PublicHeader.h>
#import <simd/simd.h>

// This seems to be the only way to get the umbrella header to play nicely with Objective-C++ files *shrugs*
#ifdef __cplusplus
#ifdef __OBJC__
    #import <Decomposed/Decomposed-Swift.h>
#endif
#endif
