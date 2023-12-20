; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i3 @llvm.ctlz.i3 (i3 , i1)
declare i32 @llvm.ctlz.i32 (i32, i1)
declare i34 @llvm.ctlz.i34 (i34, i1)
declare <2 x i33> @llvm.ctlz.v2i33 (<2 x i33>, i1)
declare <2 x i32> @llvm.ctlz.v2i32 (<2 x i32>, i1)
declare <vscale x 2 x i64> @llvm.ctlz.nxv2i64 (<vscale x 2 x i64>, i1)
declare <vscale x 2 x i63> @llvm.ctlz.nxv2i63 (<vscale x 2 x i63>, i1)
declare void @use(<2 x i32>)
declare void @use1(<vscale x 2 x i63>)

define i16 @trunc_ctlz_zext_i16_i32(i16 %x) {
; CHECK-LABEL: @trunc_ctlz_zext_i16_i32(
; CHECK-NEXT:    [[TMP1:%.*]] = call i16 @llvm.ctlz.i16(i16 [[X:%.*]], i1 false), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[ZZ:%.*]] = add nuw nsw i16 [[TMP1]], 16
; CHECK-NEXT:    ret i16 [[ZZ]]
;
  %z = zext i16 %x to i32
  %p = call i32 @llvm.ctlz.i32(i32 %z, i1 false)
  %zz = trunc i32 %p to i16
  ret i16 %zz
}

; Fixed vector case

define <2 x i8> @trunc_ctlz_zext_v2i8_v2i33(<2 x i8> %x) {
; CHECK-LABEL: @trunc_ctlz_zext_v2i8_v2i33(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.ctlz.v2i8(<2 x i8> [[X:%.*]], i1 true)
; CHECK-NEXT:    [[ZZ:%.*]] = add nuw nsw <2 x i8> [[TMP1]], <i8 25, i8 25>
; CHECK-NEXT:    ret <2 x i8> [[ZZ]]
;
  %z = zext <2 x i8> %x to <2 x i33>
  %p = call <2 x i33> @llvm.ctlz.v2i33(<2 x i33> %z, i1 true)
  %zz = trunc <2 x i33> %p to <2 x i8>
  ret <2 x i8> %zz
}

; Scalable vector case

define <vscale x 2 x i16> @trunc_ctlz_zext_nxv2i16_nxv2i64(<vscale x 2 x i16> %x) {
; CHECK-LABEL: @trunc_ctlz_zext_nxv2i16_nxv2i64(
; CHECK-NEXT:    [[TMP1:%.*]] = call <vscale x 2 x i16> @llvm.ctlz.nxv2i16(<vscale x 2 x i16> [[X:%.*]], i1 false)
; CHECK-NEXT:    [[ZZ:%.*]] = add nuw nsw <vscale x 2 x i16> [[TMP1]], shufflevector (<vscale x 2 x i16> insertelement (<vscale x 2 x i16> poison, i16 48, i32 0), <vscale x 2 x i16> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    ret <vscale x 2 x i16> [[ZZ]]
;
  %z = zext <vscale x 2 x i16> %x to <vscale x 2 x i64>
  %p = call <vscale x 2 x i64> @llvm.ctlz.nxv2i64(<vscale x 2 x i64> %z, i1 false)
  %zz = trunc <vscale x 2 x i64> %p to <vscale x 2 x i16>
  ret <vscale x 2 x i16> %zz
}

; Multiple uses of ctlz for which the opt is disabled

define <2 x i17> @trunc_ctlz_zext_v2i17_v2i32_multiple_uses(<2 x i17> %x) {
; CHECK-LABEL: @trunc_ctlz_zext_v2i17_v2i32_multiple_uses(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i17> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[P:%.*]] = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> [[Z]], i1 false)
; CHECK-NEXT:    [[ZZ:%.*]] = trunc <2 x i32> [[P]] to <2 x i17>
; CHECK-NEXT:    call void @use(<2 x i32> [[P]])
; CHECK-NEXT:    ret <2 x i17> [[ZZ]]
;
  %z = zext <2 x i17> %x to <2 x i32>
  %p = call <2 x i32> @llvm.ctlz.v2i32(<2 x i32> %z, i1 false)
  %zz = trunc <2 x i32> %p to <2 x i17>
  call void @use(<2 x i32> %p)
  ret <2 x i17> %zz
}

; Multiple uses of zext

define <vscale x 2 x i16> @trunc_ctlz_zext_nxv2i16_nxv2i63_multiple_uses(<vscale x 2 x i16> %x) {
; CHECK-LABEL: @trunc_ctlz_zext_nxv2i16_nxv2i63_multiple_uses(
; CHECK-NEXT:    [[Z:%.*]] = zext <vscale x 2 x i16> [[X:%.*]] to <vscale x 2 x i63>
; CHECK-NEXT:    [[TMP1:%.*]] = call <vscale x 2 x i16> @llvm.ctlz.nxv2i16(<vscale x 2 x i16> [[X]], i1 true)
; CHECK-NEXT:    [[ZZ:%.*]] = add nuw nsw <vscale x 2 x i16> [[TMP1]], shufflevector (<vscale x 2 x i16> insertelement (<vscale x 2 x i16> poison, i16 47, i32 0), <vscale x 2 x i16> poison, <vscale x 2 x i32> zeroinitializer)
; CHECK-NEXT:    call void @use1(<vscale x 2 x i63> [[Z]])
; CHECK-NEXT:    ret <vscale x 2 x i16> [[ZZ]]
;
  %z = zext <vscale x 2 x i16> %x to <vscale x 2 x i63>
  %p = call <vscale x 2 x i63> @llvm.ctlz.nxv2i63(<vscale x 2 x i63> %z, i1 true)
  %zz = trunc <vscale x 2 x i63> %p to <vscale x 2 x i16>
  call void @use1(<vscale x 2 x i63> %z)
  ret <vscale x 2 x i16> %zz
}

; Negative case where types of x and zz don't match

define i16 @trunc_ctlz_zext_i10_i32(i10 %x) {
; CHECK-LABEL: @trunc_ctlz_zext_i10_i32(
; CHECK-NEXT:    [[Z:%.*]] = zext i10 [[X:%.*]] to i32
; CHECK-NEXT:    [[P:%.*]] = call i32 @llvm.ctlz.i32(i32 [[Z]], i1 false), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    [[ZZ:%.*]] = trunc i32 [[P]] to i16
; CHECK-NEXT:    ret i16 [[ZZ]]
;
  %z = zext i10 %x to i32
  %p = call i32 @llvm.ctlz.i32(i32 %z, i1 false)
  %zz = trunc i32 %p to i16
  ret i16 %zz
}

; Test width difference of more than log2 between x and t
; TODO: Enable the opt for this case if it is proved that the
; opt works for all combinations of bitwidth of zext src and dst.
; Refer : https://reviews.llvm.org/D103788

define i3 @trunc_ctlz_zext_i3_i34(i3 %x) {
; CHECK-LABEL: @trunc_ctlz_zext_i3_i34(
; CHECK-NEXT:    [[Z:%.*]] = zext i3 [[X:%.*]] to i34
; CHECK-NEXT:    [[P:%.*]] = call i34 @llvm.ctlz.i34(i34 [[Z]], i1 false), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[T:%.*]] = trunc i34 [[P]] to i3
; CHECK-NEXT:    ret i3 [[T]]
;
  %z = zext i3 %x to i34
  %p = call i34 @llvm.ctlz.i34(i34 %z, i1 false)
  %t = trunc i34 %p to i3
  ret i3 %t
}
