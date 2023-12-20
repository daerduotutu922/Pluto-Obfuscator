; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -memcpyopt -S < %s -verify-memoryssa | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128-ni:1"

define void @illegal_memset(i64 addrspace(1)** %p) {
; CHECK-LABEL: @illegal_memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P1:%.*]] = bitcast i64 addrspace(1)** [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[P1]], i8 0, i64 8, i1 false)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i64 addrspace(1)*, i64 addrspace(1)** [[P]], i64 1
; CHECK-NEXT:    store i64 addrspace(1)* null, i64 addrspace(1)** [[GEP]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %p1 = bitcast i64 addrspace(1)** %p to i8*
  call void @llvm.memset.p0i8.i64(i8* %p1, i8 0, i64 8, i32 0, i1 false)
  %gep = getelementptr i64 addrspace(1)*, i64 addrspace(1)** %p, i64 1
  store i64 addrspace(1)* null, i64 addrspace(1)** %gep
  ret void
}

define void @illegal_memcpy(<2 x i8 addrspace(1)*>* noalias align 16 %a,
; CHECK-LABEL: @illegal_memcpy(
; CHECK-NEXT:    [[VAL:%.*]] = load <2 x i8 addrspace(1)*>, <2 x i8 addrspace(1)*>* [[A:%.*]], align 16
; CHECK-NEXT:    store <2 x i8 addrspace(1)*> [[VAL]], <2 x i8 addrspace(1)*>* [[B:%.*]], align 16
; CHECK-NEXT:    ret void
;
  <2 x i8 addrspace(1)*>* noalias align 16 %b) {
  %val = load <2 x i8 addrspace(1)*>, <2 x i8 addrspace(1)*>* %a, align 16
  store <2 x i8 addrspace(1)*> %val, <2 x i8 addrspace(1)*>* %b, align 16
  ret void
}

declare void @llvm.memset.p1i8.i64(i8 addrspace(1)*, i8, i64, i32, i1)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i32, i1)
