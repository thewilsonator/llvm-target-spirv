//===-- SPIRCTargetMachine.cpp - Define TargetMachine for SPIRV -----------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "SPIRVTargetMachine.h"
#include "SPIRVWriterPass.h"

#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

/// Create an ILP32 architecture model
SPIRVTargetMachine::SPIRVTargetMachine(const Target &T, StringRef _DL,
                                       const Triple &TT,
                                       StringRef CPU, StringRef FS,
                                       const TargetOptions &Options,
                                       SPIRVTargetMachineType stmt,
                                       Reloc::Model RM,
                                       CodeModel::Model CM, CodeGenOpt::Level OL,
                                       bool Jit)
    : LLVMTargetMachine(T, _DL, TT, CPU, FS, Options,RM,CM,OL), stmt(stmt) {
}

SPIRVTargetMachine::~SPIRVTargetMachine() {}

bool SPIRVTargetMachine::addPassesToEmitFile(PassManagerBase &PM, raw_pwrite_stream &Out,
                                             raw_pwrite_stream *DwoOut, CodeGenFileType FileType,
                         bool DisableVerify, MachineModuleInfo* MMI)
{
    PM.add(createSPIRVWriterPass(Out));
    return false;
    
}

SPIRV32TargetMachine::SPIRV32TargetMachine(const Target &T, const Triple &TT,
                         StringRef CPU, StringRef FS,
                         const TargetOptions &_Options, Optional<Reloc::Model> RM,
                         Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit)
    : SPIRVTargetMachine(T,SPIR_DATALAYOUT32,TT,CPU,FS,_Options,STMT_OCL32,
                         Reloc::Static,
                         CM ? *CM : CodeModel::Medium,
                         OL,false) {}


SPIRV64TargetMachine::SPIRV64TargetMachine(const Target &T, const Triple &TT,
                         StringRef CPU, StringRef FS,
                        const TargetOptions &_Options,Optional<Reloc::Model> RM,
                        Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit)
    : SPIRVTargetMachine(T,SPIR_DATALAYOUT64,TT,CPU,FS,_Options,STMT_OCL64,
                         Reloc::Static,
                         CM ? *CM : CodeModel::Medium,
                         OL, false) {}
    


SPIRVLTargetMachine::SPIRVLTargetMachine(const Target &T, const Triple &TT,
                         StringRef CPU, StringRef FS,
                        const TargetOptions &_Options,Optional<Reloc::Model> RM,
                        Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit)
    // TODO: data layout
: SPIRVTargetMachine(T,"",TT,CPU,FS,_Options,STMT_VK,Reloc::Static,
                     CM ? *CM : CodeModel::Medium,
                     OL, false) {}


namespace llvm {
    Target &getTheSPIRV32Target();
    Target &getTheSPIRV64Target();
    //Target &getTheSPIRVLTarget();
}
extern "C" void LLVMInitializeSPIRVTarget() {
    // Register the target.
    RegisterTargetMachine<SPIRV32TargetMachine> X(getTheSPIRV32Target());
    RegisterTargetMachine<SPIRV64TargetMachine> Y(getTheSPIRV64Target());
    //RegisterTargetMachine<SPIRVLTargetMachine>  Z(getTheSPIRVLTarget());
}
