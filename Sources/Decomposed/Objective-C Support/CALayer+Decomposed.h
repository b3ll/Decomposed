//
//  CALayer+Decomposed.h
//  Decomposed
//
//  Created by Adam Bell on 5/26/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

/// This class exposes properties to manipulate the transform of a `CALayer` directly with implicit actions (animations) disabled.
@interface CALayer (Decomposed)

/// The translation of the layer's transform (X and Y) as a CGPoint.
@property (nonatomic, readwrite) CGPoint de_translation;

/// The translation of the layer's transform (X, Y, and Z) as a vector.
@property (nonatomic, readwrite) simd_double3 de_translationXYZ;

/// The scale of the layer's transform (X and Y) as a CGPoint.
@property (nonatomic, readwrite) CGPoint de_scale;

/// The scale of the layer's transform (X, Y, and Z) as a vector.
@property (nonatomic, readwrite) simd_double3 de_scaleXYZ;

/// The rotation of the layer's transform (expressed as a quaternion).
@property (nonatomic, readwrite) simd_quatd de_rotation;

/// The shearing of the layer's transform as a vector.
@property (nonatomic, readwrite) simd_double3 de_skew;

/// The perspective of the layer's transform as a vector (e.g. .m34).
@property (nonatomic, readwrite) simd_double4 de_perspective;

@end

NS_ASSUME_NONNULL_END
