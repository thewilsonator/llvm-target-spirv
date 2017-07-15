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
  Passes/OCL20To12.cpp
  Passes/OCL20ToSPIRV.cpp
  Passes/OCL21ToSPIRV.cpp
  Passes/OCLTypeToSPIRV.cpp
  Passes/SPIRVLowerBool.cpp
  Passes/SPIRVLowerConstExpr.cpp
  Passes/SPIRVLowerOCLBlocks.cpp
  Passes/SPIRVRegularizeLLVM.cpp
  Passes/SPIRVToOCL20.cpp
  Passes/TransOCLMD.cpp
  OCLUtil.cpp
  SPIRVReader.cpp
  SPIRVTargetMachine.cpp
  SPIRVWriter.cpp
  SPIRVWriterPass.cpp

  )

#add_dependencies(Spirv intrinsics_gen)
