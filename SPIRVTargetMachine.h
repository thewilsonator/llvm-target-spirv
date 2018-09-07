//===-- SPIRVTargetMachine.h - Define TargetMachine for SPIRV ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the SPIRV specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_SPIRV_SPIRVTARGETMACHINE_H
#define LLVM_LIB_TARGET_SPIRV_SPIRVTARGETMACHINE_H

#include "SPIRVInternal.h"
#include "llvm/Target/TargetMachine.h"
enum SPIRVTargetMachineType
  {
    STMT_OCL32,
    STMT_OCL64,
    STMT_VK
  };

namespace llvm {

class SPIRVTargetMachine : public LLVMTargetMachine {
  int version; //e.g. 120 for OpenCL 1.2,450 for GLSL450
  SPIRVTargetMachineType stmt;
  // TODO: capabilities
public:
  SPIRVTargetMachine(const Target &T, StringRef DL, const Triple &TT,
                     StringRef CPU, StringRef FS, const TargetOptions &Options,
                     SPIRVTargetMachineType stmt, Reloc::Model RM,
                     CodeModel::Model CM, CodeGenOpt::Level OL, bool Jit);
  ~SPIRVTargetMachine() override;

  virtual bool addPassesToEmitFile(PassManagerBase &PM, raw_pwrite_stream &Out,
                                   raw_pwrite_stream *DwoOut, CodeGenFileType FileType,
                           bool DisableVerify = true, MachineModuleInfo* MMI = nullptr) override;
};

class SPIRV32TargetMachine : public SPIRVTargetMachine {

public:
    SPIRV32TargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                         StringRef FS, const TargetOptions &Options, Optional<Reloc::Model> RM,
                         Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit);
};

/// SPIRV 64-bit target machine
///
class SPIRV64TargetMachine : public SPIRVTargetMachine {

public:
    SPIRV64TargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                         StringRef FS, const TargetOptions &Options, Optional<Reloc::Model> RM,
                         Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit);
};

class SPIRVLTargetMachine : public SPIRVTargetMachine {

    
public:
    SPIRVLTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                        StringRef FS, const TargetOptions &Options, Optional<Reloc::Model> RM,
                        Optional<CodeModel::Model> CM, CodeGenOpt::Level OL, bool Jit);
};

    
    
} // end namespace llvm

#endif
