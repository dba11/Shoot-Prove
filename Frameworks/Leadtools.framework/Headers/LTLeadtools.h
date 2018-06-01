//
//  LTLeadtools.h
//  Leadtools Framework
//
//  Copyright © 1991-2016 LEAD Technologies, Inc. All rights reserved.
//

#import "TargetConditionals.h"

#if !defined(LTLEADTOOLS_H)
#define LTLEADTOOLS_H

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#     define FOR_IOS
#     undef FOR_OSX
#  else
#     define FOR_OSX
#     undef FOR_IOS
#endif

#if !defined(LTVLATEST_CONFIG)
#  define LTVLATEST_CONFIG LTV19_CONFIG
#  define LTVERLATEST_ 1900
#  define L_VERLATEST_DESIGNATOR "19"
#endif

#if !defined(LTVER_)
#  if defined(LTV18_CONFIG)
#    define LTVER_ 1800
#    define L_VER_DESIGNATOR "18"
#  elif defined(LTV19_CONFIG)
#    define LTVER_ 1900
#    define L_VER_DESIGNATOR "19"
#  else
#    define LTVER_ LTVERLATEST_
#    define L_VER_DESIGNATOR L_VERLATEST_DESIGNATOR
#    define LTV19_CONFIG
#  endif

#  if LTVER_ >= 160
#    define LEADTOOLS_V16_OR_LATER
#  endif
#  if LTVER_ >= 1700
#    define LEADTOOLS_V17_OR_LATER
#  endif
#  if LTVER_ >= 1750
#    define LEADTOOLS_V175_OR_LATER
#  endif
#  if LTVER_ >= 1800
#    define LEADTOOLS_V18_OR_LATER
#  endif
#  if LTVER_ >= 1900
#    define LEADTOOLS_V19_OR_LATER
#  endif
#endif

#define LT_DEPRECATED(ltVersion, message) LT_DEPRECATED_##ltVersion(message)
#define LT_DEPRECATED_USENEW(ltVersion, alternative) LT_DEPRECATED_USENEW_##ltVersion(alternative)

#if defined(LEADTOOLS_V18_OR_LATER)
#  define LT_DEPRECATED_18_0(message) __deprecated_msg("Deprecated starting LEADTOOLS 18.0. " message) OBJC_SWIFT_UNAVAILABLE("Deprecated starting LEADTOOLS 18.0. " message)
#  define LT_DEPRECATED_USENEW_18_0(alternative) __deprecated_msg("Deprecated starting LEADTOOLS 18.0. Use '" alternative "' instead.") OBJC_SWIFT_UNAVAILABLE("Deprecated starting LEADTOOLS 18.0. Use '" alternative "' instead.")
#else
#  define LT_DEPRECATED_18_0(message)
#  define LT_DEPRECATED_USENEW_18_0(alternative)
#endif

#if defined(LEADTOOLS_V19_OR_LATER)
#  define LT_DEPRECATED_19_0(message) __deprecated_msg("Deprecated starting LEADTOOLS 19.0. " message) OBJC_SWIFT_UNAVAILABLE("Deprecated starting LEADTOOLS 19.0. " message)
#  define LT_DEPRECATED_USENEW_19_0(alternative) __deprecated_msg("Deprecated starting LEADTOOLS 19.0. Use '" alternative "' instead.") OBJC_SWIFT_UNAVAILABLE("Deprecated starting LEADTOOLS 19.0. Use '" alternative "' instead.")
#else
#  define LT_DEPRECATED_19_0(message)
#  define LT_DEPRECATED_USENEW_19_0(message)
#endif

#endif // #if !defined(LTLEADTOOLS_H)