/*************************************************************
   Ltver.h - LEADTOOLS version definition
   Copyright (c) 1991-2016 LEAD Technologies, Inc.
   All Rights Reserved.
*************************************************************/

#if !defined(LTVER_H)
#define LTVER_H

#if defined(LTV15_CONFIG)
#define LTVER_   1500
#define L_VER_DESIGNATOR "15"
#define FOR_PRE_16_5
#elif defined(LTV16_CONFIG)
#define LTVER_   1600
#define L_VER_DESIGNATOR "16"
#elif defined(LTV17_CONFIG)
#define LTVER_   1700
#define L_VER_DESIGNATOR "17"
#elif defined(LTV175_CONFIG)
#define LTVER_   1750
#define L_VER_DESIGNATOR "175"
#elif defined(LTV18_CONFIG)
#define LTVER_   1800
#define L_VER_DESIGNATOR "18"
#elif defined(LTV19_CONFIG)
#define LTVER_   1900
#define L_VER_DESIGNATOR "19"
#else
// Must be LTV##_CONFIG before including any LEADTOOLS header files
// For example:
// #define LTV175_CONFIG   // Using LEADTOOLS v17.5
// or
// #define LTV19_CONFIG    // Using LEADTOOLS v19
#if !defined(RC_INVOKED)
#error LEADTOOLS Vxx_CONFIG not found!
#endif // #if !defined(RC_INVOKED)
#endif // #if defined(LTV15_CONFIG)

#if defined(FOR_WINRT_PHONE)
#if (_MSC_VER >= 1800)
#define L_PLATFORM_DESIGNATOR "WinRTPhone8_1"
#else
#define L_PLATFORM_DESIGNATOR "WinRTPhone"
#endif
#elif defined(FOR_WINRT)
#if (_MSC_VER >= 1800)
#define L_PLATFORM_DESIGNATOR "WinRT8_1"
#else
#define L_PLATFORM_DESIGNATOR "WinRT"
#endif
#else
#if (_MSC_VER >= 1900)
#define L_PLATFORM_DESIGNATOR "CDLLVC14" /* VS 2015 - VC14*/
#elif (_MSC_VER >= 1800)
#define L_PLATFORM_DESIGNATOR "CDLLVC12" /* VS 2013 - VC12*/
#elif (_MSC_VER >= 1700)
#define L_PLATFORM_DESIGNATOR "CDLLVC11" /* VS 2012 - VC11*/
#elif (_MSC_VER >= 1600)
#define L_PLATFORM_DESIGNATOR "CDLLVC10" /* VS 2010 - VC10*/
#else
#define L_PLATFORM_DESIGNATOR "CDLL"     /* VS 2008 - VC09*/
#endif
#endif

#if LTVER_ >= 1600
#define LEADTOOLS_V16_OR_LATER
#endif

#if LTVER_ >= 1700
#define LEADTOOLS_V17_OR_LATER
#endif

#if LTVER_ >= 1750
#define LEADTOOLS_V175_OR_LATER
#endif

#if LTVER_ >= 1800
#define LEADTOOLS_V18_OR_LATER
#endif

#if LTVER_ >= 1900
#define LEADTOOLS_V19_OR_LATER
#endif

#endif // #if !defined(LTVER_H)
