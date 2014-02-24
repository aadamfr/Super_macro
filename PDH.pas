//*******************************************************
//
//    Copyright © 1995-2002 by Lucian Radulescu
//    mailto  :  lucian@ez-delphi.com
//    http    :  http://www.ez-delphi.com
//
//*******************************************************

// Unité ajouté pour palier au problème de nouveau processeur
unit PDH;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

const

  PDH_NO_DATA                      = $800007D5;
  PDH_MEMORY_ALLOCATION_FAILURE    = $C0000BBB;
  PDH_INVALID_HANDLE               = $C0000BBC;
  PDH_INVALID_ARGUMENT             = $C0000BBD;

  PDH_FMT_RAW                      = $00000010;
  PDH_FMT_ANSI                     = $00000020;
  PDH_FMT_UNICODE                  = $00000040;
  PDH_FMT_LONG                     = $00000100;
  PDH_FMT_DOUBLE                   = $00000200;
  PDH_FMT_LARGE                    = $00000400;
  PDH_FMT_NOSCALE                  = $00001000;
  PDH_FMT_1000                     = $00002000;
  PDH_FMT_NODATA                   = $00004000;
  PDH_FMT_NOCAP100                 = $00008000;

type

  PQUERY              = ^HQUERY;
  HQUERY              = THandle;

  PCOUNTER            = ^HCOUNTER;
  HCOUNTER            = THandle;

  PDH_STATUS          = Longint;

  PPERF_COUNTER_BLOCK = ^TPERF_COUNTER_BLOCK;
  _PERF_COUNTER_BLOCK = record                          // pcb
     ByteLength          : DWORD;
  end;
  {$EXTERNALSYM _PERF_COUNTER_BLOCK}
  TPERF_COUNTER_BLOCK = _PERF_COUNTER_BLOCK;
  PERF_COUNTER_BLOCK  = _PERF_COUNTER_BLOCK;
  {$EXTERNALSYM PERF_COUNTER_BLOCK}

  PPERF_COUNTER_DEFINITION = ^TPERF_COUNTER_DEFINITION;
  _PERF_COUNTER_DEFINITION = record                     // pcd
    ByteLength           : DWORD;
    CounterNameTitleIndex: DWORD;
    CounterNameTitle     : LPWSTR;
    CounterHelpTitleIndex: DWORD;
    CounterHelpTitle     : LPWSTR;
    DefaultScale         : DWORD;
    DetailLevel          : DWORD;
    CounterType          : DWORD;
    CounterSize          : DWORD;
    CounterOffset        : DWORD;
  end;
  {$EXTERNALSYM _PERF_COUNTER_DEFINITION}
  TPERF_COUNTER_DEFINITION = _PERF_COUNTER_DEFINITION;
  PERF_COUNTER_DEFINITION  = _PERF_COUNTER_DEFINITION;
  {$EXTERNALSYM PERF_COUNTER_DEFINITION}

  PPERF_DATA_BLOCK = ^TPERF_DATA_BLOCK;
  _PERF_DATA_BLOCK = record                             // pdb
    Signature            : array[0..3] of WCHAR;
    LittleEndian         : DWORD;
    Version              : DWORD;
    Revision             : DWORD;
    TotalByteLength      : DWORD;
    HeaderLength         : DWORD;
    NumObjectTypes       : DWORD;
    DefaultObject        : DWORD;
    SysTime              : SYSTEMTIME;
    PerfTime             : LARGE_INTEGER;
    PerfFreq             : LARGE_INTEGER;
    PerfTime100nSec      : LARGE_INTEGER;
    SystemNameLength     : DWORD;
    SystemNameOffset     : DWORD;
  end;
  {$EXTERNALSYM _PERF_DATA_BLOCK}
  TPERF_DATA_BLOCK  = _PERF_DATA_BLOCK;
  PERF_DATA_BLOCK   = _PERF_DATA_BLOCK;
  {$EXTERNALSYM PERF_DATA_BLOCK}

  PPERF_INSTANCE_DEFINITION = ^TPERF_INSTANCE_DEFINITION;
  _PERF_INSTANCE_DEFINITION = record                    // pid
    ByteLength           : DWORD;
    ParentObjectTitleIndex: DWORD;
    ParentObjectInstance : DWORD;
    UniqueID             : DWORD;
    NameOffset           : DWORD;
    NameLength           : DWORD;
  end;
  {$EXTERNALSYM _PERF_INSTANCE_DEFINITION}
  TPERF_INSTANCE_DEFINITION = _PERF_INSTANCE_DEFINITION;
  PERF_INSTANCE_DEFINITION  = _PERF_INSTANCE_DEFINITION;
  {$EXTERNALSYM PERF_INSTANCE_DEFINITION}

  PPERF_OBJECT_TYPE = ^TPERF_OBJECT_TYPE;
  _PERF_OBJECT_TYPE = record                            // pot
    TotalByteLength      : DWORD;
    DefinitionLength     : DWORD;
    HeaderLength         : DWORD;
    ObjectNameTitleIndex : DWORD;
    ObjectNameTitle      : LPWSTR;
    ObjectHelpTitleIndex : DWORD;
    ObjectHelpTitle      : LPWSTR;
    DetailLevel          : DWORD;
    NumCounters          : DWORD;
    DefaultCounter       : DWORD;
    NumInstances         : DWORD;
    CodePage             : DWORD;
    PerfTime             : LARGE_INTEGER;
    PerfFreq             : LARGE_INTEGER;
  end;
  {$EXTERNALSYM _PERF_OBJECT_TYPE}
  TPERF_OBJECT_TYPE = _PERF_OBJECT_TYPE;
  PERF_OBJECT_TYPE  = _PERF_OBJECT_TYPE;
  {$EXTERNALSYM PERF_OBJECT_TYPE}

  PPDH_FMT_COUNTERVALUE = ^TPDH_FMT_COUNTERVALUE;
  _PDH_FMT_COUNTERVALUE = record
    CStatus              : DWORD;
    longValue            : Longint;
    doubleValue          : double;
    largeValue           : LONGLONG;
    AnsiStringValue      : LPCSTR;
    WideStringValue      : LPCWSTR;
  end;
  {$EXTERNALSYM _PDH_FMT_COUNTERVALUE}
  TPDH_FMT_COUNTERVALUE = _PDH_FMT_COUNTERVALUE;
  PDH_FMT_COUNTERVALUE  = _PDH_FMT_COUNTERVALUE;
  {$EXTERNALSYM PDH_FMT_COUNTERVALUE}

    TPDH_COUNTER_PATH_ELEMENTS_A = record
    szMachineName : PChar;
    szObjectName : PChar;
    szInstanceName : PChar;
    szParentInstance : PChar;
    dwInstanceIndex : DWORD;
    szCounterName : PChar;
    end;

  PPDH_COUNTER_PATH_ELEMENTS_A = ^TPDH_COUNTER_PATH_ELEMENTS_A;
  TPDH_COUNTER_PATH_ELEMENTS = TPDH_COUNTER_PATH_ELEMENTS_A;
  PPDH_COUNTER_PATH_ELEMENTS = ^TPDH_COUNTER_PATH_ELEMENTS;



var
  PdhOpenQuery                : function( pReserved: Pointer;
                                          dwUserData: DWORD;
                                          phQuery: PQUERY  ): PDH_STATUS; stdcall;

  PdhCloseQuery               : function( ahQuery: HQUERY ): PDH_STATUS; stdcall;

  PdhAddCounter               : function( ahQuery: HQUERY;
                                          szFullCounterPath: PChar;
                                          dwUserData: DWORD;
                                          phCounter: PCOUNTER ): PDH_STATUS; stdcall;
  PdhRemoveCounter            : function( ahCounter: HCOUNTER ): PDH_STATUS; stdcall;

  PdhCollectQueryData         : function( ahQuery: HQUERY ): PDH_STATUS; stdcall;

  PdhValidatePath             : function( szFullCounterPath: PChar ): PDH_STATUS; stdcall;

  PdhGetFormattedCounterValue : function( ahCounter: HCOUNTER;
                                          dwFormat: DWORD;
                                          lpdwType: LPDWORD;
                                          pValue: PPDH_FMT_COUNTERVALUE): PDH_STATUS; stdcall;

           PdhMakeCounterPath: Function (var pCounterPathElements : PPDH_COUNTER_PATH_ELEMENTS;
                                          szFullPathBuffer : PChar;
                                          var pcchBufferSize : DWORD;
                                          dwFlags : DWORD) : PDH_STATUS; stdcall;

     PdhLookupPerfNameByIndex: Function (szMachineName : PChar;
                                         dwNameIndex : DWORD;
                                         szNameBuffer : PChar;
                                         var pcchNameBufferSize : DWORD) : PDH_STATUS; stdcall;


function LoadPdh: Boolean;

implementation

var
  hPdh: THandle = HINSTANCE_ERROR;

function LoadPdh: Boolean;
const
  pdh_lib  = 'pdh.dll';
begin
  Result := hPdh > HINSTANCE_ERROR;
  if Result then Exit;
  hPdh := LoadLibrary( pdh_lib );
  Result := hPdh > HINSTANCE_ERROR;
  if Result then
  begin
    PdhOpenQuery                := GetProcAddress( hPdh, 'PdhOpenQuery' );
    PdhCloseQuery               := GetProcAddress( hPdh, 'PdhCloseQuery' );
    PdhAddCounter               := GetProcAddress( hPdh, 'PdhAddCounterA' );
    PdhRemoveCounter            := GetProcAddress( hPdh, 'PdhRemoveCounter' );
    PdhCollectQueryData         := GetProcAddress( hPdh, 'PdhCollectQueryData' );
    PdhValidatePath             := GetProcAddress( hPdh, 'PdhValidatePathA' );
    PdhGetFormattedCounterValue := GetProcAddress( hPdh, 'PdhGetFormattedCounterValue' );
    PdhMakeCounterPath          := GetProcAddress( hPdh, 'PdhMakeCounterPath');
    PdhLookupPerfNameByIndex    := GetProcAddress( hPdh, 'PdhLookupPerfNameByIndex');
  end;
end;

initialization
  LoadPdh;
finalization
  if LoadPdh then
    FreeLibrary( hPdh );
end.
