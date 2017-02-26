//===-- SPIRVTargetInfo.cpp - SPIRV Target Implementation -----------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

namespace llvm {
Target &getTheSPIRV32Target() {
  static Target TheSPIRV32Target;
  return TheSPIRV32Target;
}

Target &getTheSPIRV64Target() {
  static Target TheSPIRV64Target;
  return TheSPIRV64Target;
}

Target &getTheSPIRVLTarget() {
    static Target TheSPIRVLTarget;
    return TheSPIRVLTarget;
}
}

extern "C" void LLVMInitializeSPIRVTargetInfo() {
  RegisterTarget<Triple::spir> X(getTheSPIRV32Target(), "spirv32",
                                    "32-bit SPIR-V");
  RegisterTarget<Triple::spir64> Y(getTheSPIRV64Target(), "spirv64",
                                    "64-bit SPIR-V");
  RegisterTarget<Triple::spirl> Z(getTheSPIRVLTarget(), "spirvlogical",
                                     "SPIR-V Logical");
}
