//
// Hopper Disassembler SDK
//
// (c)2014 - Cryptic Apps SARL. All Rights Reserved.
// http://www.hopperapp.com
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY
// KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//

#ifndef _HOPPER_COMMONTYPES_H_
#define _HOPPER_COMMONTYPES_H_

// Addresses

typedef uint64_t Address;
typedef struct {
    Address from;
    size_t  len;
} AddressRange;

#define BAD_ADDRESS     ((Address)-1)

// Colors

typedef uint32_t Color;
#define NO_COLOR 0

#if defined(__OBJC__)
#define HP_BEGIN_DECL_ENUM(BASE,TYPE) typedef NS_ENUM(BASE,TYPE)
#define HP_END_DECL_ENUM(TYPE)
#define HP_BEGIN_DECL_OPTIONS(BASE,TYPE) typedef NS_OPTIONS(BASE,TYPE)
#define HP_END_DECL_OPTIONS(TYPE)
#else
#define HP_BEGIN_DECL_ENUM(BASE,TYPE) typedef enum
#define HP_END_DECL_ENUM(TYPE) TYPE
#define HP_BEGIN_DECL_OPTIONS(BASE,TYPE) typedef enum
#define HP_END_DECL_OPTIONS(TYPE) TYPE
#endif

HP_BEGIN_DECL_ENUM(uint8_t, ByteType) {
	Type_Undefined,
	Type_Outside,

	Type_Next,      /// This memory block info is part of the previous bloc

    Type_Int8,
    Type_Int16,
    Type_Int32,
    Type_Int64,
    
    Type_ASCII,
    Type_Unicode,

    Type_Data,      /// METATYPE : Only used for searching, no bytes have this type!
    
	Type_Code,
	Type_Procedure
}
HP_END_DECL_ENUM(ByteType);

// Operand Format
#define FORMAT_TYPE_MASK  0x7F

HP_BEGIN_DECL_ENUM(NSUInteger, ArgFormat) {
    Format_Default,

    Format_Hexadecimal,
    Format_Decimal,
    Format_Octal,
    Format_PseudoString,
    Format_StackVariable,
    Format_Offset,
    Format_Address,
    Format_Float,
    Format_Binary,

    Format_Signed = 0x80
}
HP_END_DECL_ENUM(ArgFormat);

// Switch / case Hints

HP_BEGIN_DECL_ENUM(uint8_t, HintValueType) {
    SwitchHint_None,
    SwitchHint_AbsoluteAddress,
    SwitchHint_TableRelative,
    SwitchHint_PICRelative,
    SwitchHint_FixedValueRelative
}
HP_END_DECL_ENUM(HintValueType);

// Plugin

HP_BEGIN_DECL_ENUM(NSUInteger, HopperPluginType) {
    Plugin_CPU,
    Plugin_Loader,
    Plugin_Tool
}
HP_END_DECL_ENUM(HopperPluginType);

// CPU Definition

HP_BEGIN_DECL_ENUM(NSUInteger, CPUEndianess) {
    CPUEndianess_Little,
    CPUEndianess_Big
}
HP_END_DECL_ENUM(CPUEndianess);

// File Loaders

HP_BEGIN_DECL_ENUM(NSUInteger, FileLoaderLoadingStatus) {
    DIS_OK,
    DIS_BadFormat,
    DIS_DebugMismatch,
    DIS_DebugUUIDMismatch,
    DIS_MissingProcessor,
    DIS_NotSupported
}
HP_END_DECL_ENUM(FileLoaderLoadingStatus);

HP_BEGIN_DECL_ENUM(NSUInteger, LOCKind) {
    LOC_Address,
    LOC_Checkbox,
    LOC_CPU,
    LOC_StringList
}
HP_END_DECL_ENUM(LOCKind);

HP_BEGIN_DECL_ENUM(NSUInteger, DFTAddressWidth) {
    AW_16bits = 1,
    AW_32bits = 2,
    AW_64bits = 3
}
HP_END_DECL_ENUM(DFTAddressWidth);

HP_BEGIN_DECL_OPTIONS(NSUInteger, FileLoaderOptions) {
    FLS_ParseObjectiveC = 1
}
HP_END_DECL_OPTIONS(FileLoaderOptions);

// Debugger

HP_BEGIN_DECL_ENUM(NSUInteger, DebuggerState) {
    STATE_NotConnected,
    STATE_Connected,
    STATE_Running,
    STATE_Signaled,
    STATE_Terminated,
    STATE_Exited
}
HP_END_DECL_ENUM(DebuggerState);

#endif
