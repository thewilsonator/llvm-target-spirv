add_definitions(-D_SPIRV_LLVM_API)
add_llvm_library(LLVMSPIRVMangler
 FunctionDescriptor.cpp
 Mangler.cpp
 ManglingUtils.cpp
 ParameterType.cpp
 )
