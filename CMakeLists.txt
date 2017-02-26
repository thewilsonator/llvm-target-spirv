set(LLVM_TARGET_DEFINITIONS SPIRV.td)
add_subdirectory(libSPIRV)
add_subdirectory(Mangler)
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)

#option(SPIRV_USE_LLVM_API "Enable usage of LLVM API for libSPIRV." ON)
#if ( SPIRV_USE_LLVM_API )
  add_definitions(-D_SPIRV_LLVM_API)
#endif()

add_llvm_target(SPIRVCodeGen
#  libSPIRV/SPIRVBasicBlock.cpp
#  libSPIRV/SPIRVDebug.cpp
#  libSPIRV/SPIRVDecorate.cpp
#  libSPIRV/SPIRVEntry.cpp
#  libSPIRV/SPIRVFunction.cpp
#  libSPIRV/SPIRVInstruction.cpp
#  libSPIRV/SPIRVModule.cpp
#  libSPIRV/SPIRVStream.cpp
#  libSPIRV/SPIRVType.cpp
#  libSPIRV/SPIRVValue.cpp
#  Mangler/FunctionDescriptor.cpp
#  Mangler/Mangler.cpp
#  Mangler/ManglingUtils.cpp
#  Mangler/ParameterType.cpp
  OCL20To12.cpp
  OCL20ToSPIRV.cpp
  OCL21ToSPIRV.cpp
  OCLTypeToSPIRV.cpp
  OCLUtil.cpp
  SPIRVLowerBool.cpp
  SPIRVLowerConstExpr.cpp
  SPIRVLowerOCLBlocks.cpp
  SPIRVReader.cpp
  SPIRVRegularizeLLVM.cpp
  SPIRVTargetMachine.cpp
  SPIRVToOCL20.cpp
  SPIRVUtil.cpp
  SPIRVWriter.cpp
  SPIRVWriterPass.cpp
  TransOCLMD.cpp
  )

#add_dependencies(Spirv intrinsics_gen)
