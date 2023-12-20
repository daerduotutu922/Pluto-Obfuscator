; RUN: llc -mtriple=x86_64-unknown-unknown < %s | FileCheck %s

; CHECK-LABEL: tail_memcpy
; CHECK: jmp memcpy
define void @tail_memcpy(i8* nocapture %p, i8* nocapture readonly %q, i32 %n) #0 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %p, i8* %q, i32 %n, i1 false)
  ret void
}

; CHECK-LABEL: tail_memmove
; CHECK: jmp memmove
define void @tail_memmove(i8* nocapture %p, i8* nocapture readonly %q, i32 %n) #0 {
entry:
  tail call void @llvm.memmove.p0i8.p0i8.i32(i8* %p, i8* %q, i32 %n, i1 false)
  ret void
}

; CHECK-LABEL: tail_memset
; CHECK: jmp memset
define void @tail_memset(i8* nocapture %p, i8 %c, i32 %n) #0 {
entry:
  tail call void @llvm.memset.p0i8.i32(i8* %p, i8 %c, i32 %n, i1 false)
  ret void
}

; CHECK-LABEL: tail_memcpy_ret
; CHECK: jmp memcpy
define i8* @tail_memcpy_ret(i8* nocapture %p, i8* nocapture readonly %q, i32 %n) #0 {
entry:
  tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* %p, i8* %q, i32 %n, i1 false)
  ret i8* %p
}

; CHECK-LABEL: tail_memmove_ret
; CHECK: jmp memmove
define i8* @tail_memmove_ret(i8* nocapture %p, i8* nocapture readonly %q, i32 %n) #0 {
entry:
  tail call void @llvm.memmove.p0i8.p0i8.i32(i8* %p, i8* %q, i32 %n, i1 false)
  ret i8* %p
}

; CHECK-LABEL: tail_memset_ret
; CHECK: jmp memset
define i8* @tail_memset_ret(i8* nocapture %p, i8 %c, i32 %n) #0 {
entry:
  tail call void @llvm.memset.p0i8.i32(i8* %p, i8 %c, i32 %n, i1 false)
  ret i8* %p
}

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i1) #0
declare void @llvm.memmove.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i1) #0
declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i1) #0

attributes #0 = { nounwind }
