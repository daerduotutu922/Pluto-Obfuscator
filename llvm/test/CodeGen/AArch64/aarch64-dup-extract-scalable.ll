; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple aarch64-none-linux-gnu -mattr=+sve | FileCheck %s

define <vscale x 16 x i8> @dup_extract_i8(<vscale x 16 x i8> %data) {
; CHECK-LABEL: dup_extract_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.b, z0.b[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 16 x i8> %data, i8 1
  %.splatinsert = insertelement <vscale x 16 x i8> poison, i8 %1, i32 0
  %.splat = shufflevector <vscale x 16 x i8> %.splatinsert, <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
  ret <vscale x 16 x i8> %.splat
}

define <vscale x 8 x i16> @dup_extract_i16(<vscale x 8 x i16> %data) {
; CHECK-LABEL: dup_extract_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.h, z0.h[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 8 x i16> %data, i16 1
  %.splatinsert = insertelement <vscale x 8 x i16> poison, i16 %1, i32 0
  %.splat = shufflevector <vscale x 8 x i16> %.splatinsert, <vscale x 8 x i16> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x i16> %.splat
}

define <vscale x 4 x i32> @dup_extract_i32(<vscale x 4 x i32> %data) {
; CHECK-LABEL: dup_extract_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.s, z0.s[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 4 x i32> %data, i32 1
  %.splatinsert = insertelement <vscale x 4 x i32> poison, i32 %1, i32 0
  %.splat = shufflevector <vscale x 4 x i32> %.splatinsert, <vscale x 4 x i32> poison, <vscale x 4 x i32> zeroinitializer
  ret <vscale x 4 x i32> %.splat
}

define <vscale x 2 x i64> @dup_extract_i64(<vscale x 2 x i64> %data) {
; CHECK-LABEL: dup_extract_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 2 x i64> %data, i64 1
  %.splatinsert = insertelement <vscale x 2 x i64> poison, i64 %1, i32 0
  %.splat = shufflevector <vscale x 2 x i64> %.splatinsert, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  ret <vscale x 2 x i64> %.splat
}

define <vscale x 8 x half> @dup_extract_f16(<vscale x 8 x half> %data) {
; CHECK-LABEL: dup_extract_f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.h, z0.h[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 8 x half> %data, i16 1
  %.splatinsert = insertelement <vscale x 8 x half> poison, half %1, i32 0
  %.splat = shufflevector <vscale x 8 x half> %.splatinsert, <vscale x 8 x half> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x half> %.splat
}

define <vscale x 4 x half> @dup_extract_f16_4(<vscale x 4 x half> %data) {
; CHECK-LABEL: dup_extract_f16_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.s, z0.s[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 4 x half> %data, i16 1
  %.splatinsert = insertelement <vscale x 4 x half> poison, half %1, i32 0
  %.splat = shufflevector <vscale x 4 x half> %.splatinsert, <vscale x 4 x half> poison, <vscale x 4 x i32> zeroinitializer
  ret <vscale x 4 x half> %.splat
}

define <vscale x 2 x half> @dup_extract_f16_2(<vscale x 2 x half> %data) {
; CHECK-LABEL: dup_extract_f16_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 2 x half> %data, i16 1
  %.splatinsert = insertelement <vscale x 2 x half> poison, half %1, i32 0
  %.splat = shufflevector <vscale x 2 x half> %.splatinsert, <vscale x 2 x half> poison, <vscale x 2 x i32> zeroinitializer
  ret <vscale x 2 x half> %.splat
}

define <vscale x 8 x bfloat> @dup_extract_bf16(<vscale x 8 x bfloat> %data) #0 {
; CHECK-LABEL: dup_extract_bf16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.h, z0.h[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 8 x bfloat> %data, i16 1
  %.splatinsert = insertelement <vscale x 8 x bfloat> poison, bfloat %1, i32 0
  %.splat = shufflevector <vscale x 8 x bfloat> %.splatinsert, <vscale x 8 x bfloat> poison, <vscale x 8 x i32> zeroinitializer
  ret <vscale x 8 x bfloat> %.splat
}

define <vscale x 4 x float> @dup_extract_f32(<vscale x 4 x float> %data) {
; CHECK-LABEL: dup_extract_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.s, z0.s[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 4 x float> %data, i32 1
  %.splatinsert = insertelement <vscale x 4 x float> poison, float %1, i32 0
  %.splat = shufflevector <vscale x 4 x float> %.splatinsert, <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer
  ret <vscale x 4 x float> %.splat
}

define <vscale x 2 x float> @dup_extract_f32_2(<vscale x 2 x float> %data) {
; CHECK-LABEL: dup_extract_f32_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 2 x float> %data, i32 1
  %.splatinsert = insertelement <vscale x 2 x float> poison, float %1, i32 0
  %.splat = shufflevector <vscale x 2 x float> %.splatinsert, <vscale x 2 x float> poison, <vscale x 2 x i32> zeroinitializer
  ret <vscale x 2 x float> %.splat
}

define <vscale x 2 x double> @dup_extract_f64(<vscale x 2 x double> %data) {
; CHECK-LABEL: dup_extract_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov z0.d, z0.d[1]
; CHECK-NEXT:    ret
  %1 = extractelement <vscale x 2 x double> %data, i64 1
  %.splatinsert = insertelement <vscale x 2 x double> poison, double %1, i32 0
  %.splat = shufflevector <vscale x 2 x double> %.splatinsert, <vscale x 2 x double> poison, <vscale x 2 x i32> zeroinitializer
  ret <vscale x 2 x double> %.splat
}

; +bf16 is required for the bfloat version.
attributes #0 = { "target-features"="+sve,+bf16" }
