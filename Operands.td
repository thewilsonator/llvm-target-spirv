//===-- Operands.td - SPIRV Operand formats ----------------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Contains "operand type" definitions for the instruction format.
//===----------------------------------------------------------------------===//

// Represents an operand to a SPIRVInstruction
class Operand {

// Depending on the value of tag
// tag = 1, type = the type of the ID
// tag = 2,
//      type = 1, Int    immidiate
//      type = 2, String immidiate
//      type = 3, OpCode immidiate e.g. ExtInst
// tag = 3, type = section 3.${type} of the spec values of 2-31.
// union {
bits<8> enum_imm_type = 0;
Type    type_type;
// }
// 0 = invalid
// 1 = ID
// 2 = imm
// 3 = enum
bit<2> tag = 0;

// 0 = Type
// 1 = Var
// 2 = Const
// 3 = Sepc Const
bits<2> type_qual = 0;

// 0 = None/Scalar - scalar type
// 1 = Aliases - exist for this type
// 2 = Pointer - a pointer to
// 3 = VecScal - vector of, or scalar or
// 4 = Vector  - (only) vector of
// 5 = Matrix
// 6 = PointerVector
// 7 = Array
// 8 = Runtime Array
// 9 = {VecScal,VecScal}
bits<4> type_ext  = 0;

}
//Invalid
def oper_Invalid : Operand {
let tag = 0;
}
// {
// Enums
class EnumOperand<bits<8> val> {
let tag = 3;
let type = val;
}

def oper_SourceLanguage         : EnumOperand<2>;
def oper_ExecutionModel         : EnumOperand<3>;
def oper_AddressingModel        : EnumOperand<4>;
def oper_MemoryModel            : EnumOperand<5>;
def oper_ExecutionMode          : EnumOperand<6>;
def oper_StorageClass           : EnumOperand<7>;
def oper_Dim                    : EnumOperand<8>;
def oper_SamplerAddressingMode  : EnumOperand<9>;
def oper_SamplerFilterMode      : EnumOperand<10>;
def oper_ImageFormat            : EnumOperand<11>;
def oper_ImageChannelOrder      : EnumOperand<12>;
def oper_ImageChannelDataType   : EnumOperand<13>;
def oper_ImageOperands          : EnumOperand<14>;
def oper_FPFastMathMode         : EnumOperand<15>;
def oper_FPRoundingMode         : EnumOperand<16>;
def oper_LinkageType            : EnumOperand<17>;
def oper_AccessQualifier        : EnumOperand<18>;
def oper_FunctionParameterAttribute : EnumOperand<19>;
def oper_Decoration             : EnumOperand<20>;
def oper_BuiltIn                : EnumOperand<21>;
def oper_SelectionControl       : EnumOperand<22>;
def oper_LoopControl            : EnumOperand<23>;
def oper_FunctionControl        : EnumOperand<24>;
def oper_MemorySemantics        : EnumOperand<25>;
def oper_MemoryAccess           : EnumOperand<26>;
def oper_Scope                  : EnumOperand<27>;
def oper_GroupOperation         : EnumOperand<28>;
def oper_KernelEnqueueFlags     : EnumOperand<29>;
def oper_KernelProfilingInfo    : EnumOperand<30>;
def oper_Capability             : EnumOperand<31>;
// }
// Immidiates
class ImmidiateOperand<bits<8> val> {
let tag = 2;
let type = val;
}
def oper_ImmString : ImmidiateOperand<0>;
def oper_ImmInt32  : ImmidiateOperand<1>;
def oper_ImmOpCode : ImmidiateOperand<2>;

class IdOperand {
let tag = 1;
}
// Operand that is any <id>, wildcard.
// Should only really be used in debug insts.
def oper_AnyId : IdOperand { let type = 0; };

class Type<bits<8> val> {
  bits<8> Val = val;
}
def ty_Invalid      : Type<0>;
def ty_Any          : Type<1>;
def ty_Void         : Type<2>;
// Fundamental types
def ty_Bool         : Type<3>;
def ty_Int          : Type<4>;
def ty_Float        : Type<5>;
// Specialised Fundamental types
def ty_Int32        : Type<6>;
def ty_Float16      : Type<7>;
def ty_Float32      : Type<8>; // For OpenCL's half_* functions.
def ty_Sint         : Type<9>;
def ty_Uint         : Type<10>;
// Homogeneous Composite are in Operand.type_ext
// Heterogeneous Composite
def ty_Struct       : Type<11>;
def ty_Function     : Type<12>;
// Opaque
def ty_Forward      : Type<13>; // A foward declared type.
def ty_Opaque       : Type<14>;
// Opaque Image types
def ty_Image        : Type<15>;
def ty_Sampler      : Type<16>;
def ty_SampledImage : Type<17>;
// Opaque Pipe types.
def ty_Pipe         : Type<18>;
def ty_PipeStorage  : Type<19>; // Spec says this is a type not a storage class.
def ty_ReserveId    : Type<20>; // Really an int, but carries semantic meaning
// Opaque Host types.
def ty_Event        : Type<21>;
def ty_DeviceEvent  : Type<22>;
def ty_Queue        : Type<23>;
// Opaque other
def ty_NamedBarrier : Type<24>;
// Pseudo types
def ty_InstructionSet : Type<25>; // not to be confused with instset_*
def ty_Label          : Type<26>;
def ty_String         : Type<27>;
def ty_DecorationGroup: Type<25>;
// Specialised Heterogeneous Composite
def ty_NDRange      : TYpe<26>;

// The meta type is not a pseudo or opqaue type and can have constant instances
// must be able to declare Var and {Spec }Consts.
multiclass TypeVarConst<bits<8> val> {
  let type = val in  {
    def Type          : IdOperand { let type_qual = 0; }
    def Var           : IdOperand { let type_qual = 1; }
    def Constant      : IdOperand { let type_qual = 2; }
    def SepcConstant  : IdOperand { let type_qual = 3; }
  }
}
// The meta type is a valid type and can not have constant instances
multiclass TypeVar<bits<8> val> {
  let type = val in  {
    def Type : IdOperand { let type_qual = 0; }
    def Var  : IdOperand { let type_qual = 1; }
  }
}

}
// The meta type is a not valid type
// i.e. no corresponding OpTypeFoo instructions
// the "constructing" operation is OpFoo instead.
multiclass Var<bits<5> val> {
  def Var  : IdOperand { let type = val; let type_qual = 1; }
}
// There are no valid instances of this type e.g. void.
multiclass Type<bits<8> val> {
  def Type : IdOperand { let type = val; let type_qual = 0; }
}
// Scalar / VecScal : TypeVarConst
multiclass SVS_TVC<Type t> {
  defm Scalar  : TypeVarConst<t>;
  defm VecScal : TypeVarConst<t> { let type_ext = 3; }
}

def oper_Any                : TypeVarConst<ty_Any>;
def oper_AnyPointer         : TypeVar<ty_Any>      { let type_ext = 2; };
def oper_AnyVecScal         : TypeVarConst<ty_Any> { let type_ext = 1; };
def oper_AnyVector          : TypeVarConst<ty_Any> { let type_ext = 4; };
def oper_AnyPointerVecScal  : TypeVarConst<ty_Any> { let type_ext = 6; };
def oper_AnyMatrix          : TypeVarConst<ty_Any> { let type_ext = 5; };
def oper_Void               : Type<ty_Void>;
def oper_VoidPointer        : TypeVar<ty_Void> { let type_ext = 2; };
// Fundamental types
def oper_Bool               : SVS_TVC<ty_Bool>;
def oper_Int                : SVS_TVC<ty_Int>;
def oper_IntPointer         : TypeVar<ty_Int> { let type_ext= 2; };
def oper_Float              : SVS_TVC<ty_Float>;
def oper_FloatMatrix        : TypeVarConst<ty_Float> { let type_ext = 5; };
def oper_FloatVector        : TypeVarConst<ty_Float> { let type_ext = 4; };
// Specialised Fundamental types
def oper_Int32              : TypeVarConst<ty_Int32>;
def oper_Sint               : SVS_TVC<ty_Sint>;
def oper_SintArithExt       : TypeVarConst<ty_Sint> { let type_ext = 9; };
def oper_Uint               : SVS_TVC<ty_Sint>;
def oper_IntArithExt        : TypeVarConst<ty_Int>  { let type_ext = 9; };
def oper_Float16            : SVS_TVC<ty_Float16>;
def oper_Float32            : SVS_TVC<ty_Float132>;
// Heterogeneous Composite
def oper_Struct             : TypeVarConst<ty_Struct>;
def oper_Function           : TypeVar<ty_Function>;
// Opaque
def oper_ForwardPointer     : TypeVar<ty_Forward> { let type_ext= 2; };
def oper_Opaque             : Type<ty_Opaque>;
// Opaque Image
def oper_Image              : TypeVar<ty_Image>;
def oper_Sampler            : TypeVarConst<ty_Sampler>;
def oper_SampledImage       : TypeVarConst<ty_SampledImage>;
// Opaque Host
def oper_Event              : TypeVar<ty_Event>;
def oper_EventPointer       : TypeVar<ty_Event> { let type_ext= 2; };
def oper_DeviceEvent        : TypeVar<ty_DeviceEvent>;
def oper_DeviceEventPointer : TypeVar<ty_DeviceEvent> { let type_ext= 2; };
def oper_Queue              : TypeVar<ty_Queue>;
// Opaque Pipe
def oper_Pipe               : TypeVar<ty_Pipe>;
def oper_PipeStorage        : TypeVar<ty_PipeStorage>;
def oper_ReserveId          : TypeVar<ty_ReserveId>;
// Opaque other
def oper_NamedBarrier       : TypeVar<ty_NamedBarrier>;
// Pseudo
def oper_String             : Var<ty_String>;
def oper_InstructionSet     : Var<ty_InstructionSet>;
def oper_Label              : Var<ty_Label>;
def oper_DecorationGroup    : Var<ty_DecorationGroup>;
// Specialised Heterogeneous Composite
def oper_NDRange      : TypeVarConst<ty_NDRange>;
