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

HP_BEGIN_DECL_ENUM(uint8_t, ProcedureCreationReason) {
    PCReason_None,
    PCReason_Unknown,       // Unknown reason
    PCReason_User,          // Created by the used
    PCReason_Script,        // A Python script created the procedure
    PCReason_Called,        // A call statement has been found somewhere
    PCReason_Prolog         // A procedure prolog was detected during the analysis
}
HP_END_DECL_ENUM(ProcedureCreationReason);

HP_BEGIN_DECL_ENUM(uint8_t, CommentCreationReason) {
    CCReason_None,
    CCReason_Unknown,       // Unknown reason
    CCReason_User,          // Created by the used
    CCReason_Script,        // A Python script created the comment
    CCReason_Automatic,     // Automatic comment, like XREF comments, values found during the analysis...
}
HP_END_DECL_ENUM(CommentCreationReason);

HP_BEGIN_DECL_ENUM(uint8_t, NameCreationReason) {
    NCReason_None,
    NCReason_Unknown,       // Unknown reason
    NCReason_User,          // Created by the used
    NCReason_Script,        // A Python script created the name
    NCReason_Import,        // The name was read from the executable file
    NCReason_Metadata,      // The name was derived from metadata (like Objective-C)
    NCReason_Automatic      // An automatic temporary name (like sub_XXXXX)
}
HP_END_DECL_ENUM(NameCreationReason);

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

// Register Class

#define MAX_REGISTER_CLASS  16

HP_BEGIN_DECL_ENUM(NSUInteger, RegClass) {
    RegClass_CPUState = 0,                // State register
    RegClass_PseudoRegisterSTACK = 1,     // Pseudo registers to simulate the stack

    RegClass_GeneralPurposeRegister = 2,

    RegClass_FirstUserClass = 3,

    // x86
    RegClass_X86_FPU = RegClass_FirstUserClass,
    RegClass_X86_MMX,
    RegClass_X86_SSE,
    RegClass_X86_AVX,

    // ARM
    RegClass_ARM_VFP_Single = RegClass_FirstUserClass,
    RegClass_ARM_VFP_Double,
    RegClass_ARM_VFP_Quad,
    RegClass_ARM_Media
}
HP_END_DECL_ENUM(RegClass);

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
