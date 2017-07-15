//===-- InstructionsOCL.td - SPIRV Core Instructions -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// File contains prototypes for extensions instructions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Float prototypes
//===----------------------------------------------------------------------===//
// float_t(float_t)
class ExtInstFPUnary<bits<32> op>   : SPIRVInstruction<6,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                               oper_InstructionSet,oper_ImmInt32, // the opcode
                                                               oper_FloatVecScalVar]>
{ let Op2 = op; };

// float_t(float_t,float_t)
class ExtInstFPBinary<bits<32> op>  : SPIRVInstruction<7,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                               oper_InstructionSet,oper_ImmInt32,
                                                               oper_FloatVecScalVar,oper_FloatVecScalVar]>
{ let Op2 = op; };
// float_t(float_t,float_t,float_t)
class ExtInstFPTrinary<bits<32> op> : SPIRVInstruction<8,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                               oper_InstructionSet,oper_ImmInt32,
                                                               oper_FloatVecScalVar,oper_FloatVecScalVar,
                                                               oper_FloatVecScalVar]>
{ let Op2 = op; };

// FIXME: Should be oper_FloatVecScalVarPointer / oper_Int32VecScalVarPointer
// See fract / frexp in InstructionOCL.td
// float_t(float_t,any*)
class ExtInstFP2ArgReturn<bits<32> op> : SPIRVInstruction<7,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                                  oper_InstructionSet,oper_ImmInt32,
                                                                  oper_FloatVecScalVar,oper_AnyPointerVar]>
{ let Op2 = op; };

// i32_t(float_t)
class ExtInstFPtoI32<bits<32> op> : SPIRVInstruction<6,12,2,[oper_Int32VecScalType,oper_Int32VecScalVar,
                                                                  oper_InstructionSet,oper_ImmInt32,
                                                                  oper_FloatVecScalVar]>
{ let Op2 = op; };

// float_t(float_t,i32_t)
class ExtInstFPArgFPInt32<bits<32> op>  : SPIRVInstruction<7,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                                   oper_InstructionSet,oper_ImmInt32,
                                                                   oper_FloatVecScalVar,oper_Int32VecScalVar]>
{ let Op2 = op; };

// float_t(i32_t)
class ExtInstI32toFP<bits<32> op> : SPIRVInstruction<6,12,2,[oper_FloatVecScalType,oper_FloatVecScalVar,
                                                             oper_InstructionSet,oper_ImmInt32,
                                                             oper_Int32VecScalVar]>
{ let Op2 = op; };

// float_t(float_t,float_t,any*)
class ExtInstFP2BinaryArgReturn<bits<32> op> : SPIRVInstruction<8,12,2,
                                                        [oper_FloatVecScalType,oper_FloatVecScalVar,
                                                         oper_InstructionSet,oper_ImmInt32,
                                                         oper_FloatVecScalVar,oper_AnyPointerVar]>
{ let Op2 = op; };

//===----------------------------------------------------------------------===//
// Integer prototypes
//===----------------------------------------------------------------------===//

//int_t(int_t)
class ExtInstIntUnary<bits<32> op> : SPIRVInstruction<6,12,2, [oper_IntVecScalType,oper_IntVecScalVar,
                                                               oper_InstructionSet,oper_ImmInt32,
                                                               oper_IntVecScalVar]>
{ let Op2 = op; };

//int_t(int_t,int_t)
class ExtInstIntBinary<bits<32> op> : SPIRVInstruction<7,12,2, [oper_IntVecScalType,oper_IntVecScalVar,
                                                                oper_InstructionSet,oper_ImmInt32,
                                                                oper_IntVecScalVar,oper_IntVecScalVar]>
{ let Op2 = op; };

//int_t(int_t,int_t,int_t)
class ExtInstIntTrinary<bits<32> op> : SPIRVInstruction<8,12,2, [oper_IntVecScalType,oper_IntVecScalVar,
                                                                 oper_InstructionSet,oper_ImmInt32,
                                                                 oper_IntVecScalVar,oper_IntVecScalVar,
                                                                 oper_IntVecScalVar]>
{ let Op2 = op; };

//any_t(any_t,any_t,any_t)
class ExtInstAnyTrinary<bits<32> op> : SPIRVInstruction<8,12,2, [oper_AnyVecScalType,oper_AnyVecScalVar,
                                                                 oper_InstructionSet,oper_ImmInt32,
                                                                 oper_AnyVecScalVar,oper_AnyVecScalVar,
                                                                 oper_AnyVecScalVar]>
{ let Op2 = op; };



