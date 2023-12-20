; Test alloca instrumentation when tags are generated by HWASan function.
;
; RUN: opt < %s -hwasan -hwasan-generate-tags-with-calls -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare void @use32(i32*)

define void @test_alloca() sanitize_hwaddress {
; CHECK-LABEL: @test_alloca(
; CHECK: %[[BC:[^ ]*]] = bitcast { i32, [12 x i8] }* %x to i32*
; CHECK: %[[T1:[^ ]*]] = call i8 @__hwasan_generate_tag()
; CHECK: %[[A:[^ ]*]] = zext i8 %[[T1]] to i64
; CHECK: %[[B:[^ ]*]] = ptrtoint i32* %[[BC]] to i64
; CHECK: %[[C:[^ ]*]] = shl i64 %[[A]], 57
; CHECK: or i64 %[[B]], %[[C]]

entry:
  %x = alloca i32, align 4
  call void @use32(i32* nonnull %x)
  ret void
}
