#if !defined(LTCRT_H)
#define LTCRT_H

#if defined(__cplusplus)

#if defined(_MSC_VER) || defined(FOR_WINDOWS) || defined(FOR_WINRT)
   #if (_MSC_VER <=1200) || (_MSC_VER == 1310)
      #if defined(__cplusplus)
         #define L_USE_LTCRT_H
      #endif // #if defined(__cplusplus)
   #endif // #if (_MSC_VER <=1200) || (_MSC_VER == 1310)
#else
   #define L_USE_LTCRT_H
#endif // #if defined(FOR_WINDOWS) || defined(FOR_WINRT)

#if defined(L_USE_LTCRT_H)

   #include <stdio.h>
   #include <time.h>
   #include <string.h>
   #include <stdarg.h>

   #if defined(_MSC_VER)
      #pragma warning(disable: 4710)   // 'inline function' : function not expanded
      #include <tchar.h>
   #else
      #include <wchar.h>
   #endif // #if defined(_MSC_VER)

   #if defined(__GNUC__)
      #pragma GCC diagnostic push
      #pragma GCC diagnostic ignored "-Wunused-value"
   #endif // #if defined(__GNUC__)

   #if !defined (_countof)
      #define _countof(p) sizeof(p)/sizeof(p[0])
   #endif // #if !defined (_countof)

   #define errno_t int

   static inline int sprintf_s(char* p1, size_t sizeOfBuffer, const char* format, ...)
   {
      UNREFERENCED_PARAMETER(sizeOfBuffer);
      int nRet= 0;
      va_list args;
      va_start(args,format);
      nRet = vsprintf(p1,format,args);
      strcpy(p1 + nRet, "\0");
      va_end(args);
      return nRet;
   }

   static inline int sprintf_s(char* p1, const char* format, ...)
   {
      int nRet= 0;
      va_list args;
      va_start(args,format);
      nRet = vsprintf(p1,format,args);
      strcpy(p1 + nRet, "\0");
      va_end(args);
      return nRet;
   }

   static inline int vsprintf_s(char* p1, size_t sizeOfBuffer, const char* format, va_list args)
   {
      UNREFERENCED_PARAMETER(sizeOfBuffer);
      int nRet= 0;
      nRet = vsprintf(p1,format,args);
      strcpy(p1 + nRet, "\0");
      return nRet;
   }

   static inline int vsprintf_s(char* p1, const char* format, va_list args)
   {
      int nRet= 0;
      nRet = vsprintf(p1,format,args);
      strcpy(p1 + nRet, "\0");
      return nRet;
   }

#if defined(FOR_WINDOWS)
   static inline int _fcvt_s(char* buffer, size_t sizeInBytes, double value, int count, int*dec, int*sign)
   {
      UNREFERENCED_PARAMETER(sizeInBytes);
      buffer = _fcvt(value, count, dec, sign);
      return (buffer != NULL)?  1 : 0;
   }

   static inline int _gcvt_s(char*buffer, size_t sizeInBytes, double value, int digits)
   {
      UNREFERENCED_PARAMETER(sizeInBytes);
      _gcvt(value, digits, buffer);
      return (buffer != NULL)?  1 : 0;
   }

#if !defined(__BORLANDC__) || !(__CODEGEARC__ >= 0x0680)
   static inline int vswprintf_s(wchar_t* p1, size_t sizeOfBuffer, const wchar_t* format, va_list args)
   {
      int nRet = 0;
      UNREFERENCED_PARAMETER(sizeOfBuffer);
      nRet = vswprintf(p1,format,args);
      wcscpy(p1 + nRet, L"\0");
      return nRet;
   }
#endif // #if !defined(__BORLANDC__) || !(__CODEGEARC__ >= 0x0680)

   static inline int vswprintf_s(wchar_t* p1, const wchar_t* format, va_list args)
   {
      int nRet= 0;
      nRet = vswprintf(p1,format,args);
      wcscpy(p1 + nRet, L"\0");
      return nRet;
   }
#else
   #define vswprintf_s vswprintf
   #define _snprintf snprintf
   #define memcpy_s memcpy

   static inline int vswprintf_s(wchar_t* p1, const wchar_t* format, va_list args)
   {
      return vswprintf(p1,0x7FFFFFFF,format,args);
   }

   static inline void memcpy_s(void* _Dst, size_t _DstSize, const void* _Src, size_t _MaxCount)
   {
      memcpy(_Dst, _Src, _MaxCount);
   }
#endif // #if defined(FOR_WINDOWS)

   static inline int swprintf_s(wchar_t* p1, size_t sizeOfBuffer, const wchar_t* format, ...)
   {
      int nRet= 0;
      va_list args;
      va_start(args,format);
      nRet = vswprintf_s(p1, sizeOfBuffer, format, args);
      wcscpy(p1 + nRet, L"\0");
      va_end(args);
      return nRet;
   }

   static inline int swprintf_s(wchar_t* p1, const wchar_t* format, ...)
   {
      int nRet= 0;
      va_list args;
      va_start(args,format);
      nRet = vswprintf_s(p1,format,args);
      wcscpy(p1 + nRet, L"\0");
      va_end(args);
      return nRet;
   }

#if defined(FOR_WINDOWS)
   static inline errno_t _itoa_s(int value, char* buffer, size_t sizeInCharacters, int radix)
   {
      UNREFERENCED_PARAMETER(sizeInCharacters);
      itoa(value, buffer, radix);
      return 1;
   }

   static inline errno_t _itoa_s(int value, char* buffer, int radix)
   {
      itoa(value, buffer, radix);
      return 1;
   }

   static inline errno_t _itow_s(int value, wchar_t* buffer, size_t sizeInCharacters, int radix)
   {
      UNREFERENCED_PARAMETER(sizeInCharacters);
      _itow(value, buffer, radix);
      return 1;
   }

   static inline errno_t _itow_s(int value, wchar_t* buffer, int radix)
   {
      _itow(value, buffer, radix);
      return 1;
   }

   static inline errno_t _ui64toa_s(unsigned __int64 value, char* buffer, size_t sizeInCharacters, int radix)
   {
      UNREFERENCED_PARAMETER(sizeInCharacters);
      _ui64toa(value, buffer, radix);
      return 1;
   }

   static inline errno_t _ui64tow_s(unsigned __int64 value, wchar_t* buffer, size_t sizeInCharacters, int radix)
   {
      UNREFERENCED_PARAMETER(sizeInCharacters);
      _ui64tow(value, buffer, radix);
      return 1;
   }

   static inline errno_t _ui64toa_s(unsigned __int64 value, char* buffer, int radix)
   {
      _ui64toa(value, buffer, radix);
      return 1;
   }

   static inline errno_t _ui64tow_s(unsigned __int64 value, wchar_t* buffer, int radix)
   {
      _ui64tow(value, buffer, radix);
      return 1;
   }
#endif // #if defined(FOR_WINDOWS)

   static inline errno_t localtime_s(struct tm* _tm, const time_t* time)
   {
      struct tm* t = NULL;
      t = localtime(time);
      memcpy(_tm, t, sizeof(struct tm));
      return 0;
   }

   #define strtok_s strtok_r
   #define wcstok_s std::wcstok

   static inline errno_t strcpy_s(char* strDestination, size_t sizeInBytes, const char* strSource)
   {
      UNREFERENCED_PARAMETER(sizeInBytes);
      return strcpy(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t strcpy_s(char* strDestination, const char* strSource)
   {
      return strcpy(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t wcscpy_s(wchar_t* strDestination, size_t sizeInWords, const wchar_t* strSource)
   {
      UNREFERENCED_PARAMETER(sizeInWords);
      return wcscpy(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t wcscpy_s(wchar_t* strDestination, const wchar_t* strSource)
   {
      return wcscpy(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t strcat_s(char* strDestination, size_t sizeInBytes, const char* strSource)
   {
      UNREFERENCED_PARAMETER(sizeInBytes);
      return strcat(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t strcat_s(char* strDestination, const char* strSource)
   {
      return strcat(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t wcscat_s(wchar_t* strDestination, size_t sizeInWords, const wchar_t* strSource)
   {
      UNREFERENCED_PARAMETER(sizeInWords);
      return wcscat(strDestination, strSource) ? 1 : 0;
   }

   static inline errno_t wcscat_s(wchar_t* strDestination, const wchar_t* strSource)
   {
      return wcscat(strDestination, strSource) ? 1 : 0;
   }

#if defined(FOR_WINDOWS) && (_MSC_VER <=1200)
   static inline double _wtof(const wchar_t* str)
   {
      char* pmbbuf = (char*)malloc(MB_CUR_MAX);
      wcstombs(pmbbuf, str, MB_CUR_MAX);
      return atof(pmbbuf);
   }
#endif // #if defined(FOR_WINDOWS) && (_MSC_VER <=1200)

   static inline size_t mbstowcs_s(size_t* convertedChars, wchar_t* wcstr, size_t sizeInWords, const char* mbstr, size_t count)
   {
      UNREFERENCED_PARAMETER(convertedChars);
      UNREFERENCED_PARAMETER(sizeInWords);

      return mbstowcs(wcstr, mbstr, count) != (size_t)-1 ? 0 : -1;
   }

   static inline size_t mbstowcs_s(size_t* convertedChars, wchar_t* wcstr, const char* mbstr, size_t count)
   {
      UNREFERENCED_PARAMETER(convertedChars);

      return mbstowcs(wcstr, mbstr, count) != (size_t)-1 ? 0 : -1;
   }

   static inline size_t wcstombs_s(size_t* convertedChars, char* mbstr, size_t sizeInBytes, const wchar_t* wcstr, size_t count)
   {
      UNREFERENCED_PARAMETER(convertedChars);
      UNREFERENCED_PARAMETER(sizeInBytes);

      return wcstombs(mbstr, wcstr, count) != (size_t)-1 ? 0 : -1;
   }

   static inline size_t wcstombs_s(size_t* convertedChars, char* mbstr, const wchar_t* wcstr, size_t count)
   {
      UNREFERENCED_PARAMETER(convertedChars);

      return wcstombs(mbstr, wcstr, count) != (size_t)-1 ? 0 : -1;
   }

   static inline errno_t strncpy_s(char* dest, size_t destsz, const char* src, size_t count)
   {
      UNREFERENCED_PARAMETER(destsz);
      strncpy(dest, src, count);
      return 0;
   }

   static inline errno_t _strupr_s(char *str, size_t numberOfElements)
   {
      UNREFERENCED_PARAMETER(numberOfElements);
      strupr(str);
      return 0;

   }

   static inline errno_t _strlwr_s(char *str, size_t numberOfElements)
   {
      UNREFERENCED_PARAMETER(numberOfElements);
      strlwr(str);
      return 0;
   }

#if defined(FOR_WINDOWS)
   static inline errno_t _splitpath_s(const char* path, char* drive, size_t driveNumberOfElements, char* dir, size_t dirNumberOfElements, char* fname, size_t nameNumberOfElements, char* ext, size_t extNumberOfElements)
   {
      UNREFERENCED_PARAMETER(driveNumberOfElements);
      UNREFERENCED_PARAMETER(dirNumberOfElements);
      UNREFERENCED_PARAMETER(nameNumberOfElements);
      UNREFERENCED_PARAMETER(extNumberOfElements);
      return _splitpath(path, drive, dir, fname, ext);
   }

   static inline errno_t makepath_s(char *path, size_t sizeInBytes, const char *drive, const char *dir, const char *fname, const char *ext)
   {
      UNREFERENCED_PARAMETER(sizeInBytes);
      return _makepath_s(path, drive, dir, fname, ext);
   }
#endif

   #define sscanf_s                                      sscanf

   static inline errno_t wcsncpy_s(wchar_t *strDest, size_t numberOfElements, const wchar_t *strSource, size_t count)
   {
      UNREFERENCED_PARAMETER(numberOfElements);
      wcsncpy(strDest, strSource, count);
      return 0;
   }

#if defined(FOR_UNICODE)
   static inline errno_t _wcsupr_s(wchar_t* str, size_t numberOfElements)
   {
      UNREFERENCED_PARAMETER(numberOfElements);
      _wcsupr(str);
      return 0;
   }

   static inline errno_t _wcslwr_s(wchar_t* str, size_t numberOfElements)
   {
      UNREFERENCED_PARAMETER(numberOfElements);
      _wcslwr(str);
      return 0;
   }
#endif

#if defined(FOR_WINDOWS)
   static inline errno_t _wsplitpath_s(const wchar_t* path, wchar_t* drive, size_t driveNumberOfElements, wchar_t* dir, size_t dirNumberOfElements, wchar_t* fname, size_t nameNumberOfElements, wchar_t* ext, size_t extNumberOfElements)
   {
      UNREFERENCED_PARAMETER(driveNumberOfElements);
      UNREFERENCED_PARAMETER(dirNumberOfElements);
      UNREFERENCED_PARAMETER(nameNumberOfElements);
      UNREFERENCED_PARAMETER(extNumberOfElements);
      return _splitpath(path, drive, dir, fname, ext);
   }

   static inline errno_t _wmakepath_s(wchar_t* path, size_t sizeInWords, const wchar_t* drive, const wchar_t* dir, const wchar_t* fname, const wchar_t* ext)
   {
      UNREFERENCED_PARAMETER(sizeInWords);
      return _wmakepath(path, drive, dir, fname, ext);
   }
#endif

   #if defined(_UNICODE)
      #define _tsplitpath_s                                 _wsplitpath_s
      #define _tcscpy_s                                     wcscpy_s
      #define _tcscat_s                                     wcscat_s
      #define _tcsupr_s                                     _wcsupr_s
      #define _stprintf_s                                   swprintf_s
      #define _tcsncpy_s                                    wcsncpy_s
      #define _tcslwr_s                                     wcslwr_s
      #define _tmakepath_s                                  _wmakepath_s
      #define _itot_s                                       _itow_s
      #define _tcstok_s                                     wcstok_s
      #define _ui64tot_s                                    _ui64tow_s
      #define _tstof                                        _wtof
      #define _snwprintf_s                                  _snwprintf(p1,p3,p4)
      #define _vstprintf_s                                  vswprintf_s
   #else
      #define _tsplitpath_s                                 _splitpath_s
      #define _tcscpy_s                                     strcpy_s
      #define _tcscat_s                                     strcat_s
      #define _tcsupr_s                                     _strupr_s
      #define _stprintf_s                                   sprintf_s
      #define _tcslwr_s                                     _strlwr_s
      #define _itot_s                                       _itoa_s
      #define _tcstok_s                                     strtok_s
      #define _ui64tot_s                                    _ui64toa_s
      #define _tstof                                        atof
      #define _tmakepath_s                                  _makepath_s
      #define _vstprintf_s                                  vsprintf_s
   #endif // #if defined(_UNICODE)

#if defined(FOR_WINDOWS) && (_MSC_VER <=1200)
   #define _tstoi64                                          _ttoi64
   #define _tstoi                                           _ttoi
#endif // #if defined(FOR_WINDOWS) && (_MSC_VER <=1200)

#if defined(__GNUC__)
#pragma GCC diagnostic pop
#endif // #if defined(__GNUC__)

#endif // #if defined(L_USE_LTCRT_H)

#endif //#if defined(__cplusplus)

#endif // #if !defined(LTCRT_H)
