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
@interface DEDecomposedCATransform3DProxy: NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithLayer:(CALayer *)layer NS_DESIGNATED_INITIALIZER;

/// The translation of the layer's transform (X and Y) as a CGPoint.
@property (nonatomic, readwrite) CGPoint translation;

/// The translation of the layer's transform (X, Y, and Z) as a vector.
@property (nonatomic, readwrite) simd_double3 translationXYZ;

/// The scale of the layer's transform (X and Y) as a CGPoint.
@property (nonatomic, readwrite) CGPoint scale;

/// The scale of the layer's transform (X, Y, and Z) as a vector.
@property (nonatomic, readwrite) simd_double3 scaleXYZ;

/// The rotation of the layer's transform (expressed as a quaternion).
@property (nonatomic, readwrite) simd_quatd rotation;

/// The euler angles of the layer's transform (expressed in radians).
@property (nonatomic, readwrite) simd_double3 eulerAngles;

/// The shearing of the layer's transform as a vector.
@property (nonatomic, readwrite) simd_double3 skew;

/// The perspective of the layer's transform as a vector (e.g. .m34).
@property (nonatomic, readwrite) simd_double4 perspective;

@end

@interface CALayer (Decomposed)

/// A proxy object for `DEDecomposedCATransform3D` that when changed, will apply the recomposed transform to the associated layer with implicit actions (animations) disabled.
@property (nonatomic, readonly) DEDecomposedCATransform3DProxy *transformProxy;

@end

NS_ASSUME_NONNULL_END
