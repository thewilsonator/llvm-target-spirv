//===-- Enums.td - SPIRV Enums -----------------------------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// File contains section 3.2-3.31 of the SPIRV Spec
//===----------------------------------------------------------------------===//
class SPIRVEnum {
  bits<32> Op = op;
  int Section; // == section from the spec 3.# 1-31, nonsemantic variable
  list<Operand> FollowedLiterals = [];
  bit isMask = 0;
}

// Capabilities
// Keep this in sync with IR/IntrinsicsSPIRV.td
// From the spec section 3.31
class Capability< int opNum, int dependsOn> : SPIRVEnum {
  let Op = opNum;
  let Section = 31;
  int DependsOn = dependsOn; // transitive dependency, -1 for no dependcy
}

def cap_Matrix          : Capability<0,-1>;
def cap_Shader          : Capability<1,0>;
def cap_Geometry        : Capability<2,1>;
def cap_Tessellation    : Capability<3,1>;
def cap_Addresses       : Capability<4,-1>;
def cap_Linkage         : Capability<5,-1>;
def cap_Kernel          : Capability<6,-1>;
def cap_Vector16        : Capability<7,6>;
def cap_Float16Buffer   : Capability<8,6>;
def cap_cap_Float16     : Capability<9,-1>;
def cap_Float64         : Capability<10,-1>;
def cap_Int64           : Capability<11,-1>;
def cap_Int64Atomics    : Capability<12,11>;
def cap_ImageBasic      : Capability<13,6>;
def cap_ImageReadWrite  : Capability<14,12>;
def cap_ImageMipmap     : Capability<15,12>;
// There is no capability #16
def cap_Pipes           : Capability<17,6>;
def cap_Groups          : Capability<18,-1>;
def cap_DeviceEnqueue   : Capability<19,6>;
def cap_LiteralSampler  : Capability<20,6>;
def cap_AtomicStorage   : Capability<21,1>;
def cap_Int16           : Capability<22,-1>;
def cap_TessellationPointSize   : Capability<23,3>;
def cap_GeometryPointSize       : Capability<24,2>;
def cap_ImageGatherExtended     : Capability<25,1>;
// There is no capability #26
def cap_StorageImageMultisample : Capability<27,1>;
def cap_UniformBufferArrayDynamicIndexingBlock          : Capability<28,1>;
def cap_SampledImageArrayDynamicIndexing                : Capability<29,1>;
def cap_StorageBufferArrayDynamicIndexingBufferBlock    : Capability<30,1>;
def cap_StorageImageArrayDynamicIndexing                : Capability<31,1>;
def cap_ClipDistance        : Capability<32,1>;
def cap_CullDistance        : Capability<33,1>;
def cap_ImageCubeArray      : Capability<34,45>;
def cap_SampleRateShading   : Capability<35,1>;
def cap_ImageRect           : Capability<36,37>;
def cap_SampledRect         : Capability<37,1>;
def cap_GenericPointer      : Capability<38,4>;
def cap_Int8                : Capability<39,6>;
def cap_InputAttachment     : Capability<40,1>;
def cap_SparseResidency     : Capability<41,1>;
def cap_MinLod              : Capability<42,1>;
def cap_Sampled1D           : Capability<43,-1>;
def cap_Image1D             : Capability<44,43>;
def cap_SampledCubeArray    : Capability<45,1>;
def cap_SampledBuffer       : Capability<46,-1>;
def cap_ImageBuffer         : Capability<47,46>;
def cap_ImageMSArray        : Capability<48,1>;
def cap_StorageImageExtendedFormats : Capability<49,1>;
def cap_ImageQuery                  : Capability<50,1>;
def cap_DerivativeControl           : Capability<51,1>;
def cap_InterpolationFunction       : Capability<52,1>;
def cap_TransformFeedback           : Capability<53,1>;
def cap_GeometryStreams             : Capability<54,2>;
def cap_StorageImageReadWithoutFormat   : Capability<55,1>;
def cap_StorageImageWriteWithoutFormat  : Capability<56,1>;
def cap_MultiViewport       : Capability<57,2>;
def cap_SubgroupDispatch    : Capability<58,19>;
def cap_NamedBarrier        : Capability<59,6>;
def cap_PipeStorage         : Capability<60,17>;

// Name of the form "<source language name>.<package name>.<version>" (spec 2.10)
// the "opcode" is actually the name
class InstructionSet<string name>  : StringOperand {
   string Val = name;
  bit isExt = 0;
};

def iset_OpenCL  : InstructionSet<"OpenCL.std.100">;
def iset_GLSL450 : InstructionSet<"GLSL.std.450";

include "OpenCl.td"

class ExecutionModel<int op,Capability cap> : SPIRVEnum  {
  let Op = op;
  Capability Cap = cap;
}
//=============================
// Spec section 3 Binary form
//=============================

// Section 3.1 Magic Number - use to determine endianness for i8 stream -> i32 stream
// conversion
class MagicNumber<int num> {
  int Magic = num;
}
def mn_Magic : MagicNumber<0x07230203>;

//Section 3.2 - Source Language - no semantic meaning
class SourceLanguage<int op> : SPIRVEnum {
  let Op = op;
  let Section = 2;
}

def sl_Unknown      : SourceLanguage<0>;
def sl_ESSL         : SourceLanguage<1>;
def sl_GLSL         : SourceLanguage<2>;
def sl_OpenCL_C     : SourceLanguage<3>;
def sl_OpenCL_CPP   : SourceLanguage<4>;

//Section 3.3 - ExecutionModel
class ExecutionModel<int op,Capability cap> : SPIRVEnum {
  let Op = op;
  let Section = 3;
  Capability Cap = cap;
}
def exmdl_Vertex                   : ExecutionModel<0,cap_Shader>;
def exmdl_TessellationControl      : ExecutionModel<1,cap_Tessellation>;
def exmdl_TessellationEvaluation   : ExecutionModel<2,cap_Tessellation>;
def exmdl_Geometry                 : ExecutionModel<3,cap_Geometry>;
def exmdl_Fragment                 : ExecutionModel<4,cap_Shader>;
def exmdl_GLCompute                : ExecutionModel<5,cap_Shader>;
def exmdl_Kernel                   : ExecutionModel<6,cap_Kernel>;

// Section 3.4 Addressing Model

class AddressModel<int op, list<Capability> cap>  : SPIRVEnum {
  let Op = op;
  let Section = 4;
  list<Capability> Cap = cap;
}

def addrmdl_Logical     : AddressModel<0,[]>;
def addrmdl_Physical32  : AddressModel<1,[cap_Addresses]>;
def addrmdl_Physical64  : AddressModel<2,[cap_Addresses]>;

// Section 3.5
class MemoryModel<int op, Capability cap> : SPIRVEnum {
  let Op = op;
  let Section = 5;
  Capability Cap = cap;
}

def memmdl_Simple  : MemoryModel<0,cap_Shader>;
def memmdl_GLSL450 : MemoryModel<1,cap_Shader>;
def memmdl_OpenCL  : MemoryModel<2,cap_Kernel>;

// Spec 3.6 Execution Mode
// - Note that only one required capabilities, need be satisfied.
// - Note that only one required models, need be satisfied.
// - Note also that mdls can be empty signifying no explicily required model (Xfb).
class ExecutionMode<int op,list<Capability> cap,list<ExecutionModel> mdls,
                                list<Operand> followedBy = []> : SPIRVEnum {
  let Op = op;
  let FollowedLiterals = followedBy;
  let Section = 5;
  list<Capability> Cap = cap;
  list<ExecutionModel> Models = mdls;
}
// Coment is purpose of extra literal (if any)
def exmode_Invocations           :  ExecutionModel<0,[cap_Geometry],[exmdl_Geometry],[IntOperand]>; //#Invocations
def exmode_SpacingEqual          :  ExecutionModel<1,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_SpacingFractionalEven :  ExecutionModel<2,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_SpacingFractionalOdd  :  ExecutionModel<3,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_VertexOrderCw         :  ExecutionModel<4,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_VertexOrderCcw        :  ExecutionModel<5,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_PixelCenterInteger    :  ExecutionModel<6,[cap_Shader], [exmdl_Fragment]>;
def exmode_OriginUpperLeft       :  ExecutionModel<7,[cap_Shader], [exmdl_Fragment]>;
def exmode_OriginLowerLeft       :  ExecutionModel<8,[cap_Shader], [exmdl_Fragment]>;
def exmode_EarlyFragmentTests    :  ExecutionModel<9,[cap_Shader], [exmdl_Fragment]>;
def exmode_PointMode             :  ExecutionModel<10,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_Xfb                   :  ExecutionModel<11,[cap_TransformFeedback],[]>;
def exmode_DepthReplacing        :  ExecutionModel<12,[cap_Shader], [exmdl_Fragment]>;
// There is no #13
def exmode_DepthGreater          :  ExecutionModel<14,[cap_Shader], [exmdl_Fragment]>;
def exmode_DepthLess             :  ExecutionModel<15,[cap_Shader], [exmdl_Fragment]>;
def exmode_DepthUnchanged        :  ExecutionModel<16,[cap_Shader], [exmdl_Fragment]>;
def exmode_LocalSize             :  ExecutionModel<17,[cap_Kernel], [exmdl_Kernel],
                                                [IntOperand,IntOperand,IntOperand]>; // x,y,z as size
def exmode_LocalSizeHint         :  ExecutionModel<18,[cap_Kernel], [exmdl_Kernel],
                                                [IntOperand,IntOperand,IntOperand]>; // x,y,z as size
def exmode_InputPoints           :  ExecutionModel<19,[cap_Geometry],[exmdl_Geometry]>;
def exmode_InputLines            :  ExecutionModel<20,[cap_Geometry],[exmdl_Geometry]>;
def exmode_InputLinesAdjacency   :  ExecutionModel<21,[cap_Geometry],[exmdl_Geometry]>;
def exmode_Triangles             :  ExecutionModel<22,[cap_Geometry,cap_Tessellation]
                        [exmdl_Geometry,exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_InputTrianglesAdjacency :  ExecutionModel<23,[cap_Geometry],[exmdl_Geometry]>;
def exmode_Quads                 :  ExecutionModel<24,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_Isolines              :  ExecutionModel<25,[cap_Tessellation],
                                    [exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_OutputVertices        :  ExecutionModel<26,[cap_Geometry,cap_Tessellation],
                        [exmdl_Geometry,exmdl_TessellationControl,exmdl_TessellationEvaluation]>;
def exmode_OutputPoints          :  ExecutionModel<27,[cap_Geometry],[exmdl_Geometry]>;
def exmode_OutputLineStrip       :  ExecutionModel<28,[cap_Geometry],[exmdl_Geometry]>;
def exmode_OutputTriangleStrip   :  ExecutionModel<29,[cap_Geometry],[exmdl_Geometry]>;
def exmode_VecTypeHint           :  ExecutionModel<30,[cap_Kernel],[exmdl_Kernel],1>;
                                    // high 16 = vecwidth, lo = type, see spec for details

def exmode_ContractionOff        :  ExecutionModel<31,[cap_Kernel],[exmdl_Kernel]>;
// There is no #32
def exmode_Initializer           :  ExecutionModel<33,[cap_Kernel],[exmdl_Kernel]>;
def exmode_Finalizer             :  ExecutionModel<34,[cap_Kernel],[exmdl_Kernel]>;
def exmode_SubgroupSize          :  ExecutionModel<35,[cap_SubgroupDispatch],[exmdl_Kernel]>;
def exmode_SubgroupsPerWorkgroup :  ExecutionModel<36,[cap_SubgroupDispatch],[exmdl_Kernel]>;

// Section 3.7 - Storage Class - Analogous to addrspace's
// The GL number are madeup for the moment.
class StorageClass<int op, list<Capability> cap, int cl_addrspace,
                                int gl_addrspace> : SPIRVEnum  {
  let Op = op;
  let Section = 7;
  list<Capability> Cap = cap;
  int CLaddrspace = cl_addrspace; // -1 if N/A
  int GLaddrspace = gl_addrspace;
}

def stc_UniformConstant : StorageClass<0,[]          ,3,3>;  // OpenCL __constant, GLSL ?
def stc_Input           : StorageClass<1,[]          ,-1,7>; // output of prev graphics stage.
                                                             //r/o noinit like above.
def stc_Uniform         : StorageClass<2,[cap_Shader],-1,5>; // Graphics uniform blocks and buffer blocks.
def stc_Output          : StorageClass<3,[cap_Shader],-1,8>; // output of graphics stage
def stc_Workgroup       : StorageClass<4,[]          ,2,2>;  // OpenCL __local (stack), GLSL stack
def stc_CrossWorkgroup  : StorageClass<5,[cap_Shader],1,1>;  // OpenCL __global
def stc_Private         : StorageClass<6,[cap_Shader],-1,6>; // Shader gloabl memory?
def stc_Function        : StorageClass<6,[],0,0>;            // OpenCL __private?
def stc_Generic         : StorageClass<6,[cap_GenericPointer],-1,6>;
def stc_PushConstant    : StorageClass<6,[cap_Shader],-1,6>;
def stc_AtomicCounter   : StorageClass<6,[cap_Shader],-1,6>;
def stc_Image           : StorageClass<6,[cap_Shader],1,6>; // OpenCL __global ?

// Section 3.8 - Dim - Dimensionality of an image
class Dim<int op, list<Capability> cap>  : SPIRVEnum {
  let Op = op;
  let Section = 8;
  list<Capability> Cap = cap;
}

def dim_d1D         : Dim<0,[cap_Sampled1D]>;
def dim_d2D         : Dim<1,[]>;
def dim_d3D         : Dim<2,[]>;
def dim_Cube        : Dim<3,[cap_Shader]>;
def dim_Rect        : Dim<4,[cap_SampledRect]>;
def dim_Buffer      : Dim<5,[cap_SampledBuffer]>;
def dim_SubpassData : Dim<6,[cap_InputAttachment]>;

//Section 3.9 - Sampler Addressing Mode
// - Addressing mode for creating constant samplers
class SamplerAddressingMode<int op> {
let Op = op;
let Section = 9;
Capability Cap = cap_Kernel;
}

def sam_None            : SamplerAddressingMode<0>;
def sam_ClampEdge       : SamplerAddressingMode<1>;
def sam_Clamp           : SamplerAddressingMode<2>;
def sam_Repeat          : SamplerAddressingMode<3>;
def sam_RepeatMirrored  : SamplerAddressingMode<4>;

// Section 3.10 Sampler Filter Mode
// - Filter mode for creating constant samplers.
class SamplerFilterMode<int op> {
let Op = op;
let Section = 10;
Capability Cap = cap_Kernel;
}

def sfm_Nearest : SamplerFilterMode<0>;
def sfm_Linear  : SamplerFilterMode<1>;

// Section 3.11 Image Format

class ImageFormat<int op, list<Capability> cap = [cap_StorageImageExtendedFormats]> {
let Op = op;
let Section = 11;
list<Capability> Cap = cap;
}

def if_Unknown : ImageFormat<0,[]>;
def if_Rgba32f : ImageFormat<1,[cap_Shader]>;
def if_Rgba16f : ImageFormat<2,[cap_Shader]>;
def if_R32f : ImageFormat<3,[cap_Shader]>;
def if_Rgba8 : ImageFormat<4,[cap_Shader]>;
def if_Rgba8Snorm : ImageFormat<5,[cap_Shader]>;
def if_Rg32f : ImageFormat<6>;
def if_Rg16f : ImageFormat<7>;
def if_R11fG11fB10f : ImageFormat<8>;
def if_R16f : ImageFormat<9>;
def if_Rgba16 : ImageFormat<10>;
def if_Rgb10A2 : ImageFormat<11>;
def if_Rg16 : ImageFormat<12>;
def if_Rg8 : ImageFormat<13>;
def if_R16 : ImageFormat<14>;
def if_R8 : ImageFormat<15>;
def if_Rgba16Snorm : ImageFormat<16>;
def if_Rg16Snorm : ImageFormat<17>;
def if_Rg8Snorm : ImageFormat<18>;
def if_R16Snorm : ImageFormat<19>;
def if_R8Snorm : ImageFormat<20>;
def if_Rgba32i : ImageFormat<21,[cap_Shader]>;
def if_Rgba16i : ImageFormat<22,[cap_Shader]>;
def if_Rgba16i : ImageFormat<23,[cap_Shader]>;
def if_R32i : ImageFormat<24,[cap_Shader]>;
def if_Rg32i : ImageFormat<25>;
def if_Rg16i : ImageFormat<26>;
def if_Rg8i : ImageFormat<27>;
def if_R16i : ImageFormat<28>;
def if_R8i : ImageFormat<29>;
def if_Rgba32ui : ImageFormat<30,[cap_Shader]>;
def if_Rgba16ui : ImageFormat<31,[cap_Shader]>;
def if_Rgba8ui : ImageFormat<32,[cap_Shader]>;
def if_R32ui : ImageFormat<33,[cap_Shader]>;
def if_Rgb10a2ui : ImageFormat<34,[cap_Shader]>;
def if_Rg32ui : ImageFormat<35>;
def if_Rg16ui : ImageFormat<36>;
def if_Rg8ui : ImageFormat<37>;
def if_R16ui : ImageFormat<38>;
def if_R8ui : ImageFormat<39>;


// Sections 3.12 and 3.13 are Kernel only and therefore in OpenCL.td
// Section 3.12 Image Channel Order
class ImageChannelOrder<int op> {
let Op = op;
let Section = 12;
Capability Cap = cap_Kernel;
}

def ico_R : ImageChannelOrder<0>;
def ico_A : ImageChannelOrder<1>;
def ico_RG : ImageChannelOrder<2>;
def ico_RA : ImageChannelOrder<3>;
def ico_RGB : ImageChannelOrder<4>;
def ico_RGBA : ImageChannelOrder<5>;
def ico_BGRA : ImageChannelOrder<6>;
def ico_ARGB : ImageChannelOrder<7>;
def ico_Intensity : ImageChannelOrder<8>;
def ico_Luminance : ImageChannelOrder<9>;
def ico_Rx : ImageChannelOrder<10>;
def ico_RGx : ImageChannelOrder<11>;
def ico_RGBx : ImageChannelOrder<12>;
def ico_Depth : ImageChannelOrder<13>;
def ico_DepthStencil : ImageChannelOrder<14>;
def ico_sRGB : ImageChannelOrder<15>;
def ico_sRGBx : ImageChannelOrder<16>;
def ico_sRGBx : ImageChannelOrder<17>;
def ico_sBGRA : ImageChannelOrder<18>;
def ico_ABGR : ImageChannelOrder<19>;

// Section 3.13 Image Channel Data Type
class ImageChannelDataType<int op> {
let Op = op;
let Section = 13;
Capability Cap = cap_Kernel;
}

def icdt_SnormInt8      : ImageChannelDataType<0>;
def icdt_SnormInt16     : ImageChannelDataType<1>;
def icdt_UnormInt8      : ImageChannelDataType<2>;
def icdt_UnormInt16     : ImageChannelDataType<3>;
def icdt_UnormShort565  : ImageChannelDataType<4>;
def icdt_UnormShort555  : ImageChannelDataType<5>;
def icdt_UnormInt101010 : ImageChannelDataType<6>;
def icdt_SignedInt8     : ImageChannelDataType<7>;
def icdt_SignedInt16    : ImageChannelDataType<8>;
def icdt_SignedInt32    : ImageChannelDataType<9>;
def icdt_UnsignedInt8   : ImageChannelDataType<10>;
def icdt_UnsignedInt16  : ImageChannelDataType<11>;
def icdt_UnsignedInt32  : ImageChannelDataType<12>;
def icdt_HalfFloat      : ImageChannelDataType<13>;
def icdt_Float          : ImageChannelDataType<14>;
def icdt_UnormInt24     : ImageChannelDataType<15>;
def icdt_UnormInt101010_2 : ImageChannelDataType<16>;

// Section 3.14 Image Operands

class ImageOperand<int op, list<Dim> dim = [], list<Capability> cap = []> : SPIRVEnum {
  let Op = op;
  let Section = 14;
  let isMask = 1;
  list<Dim> nDim = dim;
  list<Capability> Cap = cap;
}

def io_None : ImageOperand<0,[]>;
def io_Bias : ImageOperand<1,[dim_d1D,dim_d2D,dim_d3D,dim_Cube],[cap_Shader]>;
def io_Lod  : ImageOperand<2,[dim_d1D,dim_d2D,dim_d3D,dim_Cube]>;
def io_Grad : ImageOperand<4>;
def io_ConstOffset : ImageOperand<8>;
def io_Offset : ImageOperand<16,[],[cap_ImageGatherExtended]>;
def io_ConstOffsets : ImageOperand<32>;
def io_Sample : ImageOperand<64,[dim_d1D,dim_d2D,dim_d3D,dim_Cube]>;
def io_MinLod : ImageOperand<128,[dim_d1D,dim_d2D,dim_d3D,dim_Cube],[cap_MinLod]>;


// Section 3.15 FP Fast Math Mode - Maskable
class FPFastMathMode<int op> {
let Op = op;
let Section = 15;
Capability Cap = cap_Kernel;
let isMask = 1;
}

def fmm_None : FPFastMathMode<0>;
def fmm_NotNaN : FPFastMathMode<2>;
def fmm_NotInf : FPFastMathMode<4>;
def fmm_NoSignedZero : FPFastMathMode<8>;
def fmm_ReciprocalMul : FPFastMathMode<16>;
def fmm_Fast : FPFastMathMode<0>; // implies the rest of the above


// Section 3.16 FP Rounding Mode

class RoundingMode<int op> {
let Op = op;
let Section = 16;
Capability Cap = cap_Kernel;
}

def rm_Even        : RoundingMode<0>;
def rm_Odd         : RoundingMode<1>;
def rm_PositiveInf : RoundingMode<2>;
def rm_NegativeInf : RoundingMode<3>;

// Section 3.17 Linkage Type

class LinkageType<int op, Capability cap = cap_Linkage> {
  let Op = op;
  let Section = 17;
  Capability Cap = cap;
}

def lt_Export : LinkageType<0>;
def lt_Import : LinkageType<1>;

// Section 3.18 Access Qualifier

class AccessQualifier<int op> {
let Op = op;
let Section = 18;
Capability Cap = cap_Kernel;
}

def aq_Read : AccessQualifier<0>;
def aq_Write : AccessQualifier<1>;
def aq_ReadWrite : AccessQualifier<2>;

// Section 3.19 Function Parameter Attribute

class FunctionParameteAttribute<int op> {
let Op = op;
let Section = 19;
Capability Cap = cap_Kernel;
}

def fpa_Zext        : FunctionParameteAttribute<0>;
def fpa_Sext        : FunctionParameteAttribute<1>;
def fpa_ByVal       : FunctionParameteAttribute<2>;
def fpa_Sret        : FunctionParameteAttribute<3>;
def fpa_NoAlias     : FunctionParameteAttribute<4>;
def fpa_NoCapture   : FunctionParameteAttribute<5>;
def fpa_NoWrite     : FunctionParameteAttribute<6>;
def fpa_NoReadWrite : FunctionParameteAttribute<7>;

// Section 3.20 Decoration

class Decoration<int op, list<Capability> cap, list<Operands> followedBy= []> :  SPIRVEnum {
  let Op = op;
  let Section = 20;
  list<Capability> Cap = cap;
  let FollowedLiterals = followedBy;
}

def deco_RelaxedPrecision : Decoration<0,[cap_Shader]>;
def deco_SpecId : Decoration<1,[cap_Shader, cap_Kernel],[IntOperand]>; // IdOperand?
def deco_Block : Decoration<2,[cap_Shader]>;
def deco_BufferBlock : Decoration<3,[cap_Shader]>;
def deco_RowMajor : Decoration<4,[cap_Matrix]>;
def deco_ColMajor : Decoration<5,[cap_Matrix]>;
def deco_ArrayStride : Decoration<6,[cap_Shader],[IntOperand]>;
def deco_MatrixStride : Decoration<7,[cap_Matrix],[IntOperand]>;
def deco_GLSLShared : Decoration<8,[cap_Shader]>;
def deco_GLSLPacked : Decoration<9,[cap_Shader]>;
def deco_CPacked : Decoration<10,[cap_Kernel]>;
def deco_BuiltIn : Decoration<11,[],[Builtin]>;
// There is no #12
def deco_NoPerspective : Decoration<13,[cap_Shader]>;
def deco_Flat : Decoration<14,[cap_Shader]>;
def deco_Patch : Decoration<15,[cap_Tessellation]>;
def deco_Centroid : Decoration<16,[cap_Shader]>;
def deco_Sample : Decoration<17,[cap_SampleRateShading]>;
def deco_Invariant : Decoration<18,[cap_Shader]>;
def deco_Restrict : Decoration<19,[cap_Shader]>;
def deco_Aliased : Decoration<20,[]>;
def deco_Volatile : Decoration<21,[]>;
def deco_Constant : Decoration<21,[cap_Kernel]>;
def deco_Coherent : Decoration<23,[]>;
def deco_NonWritable : Decoration<24,[]>;
def deco_NonReadable : Decoration<25,[]>;
def deco_Uniform : Decoration<26,[cap_Shader]>;
// There is no #27
def deco_SaturatedConversion : Decoration<28,[cap_Shader]>;
def deco_Stream : Decoration<29,[cap_Shader],[IntOperand]>;
def deco_Location : Decoration<30,[cap_Shader],[IntOperand]>;
def deco_Component : Decoration<31,[cap_Shader],[IntOperand]>;
def deco_Index : Decoration<31,[cap_Shader],[IntOperand]>;
def deco_Binding : Decoration<33,[cap_Shader],[IntOperand]>;
def deco_DescriptorSet : Decoration<34,[cap_Shader],[IntOperand]>;
def deco_Offset : Decoration<35,[cap_Shader],[IntOperand]>;
def deco_XfbBuffer : Decoration<36,[cap_Shader],[IntOperand]>;
def deco_XfbStride : Decoration<37,[cap_Shader],[IntOperand]>;
def deco_FuncParamAttr : Decoration<38,[cap_Shader],[FunctionParameteAttribute]>;
def deco_FPRoundingMode : Decoration<39,[cap_Shader],[RoundingMode]>;
def deco_FPFastMathMode : Decoration<40,[cap_Shader],[FPFastMathMode]>;
def deco_LinkageAttributes : Decoration<41,[cap_Shader],[StringOperand,LinkageType]>;
def deco_NoContraction : Decoration<41,[cap_Shader]>;
def deco_InputAttachmentIndex : Decoration<43,[cap_Shader],[IntOperand]>;
def deco_Alignment : Decoration<44,[cap_Shader],[IntOperand]>;
def deco_MaxByteOffset : Decoration<45,[cap_Shader],[IntOperand]>;


// Section 3.21 BuiltIn

class BuiltIn<int op, list<Capability> cap> :  SPIRVEnum {
  let Op = op;
  let Section = 21;
  list<Capability> Cap = cap;
}

def builtin_Position  : BuiltIn<0,[cap_Shader]>;
def builtin_PointSize : BuiltIn<1,[cap_Shader]>;
def builtin_ClipDistance : BuiltIn<2,[cap_ClipDistance]>;
def builtin_CullDistance : BuiltIn<3,[cap_CullDistance[>;
def builtin_VertexId : BuiltIn<4,[cap_Shader]>;
def builtin_InstanceId : BuiltIn<5,[cap_Shader[>;
def builtin_PrimitiveId : BuiltIn<6>;
def builtin_InvocationId : BuiltIn<7>;
def builtin_Layer : BuiltIn<8>;
def builtin_ViewportIndex : BuiltIn<9>;
def builtin_TessLevelOuter : BuiltIn<10>;
def builtin_TessLevelInner : BuiltIn<11>;
def builtin_TessCoord : BuiltIn<12>;
def builtin_PatchVertices : BuiltIn<13>;
def builtin_FragCoord : BuiltIn<14>;
def builtin_PointCoord : BuiltIn<15>;
def builtin_FrontFacing : BuiltIn<16>;
def builtin_SampleId : BuiltIn<17>;
def builtin_SamplePosition : BuiltIn<28>;
def builtin_SampleMask : BuiltIn<20>;
// There is no #21
def builtin_FragDepth : BuiltIn<22>;
def builtin_HelperInvocation : BuiltIn<23>;
def builtin_NumWorkgroups : BuiltIn<24>;
def builtin_WorkgroupSize : BuiltIn<25>;
def builtin_WorkgroupId : BuiltIn<26>;
def builtin_LocalInvocationId : BuiltIn<27>;
def builtin_GlobalInvocationId : BuiltIn<28>;
def builtin_LocalInvocationIndex : BuiltIn<29>;
def builtin_WorkDim : BuiltIn<30>;
def builtin_GlobalSize : BuiltIn<31>;
def builtin_EnqueuedWorkgroupSize : BuiltIn<32>;
def builtin_GlobalOffset : BuiltIn<33>;
def builtin_GlobalLinearId : BuiltIn<34>;
// There is no #35
def builtin_SubgroupSize : BuiltIn<36>;
def builtin_SubgroupMaxSize : BuiltIn<37>;
def builtin_NumSubgroups : BuiltIn<38>;
def builtin_NumEnqueuedSubgroups : BuiltIn<39>;
def builtin_SubgroupId : BuiltIn<40>;
def builtin_SubgroupLocalInvocationId : BuiltIn<41>;
def builtin_VertexIndex : BuiltIn<42>;
def builtin_InstanceIndex : BuiltIn<43>;
// Extensions
//def builtin_ : BuiltIn<4416>;
//def builtin_ : BuiltIn<0>;
//def builtin_ : BuiltIn<0>;
//def builtin_ : BuiltIn<0>;

// Section 3.22 Selection Control
class SelectionControl<int op> :  SPIRVEnum {
  let Op = op;
  let Section = 22;
}

def sc_None : SelectionControl<0>;
def sc_Flatten : SelectionControl<1>;
def sc_DontFlatten : SelectionControl<2>;

// Section 3.23 Loop Control
class LoopControl<int op, list<Operand> followedBy = []> {
  let Op = op;
  let isMask = 1;
  let FollowedLiterals = followedBy;
}

def lc_None : LoopControl<0>;
def lc_Unroll : LoopControl<1>;
def lc_DontUnoll : LoopControl<2>;
def lc_DependencyInfinite : LoopControl<4>; //no dependencies between loop iterations
def lc_DependencyLength : LoopControl<8,[IntOperand]>; // a dependency of n loop iterations


// Section 3.24 Function Control
class FunctionControl<int op> :  SPIRVEnum {
  let Op = op;
  let Section = 24;
  let Mask = 1;
}

def fc_None : FunctionControl<0>;
def fc_Inline : FunctionControl<1>;
def fc_DontInline : FunctionControl<2>;
def fc_Pure : FunctionControl<4>;  // Weakly pure
def fc_Const : FunctionControl<8>; // Strongly pure

// Section 3.25 Memory Semantics
class MemorySemantics<int op,list<Capability> cap = []]> :  SPIRVEnum {
  let Op = op;
  let isMask = 1;
  let isID = 1;
  list<Capability> Cap = cap;
}

def ms_None : FunctionControl<0>; // Relaxed
// There is no #1
def ms_Acquire : FunctionControl<2>;
def ms_Release : FunctionControl<4>;
def ms_AcquireRelease : FunctionControl<8>;
def ms_SequentiallyConsistent : FunctionControl<16>;
// There is no #32 (0x20)
def ms_UniformMemory : FunctionControl<64, [cap_Shader]>;
def ms_SubgroupMemory : FunctionControl<128>;
def ms_WorkgroupMemory : FunctionControl<256>;
def ms_CrossWorkgroupMemory : FunctionControl<512>;
def ms_AtomicCounterMemory : FunctionControl<1024,[cap_AtomicStorage]>;
def ms_ImageMemory : FunctionControl<2048>;

// Section 3.26 Memory Access
class MemoryAccess<int op, list<Operands> followedBy = []> :  SPIRVEnum {
  let Op = op;
  let isMask = 1;
  let FollowedLiterals = followedBy;
}

def ma_None : MemoryAccess<0>; // Relaxed
def ma_Volatile : MemoryAccess<1>;
def ma_Aligned : MemoryAccess<2,[IntOperand]>;
def ma_Nontemporal : MemoryAccess<4>;


// Section 3.27 Scope
class Scope<int op> :  SPIRVEnum {
  let Op = op;
  let isID = 1;
  let Section= = 27;
}

def scope_CrossDevice   : Scope<0>;
def scope_Device        : Scope<1>;
def scope_Workgroup     : Scope<2>;
def scope_Subgroup      : Scope<3>;
def scope_Invocation    : Scope<4>;

// Section 3.28 Group Operation

class GroupOperation<int op> {
let Op = op;
let Section = 28;
Capability Cap = cap_Kernel;
}

def go_Reduce : GroupOperation<0>;
def go_InclusiveScan : GroupOperation<1>;
def go_ExclusiveScan : GroupOperation<2>;

// Section 3.29 Kernel Enqueue Flags

class KernelEnqueueFlags<int op> {
let Op = op;
let Section = 29;
Capability Cap = cap_Kernel;
}

def kef_NoWait          : KernelEnqueueFlags<0>;
def kef_WaitKernel      : KernelEnqueueFlags<1>;
def kef_WaitWorkGroup   : KernelEnqueueFlags<2>;

// Section 3.30 Kernel Profiling Info

class KernelProfilingInfo<int op> {
let Op = op;
let Section = 30;
Capability Cap = cap_Kernel;
let isMask = 1;
}

def kpi_None : KernelProfilingInfo<0>;
def kpi_CmdExecTime : KernelProfilingInfo<0>;

// Section 3.31 is at the top of this file.

// Section 3.32 - Instructions
include "Instructions.td"




