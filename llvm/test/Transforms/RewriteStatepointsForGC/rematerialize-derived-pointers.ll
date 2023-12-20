; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S | FileCheck %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S | FileCheck %s


declare void @use_obj16(i16 addrspace(1)*) "gc-leaf-function"
declare void @use_obj32(i32 addrspace(1)*) "gc-leaf-function"
declare void @use_obj64(i64 addrspace(1)*) "gc-leaf-function"

declare void @do_safepoint()

define void @test_gep_const(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_gep_const(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr = getelementptr i32, i32 addrspace(1)* %base, i32 15
  call void @do_safepoint() [ "deopt"() ]
  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj32(i32 addrspace(1)* %ptr)
  ret void
}

define void @test_gep_idx(i32 addrspace(1)* %base, i32 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test_gep_idx(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 [[IDX:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 [[IDX]]
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr = getelementptr i32, i32 addrspace(1)* %base, i32 %idx
  call void @do_safepoint() [ "deopt"() ]
  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj32(i32 addrspace(1)* %ptr)
  ret void
}

define void @test_bitcast(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = bitcast i32 addrspace(1)* [[BASE:%.*]] to i64 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_REMAT:%.*]] = bitcast i32 addrspace(1)* [[BASE_RELOCATED_CASTED]] to i64 addrspace(1)*
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr = bitcast i32 addrspace(1)* %base to i64 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]
  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj64(i64 addrspace(1)* %ptr)
  ret void
}

define void @test_bitcast_bitcast(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_bitcast_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR1:%.*]] = bitcast i32 addrspace(1)* [[BASE:%.*]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR2:%.*]] = bitcast i64 addrspace(1)* [[PTR1]] to i16 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR1_REMAT:%.*]] = bitcast i32 addrspace(1)* [[BASE_RELOCATED_CASTED]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR2_REMAT:%.*]] = bitcast i64 addrspace(1)* [[PTR1_REMAT]] to i16 addrspace(1)*
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj16(i16 addrspace(1)* [[PTR2_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr1 = bitcast i32 addrspace(1)* %base to i64 addrspace(1)*
  %ptr2 = bitcast i64 addrspace(1)* %ptr1 to i16 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj16(i16 addrspace(1)* %ptr2)
  ret void
}

define void @test_addrspacecast_addrspacecast(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_addrspacecast_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR1:%.*]] = addrspacecast i32 addrspace(1)* [[BASE:%.*]] to i32*
; CHECK-NEXT:    [[PTR2:%.*]] = addrspacecast i32* [[PTR1]] to i32 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[PTR2]], i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[PTR2_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[PTR2_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR2_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR2_RELOCATED_CASTED]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr1 = addrspacecast i32 addrspace(1)* %base to i32*
  %ptr2 = addrspacecast i32* %ptr1 to i32 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj32(i32 addrspace(1)* %ptr2)
  ret void
}

define void @test_bitcast_gep(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_bitcast_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR_CAST:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i64 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT]] to i64 addrspace(1)*
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[BASE_RELOCATED_CASTED]])
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr.cast = bitcast i32 addrspace(1)* %ptr.gep to i64 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj32(i32 addrspace(1)* %base)
  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  ret void
}

define void @test_intersecting_chains(i32 addrspace(1)* %base, i32 %idx) gc "statepoint-example" {
; CHECK-LABEL: @test_intersecting_chains(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR_CAST:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_CAST2:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i16 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT1:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT1]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST2_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT]] to i16 addrspace(1)*
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_REMAT]])
; CHECK-NEXT:    call void @use_obj16(i16 addrspace(1)* [[PTR_CAST2_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr.cast = bitcast i32 addrspace(1)* %ptr.gep to i64 addrspace(1)*
  %ptr.cast2 = bitcast i32 addrspace(1)* %ptr.gep to i16 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  call void @use_obj16(i16 addrspace(1)* %ptr.cast2)
  ret void
}

define void @test_cost_threshold(i32 addrspace(1)* %base, i32 %idx1, i32 %idx2, i32 %idx3) gc "statepoint-example" {
; CHECK-LABEL: @test_cost_threshold(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR_GEP2:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP]], i32 [[IDX1:%.*]]
; CHECK-NEXT:    [[PTR_GEP3:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP2]], i32 [[IDX2:%.*]]
; CHECK-NEXT:    [[PTR_GEP4:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP3]], i32 [[IDX3:%.*]]
; CHECK-NEXT:    [[PTR_CAST:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP4]] to i64 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i64 addrspace(1)* [[PTR_CAST]], i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[PTR_CAST_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[PTR_CAST_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_CAST_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_RELOCATED_CASTED]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr.gep2 = getelementptr i32, i32 addrspace(1)* %ptr.gep, i32 %idx1
  %ptr.gep3 = getelementptr i32, i32 addrspace(1)* %ptr.gep2, i32 %idx2
  %ptr.gep4 = getelementptr i32, i32 addrspace(1)* %ptr.gep3, i32 %idx3
  %ptr.cast = bitcast i32 addrspace(1)* %ptr.gep4 to i64 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  ret void
}

define void @test_two_derived(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_two_derived(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE]], i32 12
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR2_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 12
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_REMAT]])
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR2_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr2 = getelementptr i32, i32 addrspace(1)* %base, i32 12
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj32(i32 addrspace(1)* %ptr)
  call void @use_obj32(i32 addrspace(1)* %ptr2)
  ret void
}

define void @test_gep_smallint_array([3 x i32] addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_gep_smallint_array(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr [3 x i32], [3 x i32] addrspace(1)* [[BASE:%.*]], i32 0, i32 2
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"([3 x i32] addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to [3 x i32] addrspace(1)*
; CHECK-NEXT:    [[PTR_REMAT:%.*]] = getelementptr [3 x i32], [3 x i32] addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 0, i32 2
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr = getelementptr [3 x i32], [3 x i32] addrspace(1)* %base, i32 0, i32 2
  call void @do_safepoint() [ "deopt"() ]

  call void @use_obj32(i32 addrspace(1)* %ptr)
  ret void
}

declare i32 @fake_personality_function()

define void @test_invoke(i32 addrspace(1)* %base) gc "statepoint-example" personality i32 ()* @fake_personality_function {
; CHECK-LABEL: @test_invoke(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR_CAST:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_CAST2:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i16 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    to label [[NORMAL:%.*]] unwind label [[EXCEPTION:%.*]]
; CHECK:       normal:
; CHECK-NEXT:    [[BASE_RELOCATED6:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED6_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED6]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT3:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED6_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT3]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED6_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST2_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT]] to i16 addrspace(1)*
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_REMAT]])
; CHECK-NEXT:    call void @use_obj16(i16 addrspace(1)* [[PTR_CAST2_REMAT]])
; CHECK-NEXT:    ret void
; CHECK:       exception:
; CHECK-NEXT:    [[LANDING_PAD4:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[LANDING_PAD4]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT4:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST_REMAT5:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT4]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT1:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST2_REMAT2:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT1]] to i16 addrspace(1)*
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_REMAT5]])
; CHECK-NEXT:    call void @use_obj16(i16 addrspace(1)* [[PTR_CAST2_REMAT2]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr.cast = bitcast i32 addrspace(1)* %ptr.gep to i64 addrspace(1)*
  %ptr.cast2 = bitcast i32 addrspace(1)* %ptr.gep to i16 addrspace(1)*
  invoke void @do_safepoint() [ "deopt"() ]
  to label %normal unwind label %exception

normal:
  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  call void @use_obj16(i16 addrspace(1)* %ptr.cast2)
  ret void

exception:
  %landing_pad4 = landingpad token
  cleanup
  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  call void @use_obj16(i16 addrspace(1)* %ptr.cast2)
  ret void
}

define void @test_loop(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[DOT01:%.*]] = phi i32 addrspace(1)* [ [[PTR_GEP]], [[ENTRY:%.*]] ], [ [[PTR_GEP_REMAT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32 addrspace(1)* [ [[BASE]], [[ENTRY]] ], [ [[BASE_RELOCATED_CASTED:%.*]], [[LOOP]] ]
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[DOT01]])
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[DOT0]]) ]
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT]] = getelementptr i32, i32 addrspace(1)* [[BASE_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    br label [[LOOP]]
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  br label %loop

loop:                                             ; preds = %loop, %entry
  call void @use_obj32(i32 addrspace(1)* %ptr.gep)
  call void @do_safepoint() [ "deopt"() ]
  br label %loop
}

define void @test_too_long(i32 addrspace(1)* %base) gc "statepoint-example" {
; CHECK-LABEL: @test_too_long(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASE:%.*]], i32 15
; CHECK-NEXT:    [[PTR_GEP1:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP]], i32 15
; CHECK-NEXT:    [[PTR_GEP2:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP1]], i32 15
; CHECK-NEXT:    [[PTR_GEP3:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP2]], i32 15
; CHECK-NEXT:    [[PTR_GEP4:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP3]], i32 15
; CHECK-NEXT:    [[PTR_GEP5:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP4]], i32 15
; CHECK-NEXT:    [[PTR_GEP6:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP5]], i32 15
; CHECK-NEXT:    [[PTR_GEP7:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP6]], i32 15
; CHECK-NEXT:    [[PTR_GEP8:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP7]], i32 15
; CHECK-NEXT:    [[PTR_GEP9:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP8]], i32 15
; CHECK-NEXT:    [[PTR_GEP10:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP9]], i32 15
; CHECK-NEXT:    [[PTR_GEP11:%.*]] = getelementptr i32, i32 addrspace(1)* [[PTR_GEP10]], i32 15
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[PTR_GEP11]], i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    [[PTR_GEP11_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[PTR_GEP11_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_GEP11_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_GEP11_RELOCATED_CASTED]])
; CHECK-NEXT:    ret void
;
entry:
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %base, i32 15
  %ptr.gep1 = getelementptr i32, i32 addrspace(1)* %ptr.gep, i32 15
  %ptr.gep2 = getelementptr i32, i32 addrspace(1)* %ptr.gep1, i32 15
  %ptr.gep3 = getelementptr i32, i32 addrspace(1)* %ptr.gep2, i32 15
  %ptr.gep4 = getelementptr i32, i32 addrspace(1)* %ptr.gep3, i32 15
  %ptr.gep5 = getelementptr i32, i32 addrspace(1)* %ptr.gep4, i32 15
  %ptr.gep6 = getelementptr i32, i32 addrspace(1)* %ptr.gep5, i32 15
  %ptr.gep7 = getelementptr i32, i32 addrspace(1)* %ptr.gep6, i32 15
  %ptr.gep8 = getelementptr i32, i32 addrspace(1)* %ptr.gep7, i32 15
  %ptr.gep9 = getelementptr i32, i32 addrspace(1)* %ptr.gep8, i32 15
  %ptr.gep10 = getelementptr i32, i32 addrspace(1)* %ptr.gep9, i32 15
  %ptr.gep11 = getelementptr i32, i32 addrspace(1)* %ptr.gep10, i32 15
  call void @do_safepoint() [ "deopt"() ]
  call void @use_obj32(i32 addrspace(1)* %ptr.gep11)
  ret void
}


declare i32 addrspace(1)* @new_instance() nounwind "gc-leaf-function"

; remat the gep in presence of base pointer which is a phi node.
; FIXME: We should remove the extra basephi.base as well.
define void @contains_basephi(i1 %cond) gc "statepoint-example" {
; CHECK-LABEL: @contains_basephi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE1:%.*]] = call i32 addrspace(1)* @new_instance()
; CHECK-NEXT:    [[BASE2:%.*]] = call i32 addrspace(1)* @new_instance()
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[HERE:%.*]], label [[THERE:%.*]]
; CHECK:       here:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       there:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[BASEPHI:%.*]] = phi i32 addrspace(1)* [ [[BASE1]], [[HERE]] ], [ [[BASE2]], [[THERE]] ]
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASEPHI]], i32 15
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASEPHI]]) ]
; CHECK-NEXT:    [[BASEPHI_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASEPHI_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASEPHI_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASEPHI_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    call void @use_obj32(i32 addrspace(1)* [[PTR_GEP_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %base1 = call i32 addrspace(1)* @new_instance()
  %base2 = call i32 addrspace(1)* @new_instance()
  br i1 %cond, label %here, label %there

here:
  br label %merge

there:
  br label %merge

merge:



  %basephi = phi i32 addrspace(1)* [ %base1, %here ], [ %base2, %there ]
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %basephi, i32 15
  call void @do_safepoint() ["deopt"() ]
  call void @use_obj32(i32 addrspace(1)* %ptr.gep)
  ret void
}


define void @test_intersecting_chains_with_phi(i1 %cond) gc "statepoint-example" {
; CHECK-LABEL: @test_intersecting_chains_with_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE1:%.*]] = call i32 addrspace(1)* @new_instance()
; CHECK-NEXT:    [[BASE2:%.*]] = call i32 addrspace(1)* @new_instance()
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[HERE:%.*]], label [[THERE:%.*]]
; CHECK:       here:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       there:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[BASEPHI:%.*]] = phi i32 addrspace(1)* [ [[BASE1]], [[HERE]] ], [ [[BASE2]], [[THERE]] ]
; CHECK-NEXT:    [[PTR_GEP:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASEPHI]], i32 15
; CHECK-NEXT:    [[PTR_CAST:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_CAST2:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP]] to i16 addrspace(1)*
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i32 addrspace(1)* [[BASEPHI]]) ]
; CHECK-NEXT:    [[BASEPHI_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[BASEPHI_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[BASEPHI_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT1:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASEPHI_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT1]] to i64 addrspace(1)*
; CHECK-NEXT:    [[PTR_GEP_REMAT:%.*]] = getelementptr i32, i32 addrspace(1)* [[BASEPHI_RELOCATED_CASTED]], i32 15
; CHECK-NEXT:    [[PTR_CAST2_REMAT:%.*]] = bitcast i32 addrspace(1)* [[PTR_GEP_REMAT]] to i16 addrspace(1)*
; CHECK-NEXT:    call void @use_obj64(i64 addrspace(1)* [[PTR_CAST_REMAT]])
; CHECK-NEXT:    call void @use_obj16(i16 addrspace(1)* [[PTR_CAST2_REMAT]])
; CHECK-NEXT:    ret void
;
entry:
  %base1 = call i32 addrspace(1)* @new_instance()
  %base2 = call i32 addrspace(1)* @new_instance()
  br i1 %cond, label %here, label %there

here:
  br label %merge

there:
  br label %merge

merge:
  %basephi = phi i32 addrspace(1)* [ %base1, %here ], [ %base2, %there ]
  %ptr.gep = getelementptr i32, i32 addrspace(1)* %basephi, i32 15
  %ptr.cast = bitcast i32 addrspace(1)* %ptr.gep to i64 addrspace(1)*
  %ptr.cast2 = bitcast i32 addrspace(1)* %ptr.gep to i16 addrspace(1)*
  call void @do_safepoint() [ "deopt"() ]
  call void @use_obj64(i64 addrspace(1)* %ptr.cast)
  call void @use_obj16(i16 addrspace(1)* %ptr.cast2)
  ret void
}
