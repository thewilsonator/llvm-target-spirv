//===-- InstructionsOCL.td - SPIRV Core Instructions -------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// File contains section the instructions from the OpenCL instruction set
//===----------------------------------------------------------------------===//

let InstructionSet = instset_OpenCL in {

let InstClass = 1 in {

  def inst_ocl_acos     : ExtInstFPUnary<0>;
  def inst_ocl_acosh    : ExtInstFPUnary<1>;
  def inst_ocl_acospi   : ExtInstFPUnary<2>;

  def inst_ocl_asin     : ExtInstFPUnary<3>;
  def inst_ocl_asinh    : ExtInstFPUnary<4>;
  def inst_ocl_asinpi   : ExtInstFPUnary<5>;

  def inst_ocl_atan     : ExtInstFPUnary<6>;
  def inst_ocl_atan2    : ExtInstFPBinary<7>;
  def inst_ocl_atanh    : ExtInstFPUnary<8>;
  def inst_ocl_atanpi   : ExtInstFPUnary<9>;
  def inst_ocl_atan2pi  : ExtInstFPBinary<10>;

  def inst_ocl_cbrt     : ExtInstFPUnary<11>;
  def inst_ocl_ceil     : ExtInstFPUnary<12>;
  def inst_ocl_copysign : ExtInstFPBinary<13>;

  def inst_ocl_cos      : ExtInstFPUnary<14>;
  def inst_ocl_cosh     : ExtInstFPUnary<15>;
  def inst_ocl_cospi    : ExtInstFPUnary<16>;

  def inst_ocl_erfc     : ExtInstFPUnary<17>;
  def inst_ocl_erf      : ExtInstFPUnary<18>;

  def inst_ocl_exp      : ExtInstFPUnary<19>;
  def inst_ocl_exp2     : ExtInstFPUnary<20>;
  def inst_ocl_exp10    : ExtInstFPUnary<21>;
  def inst_ocl_expm1    : ExtInstFPUnary<22>;

  def inst_ocl_fabs     : ExtInstFPUnary<23>;
  def inst_ocl_fdim     : ExtInstFPBinary<24>;
  def inst_ocl_floor    : ExtInstFPUnary<25>;
  def inst_ocl_floor    : ExtInstFPTrinary<26>;
  def inst_ocl_fmax     : ExtInstFPBinary<27>;
  def inst_ocl_fmin     : ExtInstFPBinary<28>;
  def inst_ocl_fmod     : ExtInstFPBinary<29>;

  def inst_ocl_fract    : ExtInstFP2ArgReturn<30>;
  def inst_ocl_frexp    : ExtInstFP2ArgReturn<31>;

  def inst_ocl_hypot    : ExtInstFPBinary<32>;

  def inst_ocl_ilogb    : ExtInstFPtoI32<33>;

  def inst_ocl_ldexp    : ExtInstFPArgFPInt32<34>;

  def inst_ocl_lgamma   : ExtInstFPUnary<35>;
  def inst_ocl_lgammar  : ExtInstFP2ArgReturn<36>;

  def inst_ocl_log      : ExtInstFPUnary<37>;
  def inst_ocl_log2     : ExtInstFPUnary<38>;
  def inst_ocl_log10    : ExtInstFPUnary<39>;
  def inst_ocl_log1p    : ExtInstFPUnary<40>;
  def inst_ocl_logb     : ExtInstFPUnary<41>;

  def inst_ocl_mad      : ExtInstFPTrinary<42>;

  def inst_ocl_maxmag   : ExtInstFPBinary<43>;
  def inst_ocl_minmag   : ExtInstFPBinary<44>;

  def inst_ocl_modf     : ExtInstFP2ArgReturn<45>;

  def inst_ocl_nan      : ExtInstI32toFP<46>;

  def inst_ocl_nextafter: ExtInstFPBinary<47>;

  def inst_ocl_pow      : ExtInstFPBinary<48>;
  def inst_ocl_pown     : ExtInstFPArgFPInt32<49>;
  def inst_ocl_powr     : ExtInstFPBinary<50>;

  def inst_ocl_remainder: ExtInstFPBinary<51>;
  def inst_ocl_remquo   : ExtInstFP2BinaryArgReturn<52>;
  def inst_ocl rint     : ExtInstFPtoI32<53>;

  def inst_ocl_rootn    : ExtInstFPArgFPInt32<54>;
  def inst_ocl_round    : ExtInstFPUnary<55>;
  def inst_ocl_rsqrt    : ExtInstFPUnary<56>;

  def inst_ocl_sin      : ExtInstFPUnary<57>;
  def inst_ocl_sincos   : ExtInstFP2ArgReturn<58>;
  def inst_ocl_sinh     : ExtInstFPUnary<59>;
  def inst_ocl_sinpi    : ExtInstFPUnary<60>;

  def inst_ocl_sqrt     : ExtInstFPUnary<61>;

  def inst_ocl_tan      : ExtInstFPUnary<62>;
  def inst_ocl_tanh     : ExtInstFPUnary<63>;
  def inst_ocl_tanpi    : ExtInstFPUnary<64>;

  def inst_ocl_tgamma   : ExtInstFPUnary<65>;
  def inst_ocl_trunc    : ExtInstFPUnary<66>;

//FIXME float32 only
  def inst_ocl_half_cos  : ExtInstFPUnary<67>;
  def inst_ocl_half_divide: ExtInstFPBinary<68>;
  def inst_ocl_half_exp  : ExtInstFPUnary<69>;
  def inst_ocl_half_exp2 : ExtInstFPUnary<70>;
  def inst_ocl_half_exp10: ExtInstFPUnary<71>;
  def inst_ocl_half_log  : ExtInstFPUnary<72>;
  def inst_ocl_half_log2 : ExtInstFPUnary<73>;
  def inst_ocl_half_log10: ExtInstFPUnary<74>;
  def inst_ocl_half_powr : ExtInstFPBinary<75>;
  def inst_ocl_half_recip : ExtInstFPUnary<76>;
  def inst_ocl_half_rsqrt : ExtInstFPUnary<77>;
  def inst_ocl_half_sin  : ExtInstFPUnary<78>;
  def inst_ocl_half_sqrt : ExtInstFPUnary<79>;
  def inst_ocl_half_tan  : ExtInstFPUnary<80>;

  def inst_ocl_native_cos  : ExtInstFPUnary<81>;
  def inst_ocl_native_divide: ExtInstFPBinary<82>;
  def inst_ocl_native_exp  : ExtInstFPUnary<83>;
  def inst_ocl_native_exp2 : ExtInstFPUnary<84>;
  def inst_ocl_native_exp10: ExtInstFPUnary<85>;
  def inst_ocl_native_log  : ExtInstFPUnary<86>;
  def inst_ocl_native_log2 : ExtInstFPUnary<87>;
  def inst_ocl_native_log10: ExtInstFPUnary<88>;
  def inst_ocl_native_powr : ExtInstFPBinary<89>;
  def inst_ocl_native_recip   : ExtInstFPUnary<90>;
  def inst_ocl_native_rsqrt   : ExtInstFPUnary<91>;
  def inst_ocl_native_sin  : ExtInstFPUnary<92>;
  def inst_ocl_native_sqrt : ExtInstFPUnary<93>;
  def inst_ocl_native_tan  : ExtInstFPUnary<94>;
}
let InstClass = 2 in {
  def inst_ocl_abs_s     : ExtInstIntUnary<141>;
  def inst_ocl_absdiff_s : ExtInstIntBinary<142>;
  def inst_ocl_addsat_s  : ExtInstIntBinary<143>;
  def inst_ocl_addsat_u  : ExtInstIntBinary<144>;
  def inst_ocl_hadd_s    : ExtInstIntBinary<145>;
  def inst_ocl_hadd_u    : ExtInstIntBinary<146>;
  def inst_ocl_rhadd_s   : ExtInstIntBinary<147>;
  def inst_ocl_rhadd_u   : ExtInstIntBinary<148>;
  def inst_ocl_clamp_s   : ExtInstIntBinary<149>;
  def inst_ocl_clamp_u   : ExtInstIntBinary<150>;

  def inst_ocl_clz       : ExtInstIntUnary<151>;
  def inst_ocl_ctz       : ExtInstIntUnary<152>;

  def inst_ocl_madhi_s  : ExtInstIntTrinary<153>;
  def inst_ocl_mad_sat_u : ExtInstIntTrinary<154>;
  def inst_ocl_mad_sat_s : ExtInstIntTrinary<155>;

  def inst_ocl_max_s     : ExtInstIntBinary<156>;
  def inst_ocl_max_u     : ExtInstIntBinary<157>;
  def inst_ocl_min_s     : ExtInstIntBinary<158>;
  def inst_ocl_min_u     : ExtInstIntBinary<159>;

  def inst_ocl_mulhi_s   : ExtInstIntBinary<160>;

  def inst_ocl_rotate    : ExtInstIntBinary<161>;

  def inst_ocl_subsat_s  : ExtInstIntBinary<162>;
  def inst_ocl_subsat_u  : ExtInstIntBinary<163>;

  // FIXME: these are int_(half_int_t,half_int_t)
  def inst_ocl_upsample_u : ExtInstIntBinary<164>;
  def inst_ocl_upsample_s : ExtInstIntBinary<165>;

  def inst_ocl_popcount  : ExtInstIntUnary<166>;

  def inst_ocl_mad24_s   : ExtInstIntTrinary<167>;
  def inst_ocl_mad24_u   : ExtInstIntTrinary<168>;
  def inst_ocl_mul24_s   : ExtInstIntBinary<169>;
  def inst_ocl_mul24_u   : ExtInstIntBinary<170>;

  def inst_ocl_abs_u     : ExtInstIntUnary<201>;
  def inst_ocl_absdiff_u : ExtInstIntBinary<202>;
  def inst_ocl_mulhi_u   : ExtInstIntBinary<203>;
  def inst_ocl_madhi_u   : ExtInstIntBinary<204>;
}

let InstClass = 3 in {
  def inst_ocl_fclamp    : ExtInstFPTrinary<95>;
  def inst_ocl_degrees   : ExtInstFPUnary<96>;

  def inst_ocl_fmax_common     : ExtInstFPBinary<97>;
  def inst_ocl_fmin_common     : ExtInstFPBinary<98>;

  def inst_ocl_mix       : ExtInstFPTrinary<99>;
  def inst_ocl_radians   : ExtInstFPUnary<100>;
  def inst_ocl_step      : ExtInstFPUnary<101>;
  def inst_ocl_step_smooth : ExtInstFPBinary<102>;
  def inst_ocl_sign      : ExtInstFPUnary<103>;
}

// FIXME: these take vector{3,4}f
let InstClass = 4 in {

  def inst_ocl_cross     : ExtInstFPBinary<104>;

  def inst_ocl_distance  : ExtInstFPBinary<105>;
  def inst_ocl_length    : ExtInstFPUnary<106>;
  def inst_ocl_normalise : ExtInstFPUnary<107>;

  def inst_ocl_distance_fast  : ExtInstFPBinary<108>;
  def inst_ocl_length_fast    : ExtInstFPUnary<109>;
  def inst_ocl_normalise_fast : ExtInstFPUnary<110>;
}

let InstClass = 5 in {
  def inst_ocl_bitselect : ExtInstAnyTrinary<186>;
  def inst_ocl_select    : ExtInstAnyTrinary<187>;
}

}



