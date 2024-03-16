; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the memcpy library call simplifier works correctly.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

declare i8* @memcpy(i8*, i8*, i32)

; Check memcpy(mem1, mem2, size) -> llvm.memcpy(mem1, mem2, size, 1).

define i8* @test_simplify1(i8* %mem1, i8* %mem2, i32 %size) {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 [[MEM1:%.*]], i8* align 1 [[MEM2:%.*]], i32 [[SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret i8* [[MEM1]]
;
  %ret = call i8* @memcpy(i8* %mem1, i8* %mem2, i32 %size)
  ret i8* %ret
}

; Verify that the strictfp attr doesn't block this optimization.

define i8* @test_simplify2(i8* %mem1, i8* %mem2, i32 %size) strictfp {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 [[MEM1:%.*]], i8* align 1 [[MEM2:%.*]], i32 [[SIZE:%.*]], i1 false) #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    ret i8* [[MEM1]]
;
  %ret = call i8* @memcpy(i8* %mem1, i8* %mem2, i32 %size) strictfp
  ret i8* %ret
}

; Verify that the first parameter to memcpy could itself be a call that's not
; tail, while the call to @memcpy could be tail.
declare i8* @get_dest()

define i8* @test_simplify3(i8* %mem2, i32 %size) {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    [[DEST:%.*]] = call i8* @get_dest()
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 [[DEST]], i8* align 1 [[MEM2:%.*]], i32 [[SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret i8* [[DEST]]
;

  %dest = call i8* @get_dest()
  %ret = tail call i8* @memcpy(i8* %dest, i8* %mem2, i32 %size)
  ret i8* %ret
}

define i8* @test_no_incompatible_attr(i8* %mem1, i8* %mem2, i32 %size) {
; CHECK-LABEL: @test_no_incompatible_attr(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 1 [[MEM1:%.*]], i8* align 1 [[MEM2:%.*]], i32 [[SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret i8* [[MEM1]]
;

  %ret = call dereferenceable(1) i8* @memcpy(i8* %mem1, i8* %mem2, i32 %size)
  ret i8* %ret
}

define i8* @test_no_simplify1(i8* %mem1, i8* %mem2, i32 %size) {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[RET:%.*]] = musttail call i8* @memcpy(i8* [[MEM1:%.*]], i8* [[MEM2:%.*]], i32 [[SIZE:%.*]])
; CHECK-NEXT:    ret i8* [[RET]]
;
  %ret = musttail call i8* @memcpy(i8* %mem1, i8* %mem2, i32 %size)
  ret i8* %ret
}
