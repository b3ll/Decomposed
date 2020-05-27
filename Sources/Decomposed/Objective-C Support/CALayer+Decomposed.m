//
//  CALayer+Decomposed.m
//  Decomposed
//
//  Created by Adam Bell on 5/26/20.
//  Copyright © 2020 Adam Bell. All rights reserved.
//

#import "CALayer+Decomposed.h"

#import <simd/simd.h>
#import <Decomposed/Decomposed-Swift.h>

@implementation CALayer (Decomposed)

#define DecomposeTransform CATransform3DDecomposed *decomposed = [CATransform3DDecomposed decomposedTransform:self.transform];
#define DisableActions(block) [CATransaction begin]; [CATransaction setDisableActions:YES]; block(); [CATransaction commit];
#define RecomposeAndSetTransform self.transform = [decomposed recomposed];

// MARK: - Translation

- (CGPoint)de_translation
{
  DecomposeTransform;
  simd_double3 translation = decomposed.translation;
  return CGPointMake(translation.x, translation.y);
}

- (void)setDe_translation:(CGPoint)de_translation
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.translation = simd_make_double3(de_translation.x, de_translation.y, decomposed.translation.z);
    RecomposeAndSetTransform;
  });
}

- (simd_double3)de_translationXYZ
{
  DecomposeTransform;
  return decomposed.translation;
}

- (void)setDe_translationXYZ:(simd_double3)de_translationXYZ
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.translation = de_translationXYZ;
    RecomposeAndSetTransform;
  });
}

// MARK: - Scale

- (CGPoint)de_scale
{
  DecomposeTransform;
  simd_double3 scale = decomposed.scale;
  return CGPointMake(scale.x, scale.y);
}

- (void)setDe_scale:(CGPoint)de_scale
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.scale = simd_make_double3(de_scale.x, de_scale.y, decomposed.scale.z);
    RecomposeAndSetTransform;
  });
}

- (simd_double3)de_scaleXYZ
{
  DecomposeTransform;
  return decomposed.scale;
}

- (void)setDe_scaleXYZ:(simd_double3)de_scaleXYZ
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.scale = de_scaleXYZ;
    RecomposeAndSetTransform;
  });
}

// MARK: - Rotation

- (simd_quatd)de_rotation
{
  DecomposeTransform;
  return decomposed.rotation;
}

- (void)setDe_rotation:(simd_quatd)de_rotation
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.rotation = de_rotation;
    RecomposeAndSetTransform;
  });
}

// MARK: - Skew

- (simd_double3)de_skew
{
  DecomposeTransform;
  return decomposed.skew;
}

- (void)setDe_skew:(simd_double3)de_skew
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.skew = de_skew;
    RecomposeAndSetTransform;
  });
}

// MARK: - Perspective

- (simd_double4)de_perspective
{
  DecomposeTransform;
  return decomposed.perspective;
}

- (void)setDe_perspective:(simd_double4)de_perspective
{
  DecomposeTransform;
  DisableActions(^{
    decomposed.perspective = de_perspective;
    RecomposeAndSetTransform;
  });
}

@end
