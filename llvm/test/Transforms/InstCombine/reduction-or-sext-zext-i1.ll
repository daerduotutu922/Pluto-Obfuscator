; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i1 @reduce_or_self(<8 x i1> %x) {
; CHECK-LABEL: @reduce_or_self(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i1> [[X:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %res = call i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %x)
  ret i1 %res
}

define i32 @reduce_or_sext(<4 x i1> %x) {
; CHECK-LABEL: @reduce_or_sext(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <4 x i1> [[X:%.*]] to i4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i4 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = sext i1 [[TMP2]] to i32
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %sext = sext <4 x i1> %x to <4 x i32>
  %res = call i32 @llvm.vector.reduce.or.v4i32(<4 x i32> %sext)
  ret i32 %res
}

define i64 @reduce_or_zext(<8 x i1> %x) {
; CHECK-LABEL: @reduce_or_zext(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i1> [[X:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i64
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %zext = zext <8 x i1> %x to <8 x i64>
  %res = call i64 @llvm.vector.reduce.or.v8i64(<8 x i64> %zext)
  ret i64 %res
}

define i16 @reduce_or_sext_same(<16 x i1> %x) {
; CHECK-LABEL: @reduce_or_sext_same(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <16 x i1> [[X:%.*]] to i16
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i16 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = sext i1 [[TMP2]] to i16
; CHECK-NEXT:    ret i16 [[TMP3]]
;
  %sext = sext <16 x i1> %x to <16 x i16>
  %res = call i16 @llvm.vector.reduce.or.v16i16(<16 x i16> %sext)
  ret i16 %res
}

define i8 @reduce_or_zext_long(<128 x i1> %x) {
; CHECK-LABEL: @reduce_or_zext_long(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <128 x i1> [[X:%.*]] to i128
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i128 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = sext i1 [[TMP2]] to i8
; CHECK-NEXT:    ret i8 [[TMP3]]
;
  %sext = sext <128 x i1> %x to <128 x i8>
  %res = call i8 @llvm.vector.reduce.or.v128i8(<128 x i8> %sext)
  ret i8 %res
}

@glob = external global i8, align 1
define i8 @reduce_or_zext_long_external_use(<128 x i1> %x) {
; CHECK-LABEL: @reduce_or_zext_long_external_use(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <128 x i1> [[X:%.*]] to i128
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i128 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = sext i1 [[TMP2]] to i8
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <128 x i1> [[X]], i64 0
; CHECK-NEXT:    [[EXT:%.*]] = sext i1 [[TMP4]] to i8
; CHECK-NEXT:    store i8 [[EXT]], i8* @glob, align 1
; CHECK-NEXT:    ret i8 [[TMP3]]
;
  %sext = sext <128 x i1> %x to <128 x i8>
  %res = call i8 @llvm.vector.reduce.or.v128i8(<128 x i8> %sext)
  %ext = extractelement <128 x i8> %sext, i32 0
  store i8 %ext, i8* @glob, align 1
  ret i8 %res
}

@glob1 = external global i64, align 8
define i64 @reduce_or_zext_external_use(<8 x i1> %x) {
; CHECK-LABEL: @reduce_or_zext_external_use(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <8 x i1> [[X:%.*]] to i8
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i8 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = zext i1 [[TMP2]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x i1> [[X]], i64 0
; CHECK-NEXT:    [[EXT:%.*]] = zext i1 [[TMP4]] to i64
; CHECK-NEXT:    store i64 [[EXT]], i64* @glob1, align 8
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %zext = zext <8 x i1> %x to <8 x i64>
  %res = call i64 @llvm.vector.reduce.or.v8i64(<8 x i64> %zext)
  %ext = extractelement <8 x i64> %zext, i32 0
  store i64 %ext, i64* @glob1, align 8
  ret i64 %res
}

define i1 @reduce_or_pointer_cast(i8* %arg, i8* %arg1) {
; CHECK-LABEL: @reduce_or_pointer_cast(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[ARG1:%.*]] to i64*
; CHECK-NEXT:    [[LHS1:%.*]] = load i64, i64* [[TMP0]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[ARG:%.*]] to i64*
; CHECK-NEXT:    [[RHS2:%.*]] = load i64, i64* [[TMP1]], align 8
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i64 [[LHS1]], [[RHS2]]
; CHECK-NEXT:    ret i1 [[DOTNOT]]
;
bb:
  %ptr1 = bitcast i8* %arg1 to <8 x i8>*
  %ptr2 = bitcast i8* %arg to <8 x i8>*
  %lhs = load <8 x i8>, <8 x i8>* %ptr1
  %rhs = load <8 x i8>, <8 x i8>* %ptr2
  %cmp = icmp ne <8 x i8> %lhs, %rhs
  %any_ne = call i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %cmp)
  %all_eq = xor i1 %any_ne, 1
  ret i1 %all_eq
}

define i1 @reduce_or_pointer_cast_wide(i8* %arg, i8* %arg1) {
; CHECK-LABEL: @reduce_or_pointer_cast_wide(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i8* [[ARG1:%.*]] to <8 x i16>*
; CHECK-NEXT:    [[PTR2:%.*]] = bitcast i8* [[ARG:%.*]] to <8 x i16>*
; CHECK-NEXT:    [[LHS:%.*]] = load <8 x i16>, <8 x i16>* [[PTR1]], align 16
; CHECK-NEXT:    [[RHS:%.*]] = load <8 x i16>, <8 x i16>* [[PTR2]], align 16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <8 x i16> [[LHS]], [[RHS]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x i1> [[CMP]] to i8
; CHECK-NEXT:    [[DOTNOT:%.*]] = icmp eq i8 [[TMP0]], 0
; CHECK-NEXT:    ret i1 [[DOTNOT]]
;
bb:
  %ptr1 = bitcast i8* %arg1 to <8 x i16>*
  %ptr2 = bitcast i8* %arg to <8 x i16>*
  %lhs = load <8 x i16>, <8 x i16>* %ptr1
  %rhs = load <8 x i16>, <8 x i16>* %ptr2
  %cmp = icmp ne <8 x i16> %lhs, %rhs
  %any_ne = call i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %cmp)
  %all_eq = xor i1 %any_ne, 1
  ret i1 %all_eq
}


define i1 @reduce_or_pointer_cast_ne(i8* %arg, i8* %arg1) {
; CHECK-LABEL: @reduce_or_pointer_cast_ne(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8* [[ARG1:%.*]] to i64*
; CHECK-NEXT:    [[LHS1:%.*]] = load i64, i64* [[TMP0]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8* [[ARG:%.*]] to i64*
; CHECK-NEXT:    [[RHS2:%.*]] = load i64, i64* [[TMP1]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ne i64 [[LHS1]], [[RHS2]]
; CHECK-NEXT:    ret i1 [[TMP2]]
;
bb:
  %ptr1 = bitcast i8* %arg1 to <8 x i8>*
  %ptr2 = bitcast i8* %arg to <8 x i8>*
  %lhs = load <8 x i8>, <8 x i8>* %ptr1
  %rhs = load <8 x i8>, <8 x i8>* %ptr2
  %cmp = icmp ne <8 x i8> %lhs, %rhs
  %any_ne = call i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %cmp)
  ret i1 %any_ne
}

define i1 @reduce_or_pointer_cast_ne_wide(i8* %arg, i8* %arg1) {
; CHECK-LABEL: @reduce_or_pointer_cast_ne_wide(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i8* [[ARG1:%.*]] to <8 x i16>*
; CHECK-NEXT:    [[PTR2:%.*]] = bitcast i8* [[ARG:%.*]] to <8 x i16>*
; CHECK-NEXT:    [[LHS:%.*]] = load <8 x i16>, <8 x i16>* [[PTR1]], align 16
; CHECK-NEXT:    [[RHS:%.*]] = load <8 x i16>, <8 x i16>* [[PTR2]], align 16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne <8 x i16> [[LHS]], [[RHS]]
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast <8 x i1> [[CMP]] to i8
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8 [[TMP0]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
bb:
  %ptr1 = bitcast i8* %arg1 to <8 x i16>*
  %ptr2 = bitcast i8* %arg to <8 x i16>*
  %lhs = load <8 x i16>, <8 x i16>* %ptr1
  %rhs = load <8 x i16>, <8 x i16>* %ptr2
  %cmp = icmp ne <8 x i16> %lhs, %rhs
  %any_ne = call i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %cmp)
  ret i1 %any_ne
}

declare i1 @llvm.vector.reduce.or.v8i32(<8 x i1> %a)
declare i32 @llvm.vector.reduce.or.v4i32(<4 x i32> %a)
declare i64 @llvm.vector.reduce.or.v8i64(<8 x i64> %a)
declare i16 @llvm.vector.reduce.or.v16i16(<16 x i16> %a)
declare i8 @llvm.vector.reduce.or.v128i8(<128 x i8> %a)
