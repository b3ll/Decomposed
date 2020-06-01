//
//  CALayer+Decomposed.m
//  Decomposed
//
//  Created by Adam Bell on 5/26/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

#import "CALayer+Decomposed.h"

#import <simd/simd.h>

#import "Decomposed-Swift.h"

@implementation DEDecomposedCATransform3DProxy {
  __weak CALayer *_layer;
}

#define DecomposeTransform DEDecomposedCATransform3D *decomposed = [DEDecomposedCATransform3D decomposedTransformWithTransform:_layer.transform];
#define DisableActions(block) [CATransaction begin]; [CATransaction setDisableActions:YES]; block(); [CATransaction commit];
#define RecomposeAndSetTransform self->_layer.transform = [decomposed recomposed];

- (instancetype)initWithLayer:(CALayer *)layer
{
  self = [super init];
  if (!self) { return nil; }

  _layer = layer;

  return self;
}

// MARK: - Translation

- (CGPoint)translation
{
  DecomposeTransform;
  simd_double3 translation = decomposed.translation;
  return CGPointMake(translation.x, translation.y);
}

- (void)setTranslation:(CGPoint)translation
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.translation = simd_make_double3(translation.x, translation.y, decomposed.translation.z);
    RecomposeAndSetTransform;
  });
}

- (simd_double3)translationXYZ
{
  DecomposeTransform;
  return decomposed.translation;
}

- (void)setTranslationXYZ:(simd_double3)translationXYZ
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.translation = translationXYZ;
    RecomposeAndSetTransform;
  });
}

// MARK: - Scale

- (CGPoint)scale
{
  DecomposeTransform;
  simd_double3 scale = decomposed.scale;
  return CGPointMake(scale.x, scale.y);
}

- (void)setScale:(CGPoint)scale
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.scale = simd_make_double3(scale.x, scale.y, decomposed.scale.z);
    RecomposeAndSetTransform;
  });
}

- (simd_double3)scaleXYZ
{
  DecomposeTransform;
  return decomposed.scale;
}

- (void)setScaleXYZ:(simd_double3)scaleXYZ
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.scale = scaleXYZ;
    RecomposeAndSetTransform;
  });
}

// MARK: - Rotation

- (simd_quatd)de_rotation
{
  DecomposeTransform;
  return decomposed.rotation;
}

- (void)setRotation:(simd_quatd)rotation
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.rotation = rotation;
    RecomposeAndSetTransform;
  });
}

- (simd_double3)eulerAngles
{
  DecomposeTransform;
  return decomposed.eulerAngles;
}

- (void)setEulerAngles:(simd_double3)eulerAngles
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.eulerAngles = eulerAngles;
    RecomposeAndSetTransform;
  });
}

// MARK: - Skew

- (simd_double3)de_skew
{
  DecomposeTransform;
  return decomposed.skew;
}

- (void)setSkew:(simd_double3)skew
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.skew = skew;
    RecomposeAndSetTransform;
  });
}

// MARK: - Perspective

- (simd_double4)perspective
{
  DecomposeTransform;
  return decomposed.perspective;
}

- (void)setPerspective:(simd_double4)perspective
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.perspective = perspective;
    RecomposeAndSetTransform;
  });
}

@end

@implementation CALayer (Decomposed)

- (DEDecomposedCATransform3DProxy *)transformProxy
{
  return [[DEDecomposedCATransform3DProxy alloc] initWithLayer:self];
}

@end
