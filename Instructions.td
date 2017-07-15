//===-- Instructions.td - SPIRV Core Instructions ----------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// File contains section 3.32 of the SPIRV Spec
//===----------------------------------------------------------------------===//


class InstructionSet<bits<2> val,int version> {
bits<2> Val = val;
int Version = version;
}
def instset_Core   : InstructionSet<0,100>;
def instset_OpenCL : InstructionSet<1,100>;
def instset_GLSL   : InstructionSet<2,450>;
// Section 3.32 Instructions
class SPIRVInstruction< bits<32> base_word_count, bits<32> op, bits<24> resIdx,
                        list<Operand> operands, list<Capability> cap = [], bit variable = 0> {
  bits<32> BaseWordCount = base_word_count;
  bits<32> Op = op;
  bits<32> Op2 = 0; // Opcode of Extension instruction if applicable
  // which index, 1 based, (if any) of 'Operands' is a new id returned by this instruction?
  bits<23> ResultIdIndex = resIdx;
  bit      BBTerminator = 0;
  // Subsection of 3.32 of the spec that this instruction belongs to
  // useful for splicing out debug instructions?
  bits<5> InstClass;// 23 subsections of 3.32 for SPIRV Core / Subsections of section 2 OpenCL
  bit VariableLength = variable; // anything with oper_ImmString is automatically
  // is this an instruction from a Set other then core? e.g. OpenCL.std.100
  InstructionSet = instset_Core;

  list<Operand> Operands = operands;
  list<Capability> Cap = cap;
}
// void(void)
class InstEffectOnly<bits<32> op> : SPIRVInstruction<1,op,0,[]>;
// void(string)
class InstTakesSting<bits<32> op> : SPIRVInstruction<2,op,0,[oper_ImmString]>;
// booln(floatn)
class InstFPClassify<bits<32> op> : SPIRVInstruction<4,op,2,[oper_BoolVecScalType,oper_BoolVecScalVar,
                                                             oper_FloatVecScalVar]>;
// Compare
class InstFPCompare<bits<32> op>  : SPIRVInstruction<5,op,2,[oper_BoolVecScalType,oper_BoolVecScalVar,
                                                             oper_FloatVecScalVar,oper_FloatVecScalVar]>;
class InstBoolCompare<bits<32> op> : SPIRVInstruction<5,op,2,[oper_BoolVecScalType,oper_BoolVecScalVar,
                                                               oper_BoolVecScalVar,oper_BoolVecScalVar]>;
class InstIntCompare<bits<32> op> : SPIRVInstruction<5,op,2,[oper_IntVecScalType,oper_IntVecScalVar,
                                                             oper_IntVecScalVar,oper_IntVecScalVar]>;

// Binary
class InstFPBinary<bits<32> op> : SPIRVInstruction<5,op,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                           oper_FloatVecScalVar,oper_FloatVecScalVar]>;
class InstIntBinary<bits<32> op> : SPIRVInstruction<5,op,2,[oper_IntVecScalType,oper_IntVecScalVar,
                                                             oper_IntVecScalVar,oper_IntVecScalVar]>;
class InstSintBinary<bits<32> op> : SPIRVInstruction<5,op,2,[oper_SintVecScalType,oper_SintVecScalVar,
                                                             oper_SintVecScalVar,oper_SintVecScalVar]>;
class InstUintBinary<bits<32> op> : SPIRVInstruction<5,op,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                             oper_UintVecScalVar,oper_UintVecScalVar]>;
// Extanded Arithmetic
class InstIntArithExt<bits<32> op>: SPIRVInstruction<5,op,2,[oper_IntArithExtType,oper_IntArithExtVar,
                                                              oper_IntArithExtVar,oper_IntArithExtVar]>;
class InstSintArithExt<bits<32> op>: SPIRVInstruction<5,op,2,[oper_SintArithExtType,oper_SintArithExtVar,
                                                              oper_IintArithExtVar,oper_SintArithExtVar]>;

// Atomic binary
class InstAtomIntBinary<bits<32> op> : SPIRVInstruction<7,op,2,[oper_IntScalarType,oper_IntPointerVar,
                                                                oper_Scope,
                                                                oper_MemorySemantics,oper_IntVar]>;
// Unary
class InstFPUnary<bits<32> op> : SPIRVInstruction<4,op,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                          oper_FloatVecScalVar]>;

// Atomic unary
class InstAtomIntUnary<bits<32> op> : SPIRVInstruction<6,op,2,[oper_IntScalarType,oper_IntPointerType,
                                                               oper_Scope,
                                                               oper_MemorySemantics]>;
// Atomic compare exchange
class InstAtomCmpXchg<bits<32> op> : SPIRVInstruction<9,op,2,[oper_IntScalarType,oper_IntScalarVar,
                                                              oper_IntPointerVar,oper_Scope,
                                                              oper_MemorySemantics,oper_MemorySemantics,
                                                              oper_IntScalarVar,oper_IntScalarVar]>;

// Derivative
class InstDerivative<bits<32> op> : SPIRVInstruction<4,op,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                             oper_FloatVecScalVar]>;
// LifeTime
class InstLifeTime<bits<32> op> : SPIRVInstruction<3,op,0,[oper_AnyPointer,oper_ImmInt32]>;

// Group
class InstGroupBool<bits<32> op> : SPIRVInstruction<5,op,2,[oper_BoolType,oper_BoolVar,oper_Scope,
                                                            oper_BoolVar]>;
class InstGroupInt<bits<32> op> : SPIRVInstruction<6,op,2,[oper_IntScalarType,oper_IntScalarVar,
                                                           oper_Scope,oper_GroupOperation,
                                                           oper_IntScalarVar]>;
class InstGroupUint<bits<32> op> : SPIRVInstruction<6,op,2,[oper_UintScalarType,oper_UintScalarVar,
                                                            oper_Scope,oper_GroupOperation,
                                                            oper_UintScalarVar]>;
class InstGroupSint<bits<32> op> : SPIRVInstruction<6,op,2,[oper_SintScalarType,oper_SintScalarVar,
                                                            oper_Scope,oper_GroupOperation,
                                                            oper_SintScalarVar]>;
class InstGroupFloat<bits<32> op> : SPIRVInstruction<6,op,2,[oper_FloatScalarType,oper_FloatScalarVar,
                                                             oper_Scope,oper_GroupOperation,
                                                             oper_FloatScalarVar]>;

// Kernel
class InstKernelGetND<bits<32> op> :SPIRVInstruction<8,op,2,[oper_Int32Type,oper_Int32Var,oper_NDRangeVar,

// Pipe
class InstPipeGroupCommit<bits<32> op> : SPIRVInstruction<6,op,0,[oper_Scope,oper_PipeVar,
                                                                  oper_ReserveId,oper_Int32Var,oper_Int32Var]>;
class InstPipeGroupReserve<bits<32> op> : SPIRVInstruction<8,op,2,[oper_ReserveIdType,oper_ReserveIdVar,
                                                                   oper_Scope,oper_PipeVar,
                                                                   oper_Int32Var,oper_Int32Var,
                                                                   oper_Int32Varoper_Int32Var,]>;
class InstPipeGet<bits<32> op> : SPIRVInstruction<6,op,2,[oper_Int32Type,oper_Int32Var,
                                                          oper_PipeVar,oper_Int32Var,oper_Int32Var]>;
class InstPipeCommit<bits<32> op> : SPIRVInstruction<5,op,0,[oper_PipeVar,oper_ReserveIdVar,
                                                             oper_Int32Var,oper_Int32Var]>;
class InstPipeReservePackets<bits<32> op> : SPIRVInstruction<7,op,2,[oper_ReserveIdType,oper_ReserveIdVar,
                                                                     oper_PipeVar,oper_Int32Var,
                                                                     oper_Int32Var,oper_Int32Var]>;
class InstPipeReserve<bits<32> op> : SPIRVInstruction<9,op,2,[oper_Int32Type,oper_Int32Var,oper_PipeVar,
                                                              oper_ReserveIdVar,oper_Int32Var,oper_AnyPointer,
                                                              oper_Int32Var,oper_Int32Var]>;
class InstPipe<bits<32> op> : SPIRVInstruction<7,op,2,[oper_Int32Type,oper_Int32Var,oper_PipeVar,
                                                       oper_AnyPointer,oper_Int32Var,oper_Int32Var]>;
// Subsection 1 - Miscellaneous Instructions

let InstClass = 1 in {
  def inst_OpNop    : InstEffectOnly<0>;
  def inst_OpUndef  : SPIRVInstruction<3,1,2,[oper_AnyType,oper_AnyVar]>;
  def inst_OpSizeOf   : SPIRVInstruction<4,321,2,[oper_AnyType,oper_Int32Var,oper_PointerType]>;
}

// Subsection 2 - Debug Instructions

let InstClass = 2 in {
  def inst_OpSourceContinued : InstTakesSting<2>;
  def inst_OpSource          : SPIRVInstruction<3,3,[oper_SourceLanguage,oper_ImmInt32,
                                                    oper_StringVar,oper_ImmString],[],1>;
  def inst_OpSourceExtension : InstTakesSting<4>;
  def inst_OpName            : SPIRVInstruction<3,5,0,[oper_AnyId,oper_ImmString]>;
  def inst_OpMemberName      : SPIRVInstruction<4,6,0,[oper_StructType,oper_ImmInt32,oper_ImmString]>;
  def inst_OpString          : SPIRVInstruction<3,7,1,[oper_StringVar,oper_ImmString]>;
  def inst_OpLine            : SPIRVInstruction<4,8,[oper_StringVar,oper_ImmInt32,oper_ImmInt32]>;
  def inst_OpNoLine          : InstEffectOnly<317>;
  def inst_OpModuleProcessed : InstTakesSting<330>;
}

// Subsection 3 - Annotation Instructions

let InstClass = 3 in {
  def inst_OpDecorate         : SPIRVInstruction<3,71,0,0,[oper_AnyId,oper_Decoration],[],1>;
  def inst_OpMemberDecorate   : SPIRVInstruction<4,72,0,[oper_StructType,oper_ImmInt32,oper_Decoration,[],1>;
  def inst_OpDecorationGroup  : SPIRVInstruction<2,73,1,[oper_DecorationGroupVar]>;
  def inst_OpGroupDecorate    : SPIRVInstruction<2,74,0,[oper_DecorationGroupVar,oper_AnyId],[],1>;
  def inst_OpGroupMemberDecorate : SPIRVInstruction<3,75,0,[oper_DecorationGroupVar,
                                                            oper_StructType,oper_ImmInt32],[],1>;
}

// Subsection 4 - Extension Instructions

let InstClass = 4 in {
  def inst_OpExtension        : InstTakesSting<10>;
  def inst_OpExtInstImport    : SPIRVInstruction<3,11,1,[oper_InstructionSetVar,oper_ImmString],[],1>;

  def inst_OpExtInst  : SPIRVInstruction<5,12,2,[oper_AnyType,oper_AnyId,
                                                 oper_InstructionSetVar,oper_ImmOpCode,Operand],[],1>;
}

// Subsection 5 - Mode-Setting Instructions

let InstClass = 5 in {
  def inst_OpMemoryModel : SPIRVInstruction<3,14,0[oper_AddressModel,oper_MemoryModel]>;
// The last oper_AnyId I think is for variables associated with a stage of the graphics pipeline
// and any variables referenced by a kernel and its static call tree.
// Perhaps oper_AnyVar should be used instead.
  def inst_OpEntryPoint  : SPIRVInstruction<4,15,0,[oper_ExecutionModel,oper_Function,
                                                    oper_ImmString,oper_AnyId],[],1>;
  def inst_OpExecutionMode : SPIRVInstruction<3,16,0,[oper_FunctionVar,oper_ExecutionMode],[],1>;
  def inst_OpCapability    : SPIRVInstruction<2,17,0,[oper_Capability]>;
}

// Subsection 6 - Type-Declaration Instructions

let InstClass = 6 in {
  def inst_OpTypeVoid   : SPIRVInstruction<2,19,1,[oper_VoidType]>;
  def inst_OpTypeBool   : SPIRVInstruction<2,20,1,[oper_BoolType]>;
  def inst_OpTypeInt    : SPIRVInstruction<4,21,1,[oper_IntType,oper_ImmInt32,oper_ImmInt32]>;//width,sign
  def inst_OpTypeFloat  : SPIRVInstruction<3,22,1,[oper_TypeFloat,oper_ImmInt32]>;//width
// The oper_AnyType must be a scalar
  def inst_OpTypeVector : SPIRVInstruction<4,23,1,[oper_AnyVectorType,oper_AnyType,oper_ImmInt32]>;
  def inst_OpTypeMatrix : SPIRVInstruction<4,24,1,[oper_TypeMatrix,
                                                   oper_AnyVectorType,oper_ImmInt32],[cap_Matrix]>;
// The oper_AnyType must be an Integer type or VoidType
  // 9 base + plus optional AccessQualifier
  def inst_OpTypeImage  : SPIRVInstruction<9,25,1,[oper_ImageType,oper_AnyType,Dim,
                                              oper_ImmInt32,oper_ImmInt32,oper_ImmInt32,oper_ImmInt32,
                                              oper_ImageFormat,oper_AccessQualifier],[],1>;
  def inst_OpTypeSampler : SPIRVInstruction<2,26,1,[oper_SamplerType]>;
  def inst_OpTypeSampledImage : SPIRVInstruction<3,27,1,[oper_SampledImageType,oper_ImageType]>;
// A static array
  def inst_OpTypeArray : SPIRVInstruction<4,28,1,[oper_ArrayType,
                                                oper_AnyType,oper_ConstantInt]>;

  def inst_OpTypeRuntimeArray : SPIRVInstruction<3,29,1,[oper_RuntimeArrayType,oper_AnyType]>;
  def inst_OpTypeStruct : SPIRVInstruction<2,30,1,[oper_StructType,oper_AnyType],[],1>;
  def inst_OpTypeOpaque : SPIRVInstruction<3,31,1,[oper_OpaqueType,oper_ImmString],[cap_Kernel],1>;
  def inst_OpTypePointer : SPIRVInstruction<4,32,1,[oper_PointerType,oper_StorageClass,oper_AnyType]>;
// oper_AnyType is return type, arg types...
  def inst_OpTypeFunction : SPIRVInstruction<3,33,1,[oper_FunctionType,oper_AnyType,oper_AnyType],[],1>;
  def inst_OpTypeEvent : SPIRVInstruction<2,34,1,[oper_EventType],[cap_Kernel]>;
  def inst_OpTypeDeviceEvent : SPIRVInstruction<2,35,1,[oper_DeviceEventType],[cap_DeviceEnqueue]>;
  def inst_OpTypeReserveId : SPIRVInstruction<2,36,1,[oper_ReserveIdType],[cap_Pipes]>;
  def inst_OpTypeQueue : SPIRVInstruction<2,37,1,[oper_QueueType],[cap_DeviceEnqueue]>;
  def inst_OpTypePipe : SPIRVInstruction<3,38,1,[oper_PipeType,oper_AccessQualifier],[cap_Pipes]>;
  def inst_OpTypeForwardPointer : SPIRVInstruction<3,39,1,[oper_ForwardPointerType,
                                                        oper_StorageClass],[cap_Addresses]>;

  def inst_OpTypePipeStorage : SPIRVInstruction<2,322,1,[oper_PipeStorageType],[cap_PipeStorage]>;
  def inst_OpTypeNamedBarrier : SPIRVInstruction<2,322,1,[oper_NamedBarrierType],[cap_NamedBarrier]>;
}

// Subsection 7 - Constant-Creation Instructions
let InstClass = 7 in {
// Non-spec constants
  def inst_OpConstantTrue : SPIRVInstruction<3,41,2,[oper_BoolType,oper_BoolConstant]>;
  def inst_OpConstantFalse : SPIRVInstruction<3,42,2,[oper_BoolType,oper_BoolConstant]>;
  def inst_OpConstant : SPIRVInstruction<3,43,2,[oper_AnyType,oper_AnyConstant,Operand],[],1>;
  def inst_OpConstantComposite : SPIRVInstruction<3,44,2,[oper_StructType,oper_StructConstant,Operand],[],1>;
  def inst_OpConstantSampler : SPIRVInstruction<6,45,2,[oper_SamplerType,oper_SamplerCanstant,
                                oper_SamplerFilterMode,oper_ImmInt32,oper_SamplerAddressingMode],
                                [cap_LiteralSampler]>;
// Declare a constant with a "null" or falsey value. e.g. null ,false, 0, etc.
  def inst_OpConstantNull : SPIRVInstruction<3,46,2,[oper_AnyType,oper_AnyConstant]>;
// Sepcialisation constants
  def inst_OpSpecConstantTrue : SPIRVInstruction<3,48,2,[oper_BoolType,oper_BoolSpecConstant]>;
  def inst_OpSpecConstantFalse : SPIRVInstruction<3,49,2,[oper_BoolType,oper_BoolSpecConstant]>;
  def inst_OpSpecConstant : SPIRVInstruction<3,50,2,[oper_AnyType,oper_AnySepcConstant,Operand],[],1>;
  def inst_OpSpecConstantComposite : SPIRVInstruction<3,51,2,[oper_AnyType,
                                                              oper_StructSpecCpnstant,Operand],[],1>;
  def inst_OpSpecConstantOp : SPIRVInstruction<4,52,2,[oper_AnyType,
                                                       oper_AnySpecConstant,oper_ImmInt32,Operand],[],1>;
}

// Subsection 8 - Memory Instructions
let InstClass = 8 in {
// oper_AnyId is optional initialiser
  def inst_OpVariable : SPIRVInstruction<4,59,2,[oper_PointerType,oper_PointerVar,
                                                 oper_StorageClass,oper_AnyVar],[],1>;
// Both pointers to image types ENCODE PROPERLY
  def inst_OpImageTexelPointer : SPIRVInstruction<6,60,2,[oper_PointerType,oper_PointerVar,
                                                          oper_PointerVar,oper_AnyVar,oper_AnyVar]>;
  def inst_OpLoad : SPIRVInstruction<4,61,2,[oper_AnyType,oper_AnyVar,
                                             oper_PointerVar,oper_MemorySemantics],[],1>;
  def inst_OpStore : SPIRVInstruction<3,62,0,[oper_AnyType,
                                              oper_PointerVar,oper_MemorySemantics],[],1>;
  def inst_OpCopyMemory : SPIRVInstruction<3,63,0,[oper_PointerVar,oper_PointerVar,oper_MemorySemantics]>;
  def inst_OpCopyMemorySized : SPIRVInstruction<4,64,0,
                                                    [oper_PointerVar,
                                                     oper_PointerVar,oper_MemorySemantics,
                                                     operIntVar,oper_MemorySemantics,[cap_Addresses],1]>;
  def inst_OpAccessChain : SPIRVInstruction<4,65,2,[oper_PointerType,
                                                    oper_PointerVar,oper_PointerType,oper_IntVar],[],1>;
  def inst_OpInBoundsAccessChain : SPIRVInstruction<4,66,2,[oper_PointerType,oper_PointerVar,
                                                            oper_PointerType,oper_IntVar],[],1>;
  def inst_OpPtrAccessChain : SPIRVInstruction<5,67,2,[oper_PointerType,oper_PointerVar,
                                                     oper_PointerType,oper_AnyType,oper_IntVar],
                                                    [cap_Addresses],1>;
  def inst_OpArrayLength : SPIRVInstruction<5,68,2,[oper_Int32Type,oper_Int32Var,
                                                  oper_StructType,oper_ImmInt32],[cap_Shader]>;
  def inst_OpGenericPtrMemSemantics : SPIRVInstruction<4,69,2,[oper_Int32Type],oper_Int32Var,
                                                               oper_PointerVar,[cap_Kernel]>;
  def inst_OpInBoundsPtrAccessChain : SPIRVInstruction<5,70,2,[oper_PointerType,oper_PointerVar,
                                                               oper_PointerType,oper_AnyType,oper_IntVar],
                                                              [cap_Addresses],1>;
}

// Subection 9 - Function Instructions
let InstClass = 9 in {
  def inst_OpFunction : SPIRVInstruction<5,54,2,[oper_FunctionType,oper_FunctionVar,
                                                oper_FunctionControl,oper_FunctionType]>;
  def inst_OpFunctionParameter : SPIRVInstruction<3,55,2,[oper_AnyType,oper_AnyVar]>;
  def inst_OpFunctionEnd : SPIRVInstruction<1,56,0[]>;
//oper_AnyVar is the functions arguments.
  def inst_OpFunctionCall : SPIRVInstruction<4,57,2,[oper_AnyType,oper_AnyVar,oper_FunctionVar,oper_AnyVar]>;
}

// Subsection 10 - Image Instructions
let InstClass = 10 in {
/* TODO
  def inst_OpSampledImage : SPIRVInstruction<5,86
  def inst_OpImageSampleImplicitLod : SPIRVInstruction<
  def inst_OpImageSampleExplicitLod
  def inst_OpImageSampleDrefImplicitLod
  def inst_OpImageSampleDrefExplicitLod
  def inst_OpImageSampleProjImplicitLod
  def inst_OpImageSampleProjExplicitLod
  def inst_OpImageSampleProjDrefImplicitLod
  def inst_OpImageSampleProjDrefExplicitLod
  def inst_OpImageFetch
  def inst_OpImageGather
  def inst_OpImageDrefGather
  def inst_OpImageRead
  def inst_OpImageWrite
  def inst_OpImage
  def inst_OpImageQueryFormat
  def inst_OpImageQueryOrder
  def inst_OpImageQuerySizeLod
  def inst_OpImageQuerySize
  def inst_OpImageQueryLod
  def inst_OpImageQueryLevels
  def inst_OpImageQuerySamples : SPIRVInstruction<107
  def inst_OpImageSparseSampleImplicitLod : SPIRVInstruction<305
  def inst_OpImageSparseSampleExplicitLod
  def inst_OpImageSparseSampleDrefImplicitLod
  def inst_OpImageSparseSampleDrefExplicitLod
  def inst_OpImageSparseSampleProjImplicitLod
  def inst_OpImageSparseSampleProjExplicitLod
  def inst_OpImageSparseSampleProjDrefImplicitLod
  def inst_OpImageSparseSampleProjDrefExplicitLod
  def inst_OpImageSparseFetch
  def inst_OpImageSparseGather
  def inst_OpImageSparseDrefGather
  def inst_OpImageSparseTexelsResident : SPIRVInstruction<316
  def inst_OpImageSparseRead : SPIRVInstruction<320
*/
}

// Subsection 11 - Conversion Instructions
let InstClass = 11 in {
  def inst_OpConvertFToU    : SPIRVInstruction<4,109,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                        oper_FloatVecScalVar]>;
  def inst_OpConvertFToS    : SPIRVInstruction<4,110,2,[oper_SintVecScalType,oper_SintVecScalVar,
                                                        oper_FloatVecScalVar]>;
  def inst_OpConvertSToF    : SPIRVInstruction<4,111,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                        oper_SintVecScalVar]>;
  def inst_OpConvertUToF    : SPIRVInstruction<4,112,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                        oper_UintVecScalVar]>;
  def inst_OpUConvert       : SPIRVInstruction<4,113,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                        oper_UintVecScalVar]>;
  def inst_OpSConvert       : SPIRVInstruction<4,114,2,[oper_SintVecScalType,oper_SintVecScalVar,
                                                        oper_SintVecScalVar]>;
  def inst_OpFConvert       : SPIRVInstruction<4,115,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                        oper_FloatVecScalVar]>;
  def inst_OpQuantiseToF16  : SPIRVInstruction<4,116,2,[oper_Float32VecScalType,oper_Float32VecScalVar,
                                                        oper_Float32VecScalVar]>;
  def inst_OpConvertPtrToU  : SPIRVInstruction<4,117,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                        oper_AnyPointerVecScalVar]>;
  def inst_OpSatConvertSToU : SPIRVInstruction<4,118,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                        oper_SintVecScalVar]>;
  def inst_OpSatConvertUToS : SPIRVInstruction<4,119,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                        oper_SintVecScalVar]>;
  def inst_OpConvertUToPtr  : SPIRVInstruction<4,120,2,[oper_AnyPointerVecScalType,oper_AnyPointerVecScal,
                                                        oper_UintVecScalVar]>;
  def inst_OpPtrCastToGeneric : SPIRVInstruction<4,121,2,[oper_AnyPointerType,oper_AnyPointerVar,
                                                          oper_AnyPointerVar]>;
  def inst_OpGenericCastToPtr : SPIRVInstruction<4,122,2,[oper_AnyPointerType,oper_AnyPointerVar,
                                                          oper_AnyPointerVar]>;
  def inst_OpGenericCastToPtrExplicit : SPIRVInstruction<5,123,2,[oper_AnyPointerType,oper_AnyPointerVar,
                                                                  oper_AnyPointerVar,oper_StorageClass]>;
  def inst_OpBitcast : SPIRVInstruction<4,124,2,[oper_AnyType,oper_AnyVar,oper_AnyVar]>;
}

// Subsection 12 - Composite Instructions
let InstClass = 12 in {
  def inst_OpVectorExtractDynamic : SPIRVInstruction<5,77,2,[oper_AnyVectorType,oper_AnyVectorVar,
                                                             oper_AnyVectorVar,oper_IntVar]>;
  def inst_OpVectorInsertDynamic : SPIRVInstruction<6,78,2, [oper_AnyVectorType,oper_AnyVectorVar,
                                                             oper_AnyVectorVar,oper_Any,oper_IntVar]>;
  def inst_OpVectorShuffle : SPIRVInstruction<5,79,2,[oper_AnyVectorType,oper_AnyVectorVar,
                                                      oper_AnyVectorVar,oper_AnyVectorVar,
                                                      oper_ImmInt32,oper_ImmInt32]>;
  // oper_AnyType is struct vector or matrix
  def inst_OpCompositeConstruct : SPIRVInstruction<3,80,2,[oper_AnyType,oper_AnyVar,oper_AnyVar,[],1]>;
  // GEP
  def inst_OpCompositeExtract : SPIRVInstruction<4,81,2,[oper_AnyType,oper_AnyVar,
                                                         oper_AnyVar,[],1]>;
  def inst_OpCompositeInsert : SPIRVInstruction<5,82,2,[oper_AnyType,oper_AnyVar,
                                       /*insert this*/  oper_AnyVar,
                                       /*into this  */  oper_AnyVar,oper_ImmInt32[],1]>;
  def inst_OpCopyObject : SPIRVInstruction<4,83,2,[oper_AnyType,oper_AnyVar,oper_AnyVar]>;
  def inst_OpTranspose  : SPIRVInstruction<4,84,2,[oper_AnyMatrixType,oper_AnyMatrixVar,oper_AnyMatrixVar]>;
}

// Subsection 13- Arithmetic Instructions
let InstClass = 13 in {
// Unary
  def inst_OpSNegate: SPIRVInstruction<4,126,2,[oper_SintVecScalType,oper_SintVecScalVar,
                                                oper_SintVecScalVar]>;

  def inst_OpFNegate : InstFPUnary<127>;
// Binary
  def inst_OpIAdd : InstIntBinary <128>;
  def inst_OpFAdd : InstFPBinary  <129>;
  def inst_OpISub : InstIntBinary <130>;
  def inst_OpFSub : InstFPBinary  <131>;
  def inst_OpIMul : InstIntBinary <132>;
  def inst_OpFMul : InstFPBinary  <133>;
  def inst_OpUDiv : InstUintBinary<134>;
  def inst_OpSDiv : InstSintBinary<135>;
  def inst_OpFDiv : InstFPBinary  <136>;
  def inst_OpUMod : InstUintBinary<137>;
  def inst_OpSRem : InstSintBinary<138>;
  def inst_OpSMod : InstSintBinary<139>;
  def inst_OpFRem : InstFPBinary  <140>;
  def inst_OpFMod : InstFPBinary  <141>;

  def inst_OpVectorTimesScalar : SPIRVInstruction<5,142,2,[oper_FloatVectorType,oper_FloatVectorVar,
                                                           oper_FloatVectorVar,oper_FloatScalarVar]>;
  def inst_OpMatrixTimesScalar : SPIRVInstruction<5,143,2,[oper_FloatMatrixType,oper_FloatMatrixVar,
                                                           oper_FloatMatrixVar,oper_FloatScalarVar]>;
  def inst_OpVectorTimesMatrix : SPIRVInstruction<5,144,2,[oper_FloatVectorType,oper_FloatVectorVar,
                                                           oper_FloatVectorVar,oper_FloatMatrixType]>;
  def inst_OpMatrixTimesVector : SPIRVInstruction<5,145,2,[oper_FloatVectorType,oper_FloatVectorVar,
                                                           oper_FloatMatrixVar,oper_FloatVectorVar]>;
  def inst_OpMatrixTimesMatrix : SPIRVInstruction<5,146,2,[oper_FloatMatrixType,oper_FloatMatrixVar,
                                                           oper_FloatMatrixVar,oper_FloatMatrixVar]>;
  def inst_OpOuterProduct      : SPIRVInstruction<5,147,2,[oper_FloatMatrixType,oper_FloatMatrixVar,
                                                           oper_FloatVectorVar,oper_FloatVectorVar]>;
  def inst_OpDot               : SPIRVInstruction<5,148,2,[oper_FloatScalarType,oper_FloatScalarVar,
                                                           oper_FloatVectorVar,oper_FloatVectorVar]>;

  def inst_OpIAddCarry    : InstUintArithExt<149>;
  def inst_OpISubBorrow   : InstUintArithExt<150>;
  def inst_OpUMulExtended : InstUintArithExt<151>;
  def inst_OpSMulExtended : InstSintArithExt<152>;
}

// Subsection 14 - Bit Instructions
let InstClass = 14 in {
  def inst_OpShiftRightLogical      : InstIntBinary<194>;
  def inst_OpShiftRightArithmetic   : InstIntBinary<195>;
  def inst_OpShiftLeftLogical       : InstIntBinary<196>;
  def inst_OpBitwiseOr              : InstIntBinary<197>;
  def inst_OpBitwiseXor             : InstIntBinary<198>;
  def inst_OpBitwiseAnd             : InstIntBinary<199>;

  def inst_OpNot : SPIRVInstruction<5,200,2,[oper_IntVecScalType,oper_IntVecScalVar,oper_IntVecScalvar]>;

  def inst_OpBitFieldInsert : SPIRVInstruction<7,201,2,[oper_IntVecScalType,oper_IntVecScalVar,
                                                        oper_IntVecScalVar,oper_IntVecScalVar,
                                                        oper_IntScalarVar,oper_IntScalarVar]>;
  def inst_OpBitFieldSExtract : SPIRVInstruction<6,202,2,[oper_UintVecScalType,oper_UintVecScalVar,
                                                          oper_UintVecScalVar,
                                                          oper_UintScalarVar,oper_SintScalarVar]>;
  def inst_OpBitFieldUExtract : SPIRVInstruction<6,203,2,[oper_SintVecScalType,oper_SintVecScalVar,
                                                          oper_SintVecScalVar,
                                                          oper_SintScalarVar,oper_SintScalarVar]>;

  def inst_OpBitReverse : InstIntBinary<204>;
  def inst_OpBitCount   : InstIntBinary<205>;
}

// Subsection 15 Relational and Logical Instructions
let InstClass = 15 in {
  def inst_OpAny : SPIRVInstruction<4,154,2,[oper_BoolType,oper_BoolVar,oper_BoolVecScalVar>;
  def inst_OpAll : SPIRVInstruction<4,154,2,[oper_BoolType,oper_BoolVar,oper_BoolVecScalVar>;

  def inst_OpIsNan            : InstFPClassify <156>;
  def inst_OpIsInf            : InstFPClassify <157>;
  def inst_OpIsFinite         : InstFPClassify <158>;
  def inst_OpIsNormal         : InstFPClassify <159>;
  def inst_OpSignBitSet       : InstFPClassify <160>;
  def inst_OpLessOrGreater    : InstFPCompare  <161>;
  def inst_OpOrdered          : InstFPCompare  <162>;
  def inst_OpUnordered        : InstFPCompare  <163>;
  def inst_OpLogicalEqual     : InstBoolCompare<164>;
  def inst_OpLogicalNotEqual  : InstBoolCompare<165>;
  def inst_OpLogicalOr        : InstBoolCompare<166>;
  def inst_OpLogicalAnd       : InstBoolCompare<167>;

  def inst_OpLogicalNot : SPIRVInstruction<4,168,2,[oper_BoolVecScalType,oper_BoolVecScalVar,oper_BoolVecScalVar>;

  def inst_OpSelect : SPIRVInstruction<6,169,2,[oper_AnyVecScalType,oper_AnyVecScalVar,oper_BoolVecScalVar,
                                                oper_AnyVecScalVar,oper_AnyVecScalVar]>;


  def inst_OpIEqual             : InstIntCompare<170>;
  def inst_OpINotEqual          : InstIntCompare<171>;
  def inst_OpUGreaterThan       : InstIntCompare<172>;
  def inst_OpSGreaterThan       : InstIntCompare<173>;
  def inst_OpUGreaterThanEqual  : InstIntCompare<174>;
  def inst_OpSGreaterThanEqual  : InstIntCompare<175>;
  def inst_OpULessThan          : InstIntCompare<176>;
  def inst_OpSLessThan          : InstIntCompare<177>;
  def inst_OpULessThanEqual     : InstIntCompare<178>;
  def inst_OpSLessThanEqual     : InstIntCompare<179>;

  def inst_OpFOrdEqual              : InstFPCompare<180>;
  def inst_OpFUnordEqual            : InstFPCompare<181>;
  def inst_OpFOrdNotEqual           : InstFPCompare<182>;
  def inst_OpFUnordNotEqual         : InstFPCompare<183>;
  def inst_OpFOrdLessThan           : InstFPCompare<184>;
  def inst_OpFUnordLessThan         : InstFPCompare<185>;
  def inst_OpFOrdGreaterThan        : InstFPCompare<186>;
  def inst_OpFUnordGreaterThan      : InstFPCompare<187>;
  def inst_OpFOrdLessThanEqual      : InstFPCompare<188>;
  def inst_OpFUnordLessThanEqual    : InstFPCompare<189>;
  def inst_OpFOrdGreaterThanEqual   : InstFPCompare<190>;
  def inst_OpFUnordGreaterThanEqual : InstFPCompare<191>;
}

// Subsection 16 - Derivative Instructions

let InstClass = 16 in {
  def inst_OpDPdx           : InstDerivative<207>;
  def inst_OpDPdy           : InstDerivative<208>;
  def inst_OpFwidth         : InstDerivative<209>;
  def inst_OpDPdxFine       : InstDerivative<210>;
  def inst_OpDPdyFine       : InstDerivative<211>;
  def inst_OpFwidthFine     : InstDerivative<212>;
  def inst_OpDPdxCoarse     : InstDerivative<213>;
  def inst_OpDPdyCoarse     : InstDerivative<214>;
  def inst_OpFwidthCoarse   : InstDerivative<215>;
}

// Subsection 17 - Control-Flow Instructions
// All different
let InstClass = 17 in {
  def inst_OpPhi : SPIRVInstruction<3,245,2,[oper_AnyType,oper_AnyVar,oper_LabelVar],[],1>;
  def inst_OpLoopMerge : SPIRVInstruction<4,246,0,[oper_LabelVar,oper_LabelVar,oper_LoopControl],[],1>;
  def inst_OpSelectionMerge : SPIRVInstruction<3,247,0[oper_LabelVar,oper_SelectionControl]>;
  def inst_OpLabel : SPIRVInstruction<2,248,1,[oper_LabelVar]>;
  def inst_OpBranch : SPIRVInstruction<2,248,0,[oper_LabelVar]>;
  def inst_OpBranchConditional : SPIRVInstruction<4,249,0,[oper_BoolVar,
                                                           oper_LabelVar,oper_LabelVar,
                                                           oper_ImmInt32,oper_ImmInt32],[],1>;
  def inst_OpSwitch : SPIRVInstruction<3,251,0,[oper_Int32Var,oper_LabelVar, // Default
                                                oper_ImmInt32,oper_LabelVar],[],1>;// Cases
  
  // Fragment Execution Model.
  def inst_OpKill   : InstEffectOnly<252> { let Cap = [cap_Shader]; let BBTerminator = 1; };
  
  def inst_OpReturn : InstEffectOnly<253> { let BBTerminator = 1; };
  // OpReturnValue does not generate a new ID.
  def inst_OpReturnValue : SPIRVInstruction<2,254,0,[oper_AnyVar]> { let BBTerminator = 1; };
  def inst_OpUnreachable  : InstEffectOnly<255> { let BBTerminator = 1; };
  def inst_OpLifetimeStart : InstLifeTime<256>;
  def inst_OpLifetimeStop : InstLifeTime<257>;
}

// Subsection 18 - Atomic Instructions
let InstClass = 18 in {
  //oper_Any is int or float
  def inst_OpAtomicLoad : SPIRVInstruction<6,227,2,[oper_AnyType,oper_AnyVar,oper_AnyPointerVar
                                                    oper_Scope,oper_MemorySemantics]>;
  def inst_OpAtomicStore : SPIRVInstruction<5,227,0,[oper_AnyPointerVar,oper_Scope,
                                                     oper_MemorySemantics,oper_AnyVar]>;
  def inst_OpAtomicExchange : InstAtomIntBinary<229>;
  def inst_OpAtomicCompareExchange : InstAtomCmpXchg<230>;
  def inst_OpAtomicCompareExchangeWeak InstAtomCmpXchg<321>;

  def inst_OpAtomicIIncrement : InstAtomIntUnary<232>;
  def inst_OpAtomicIDecrement : InstAtomIntUnary<233>;
  def inst_OpAtomicIAdd : InstAtomIntBinary<234>;
  def inst_OpAtomicISub : InstAtomIntBinary<235>;
  def inst_OpAtomicSMin : InstAtomIntBinary<236>;
  def inst_OpAtomicUMin : InstAtomIntBinary<237>;
  def inst_OpAtomicSMax : InstAtomIntBinary<238>;
  def inst_OpAtomicUMax : InstAtomIntBinary<239>;
  def inst_OpAtomicAnd  : InstAtomIntBinary<240>;
  def inst_OpAtomicOr   : InstAtomIntBinary<241>;
  def inst_OpAtomicXor  : InstAtomIntBinary<242>;
  def inst_OpAtomicFlagTestAndSet : InstAtomIntUnary<318>;
  def inst_OpAtomicFlagClear : SPIRVInstruction<4,319,0,[oper_IntPointerVar,oper_Scope,oper_MemorySemantics]>;
}

// Subsection 19 - Primitive Instructions
let InstClass = 19 in {
  def inst_OpEmitVertex           : InstEffectOnly<218>;
  def inst_OpEndPrimitive         : InstEffectOnly<219>;
  def inst_OpEmitStreamVertex     : InstEffectOnly<220>;
  def inst_OpEndStreamPrimitive   : InstEffectOnly<221>;
}

// Subsection 20 - Barrier Instructions
let InstClass = 20 in {
  def inst_OpControlBarrier : SPIRVInstruction<4,224,0,[oper_Scope,oper_Scope,oper_MemorySemantics]>;
  def inst_OpMemoryBarrier  : SPIRVInstruction<3,225,0,[oper_Scope,oper_MemorySemantics]>;
  def inst_OpNamedBarrierInitialize : SPIRVInstruction<4,224,2,[oper_NamedBarrierType,oper_NamedBarrierVar,
                                                                oper_Int32Var]>;
  def inst_OpMemoryNamedBarrier : SPIRVInstruction<4,224,0,[oper_NamedBarrierVar,oper_Scope,
                                                            oper_MemorySemantics]>;
}

// Subsection 21 - Group Instructions
// TODO: KHR Extensions
let InstClass = 21 in {
  // oper_Int is sieze_t
  def inst_OpGroupAsyncCopy : SPIRVInstruction<9,259,2,[oper_EventType,oper_EventVar,oper_Scope,
                                                        oper_AnyPointerVar,oper_AnyPointerVar,oper_IntVar,
                                                        oper_IntVar,oper_EventVar]>;
  def inst_OpGroupWaitEvents : SPIRVInstruction<4,260,0,[oper_Scope,oper_Int32Var,oper_EventPointer]>;

  def inst_OpGroupAll : InstGroupBool<261>;
  def inst_OpGroupAny : InstGroupBool<262>;
  //i32/64 or f16/32/64
  def inst_OpGroupBroadcast : SPIRVInstruction<6,263,2,[oper_AnyType,oper_AnyVar,oper_Scope,oper_AnyVar,
                                                        oper_IntVecScal]>;
  def inst_OpGroupIAdd : InstGroupInt  <264>;
  def inst_OpGroupFAdd : InstGroupFloat<265>;
  def inst_OpGroupFMin : InstGroupFloat<266>;
  def inst_OpGroupUMin : InstGroupUint <267>;
  def inst_OpGroupSMin : InstGroupSint <268>;
  def inst_OpGroupFMax : InstGroupFloat<269>;
  def inst_OpGroupUMax : InstGroupUint <270>;
  def inst_OpGroupSMax : InstGroupSint <271>;
//  def inst_OpSubgroupBallotKHR
//  def inst_OpSubgroupFirstInvocationKHR
//  def inst_OpSubgroupReadInvocationKHR
}

// Subsection 22 - Device-Side Enqueue Instructions
let InstClass = 22 in {
  def inst_OpEnqueueMarker : SPIRVInstruction<7,291,2,[oper_Int32Type,oper_Int32Var,
                                                       oper_QueueVar,oper_Int32Var,
                                                       oper_DeviceEventPointerVar,
                                                       oper_DeviceEventPointerVar]>;
/* TODO
  def inst_OpEnqueueKernel
  def inst_OpGetKernelNDrangeSubGroupCount
  def inst_OpGetKernelNDrangeMaxSubGroupSize
  def inst_OpGetKernelWorkGroupSize
  def inst_OpGetKernelPreferredWorkGroupSizeMultiple
  def inst_OpRetainEvent
  def inst_OpReleaseEvent
  def inst_OpCreateUserEvent
  def inst_OpIsValidEvent
  def inst_OpSetUserEventStatus
  def inst_OpCaptureEventProfilingInfo
  def inst_OpGetDefaultQueue
  def inst_OpBuildNDRange
  def inst_OpGetKernelLocalSizeForSubgroupCount
  def inst_OpGetKernelLocalSizeForSubgroupCount
*/
}

// Subsection 23 - Pipe Instructions
let InstClass = 23 in {
  def inst_OpReadPipe  : InstPipe<275>;
  def inst_OpWritePipe : InstPipe<275>;
  def inst_OpReservedReadPipe  : InstPipeReserve<276>;
  def inst_OpReservedWritePipe : InstPipeReserve<277>;
  def inst_OpReserveReadPipePackets  : InstPipeReservePackets<278>;
  def inst_OpReserveWritePipePackets : InstPipeReservePackets<279>;
  def inst_OpCommitReadPipe    : InstPipeCommit<280>;
  def inst_OpCommitWritePipe   : InstPipeCommit<281>;
  def inst_OpIsValidReserveId  : SPIRVInstruction<4,282,2,[oper_BoolType,oper_BoolVar,oper_ReserveIdVar]>;
  def inst_OpGetNumPipePackets : InstPipeGet<283>;
  def inst_OpGetMaxPipePackets : InstPipeGet<284>;
  def inst_OpGroupReserveReadPipePackets  : InstPipeGroupReserve<285>;
  def inst_OpGroupReserveWritePipePackets : InstPipeGroupReserve<286>;
  def inst_OpGroupCommitReadPipe  : InstPipeGroupCommit<287>;
  def inst_OpGroupCommitWritePipe : InstPipeGroupCommit<288>;
  def inst_OpConstantPipeStorage : SPIRVInstruction<4,323,2,[oper_PipeStorageType,oper_PipeStorageVar,
                                                             oper_ImmInt32,oper_ImmInt32,oper_ImmInt32]>;
  def inst_OpCreatePipeFromPipeStorage : SPIRVInstruction<4,324,2,[oper_PipeType,oper_PipeVar,
                                                                   oper_PipeStorageVar]>;
}

