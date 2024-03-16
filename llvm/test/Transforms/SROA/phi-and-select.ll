; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

define i32 @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i32 0, 1
; CHECK-NEXT:    br i1 [[COND]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_SROA_SPECULATED:%.*]] = phi i32 [ 1, [[THEN]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_SPECULATED]]
;
entry:
  %a = alloca [2 x i32]

  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1
  %v0 = load i32, i32* %a0
  %v1 = load i32, i32* %a1

  %cond = icmp sle i32 %v0, %v1
  br i1 %cond, label %then, label %exit

then:
  br label %exit

exit:
  %phi = phi i32* [ %a1, %then ], [ %a0, %entry ]

  %result = load i32, i32* %phi
  ret i32 %result
}

define i32 @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i32 0, 1
; CHECK-NEXT:    [[RESULT_SROA_SPECULATED:%.*]] = select i1 [[COND]], i32 1, i32 0
; CHECK-NEXT:    ret i32 [[RESULT_SROA_SPECULATED]]
;
entry:
  %a = alloca [2 x i32]

  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1
  %v0 = load i32, i32* %a0
  %v1 = load i32, i32* %a1

  %cond = icmp sle i32 %v0, %v1
  %select = select i1 %cond, i32* %a1, i32* %a0

  %result = load i32, i32* %select
  ret i32 %result
}

define float @test2_bitcast() {
; CHECK-LABEL: @test2_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i32 0, 1
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 1 to float
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 0 to float
; CHECK-NEXT:    [[RESULT_SROA_SPECULATED:%.*]] = select i1 [[COND]], float [[TMP0]], float [[TMP1]]
; CHECK-NEXT:    ret float [[RESULT_SROA_SPECULATED]]
;
entry:
  %a = alloca [2 x i32]
  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1
  %v0 = load i32, i32* %a0
  %v1 = load i32, i32* %a1
  %cond = icmp sle i32 %v0, %v1
  %select = select i1 %cond, i32* %a1, i32* %a0
  %select.bc = bitcast i32* %select to float*
  %result = load float, float* %select.bc
  ret float %result
}

define i32 @test2_addrspacecast() {
; CHECK-LABEL: @test2_addrspacecast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_SROA_0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A_SROA_3:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 0, i32* [[A_SROA_0]], align 4
; CHECK-NEXT:    store i32 1, i32* [[A_SROA_3]], align 4
; CHECK-NEXT:    [[A_SROA_0_0_A_SROA_0_0_V0:%.*]] = load i32, i32* [[A_SROA_0]], align 4
; CHECK-NEXT:    [[A_SROA_3_0_A_SROA_3_4_V1:%.*]] = load i32, i32* [[A_SROA_3]], align 4
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i32 [[A_SROA_0_0_A_SROA_0_0_V0]], [[A_SROA_3_0_A_SROA_3_4_V1]]
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[COND]], i32* [[A_SROA_3]], i32* [[A_SROA_0]]
; CHECK-NEXT:    [[SELECT_ASC:%.*]] = addrspacecast i32* [[SELECT]] to i32 addrspace(1)*
; CHECK-NEXT:    [[RESULT:%.*]] = load i32, i32 addrspace(1)* [[SELECT_ASC]], align 4
; CHECK-NEXT:    ret i32 [[RESULT]]
;
entry:
  %a = alloca [2 x i32]
  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1
  %v0 = load i32, i32* %a0
  %v1 = load i32, i32* %a1
  %cond = icmp sle i32 %v0, %v1
  %select = select i1 %cond, i32* %a1, i32* %a0
  %select.asc = addrspacecast i32* %select to i32 addrspace(1)*
  %result = load i32, i32 addrspace(1)* %select.asc
  ret i32 %result
}

define i32 @test3(i32 %x) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[BB0:%.*]] [
; CHECK-NEXT:    i32 1, label [[BB1:%.*]]
; CHECK-NEXT:    i32 2, label [[BB2:%.*]]
; CHECK-NEXT:    i32 3, label [[BB3:%.*]]
; CHECK-NEXT:    i32 4, label [[BB4:%.*]]
; CHECK-NEXT:    i32 5, label [[BB5:%.*]]
; CHECK-NEXT:    i32 6, label [[BB6:%.*]]
; CHECK-NEXT:    i32 7, label [[BB7:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb0:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb4:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb5:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb6:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       bb7:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_SROA_SPECULATED:%.*]] = phi i32 [ 1, [[BB0]] ], [ 0, [[BB1]] ], [ 0, [[BB2]] ], [ 1, [[BB3]] ], [ 1, [[BB4]] ], [ 0, [[BB5]] ], [ 0, [[BB6]] ], [ 1, [[BB7]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_SPECULATED]]
;
entry:
  %a = alloca [2 x i32]

  ; Note that we build redundant GEPs here to ensure that having different GEPs
  ; into the same alloca partation continues to work with PHI speculation. This
  ; was the underlying cause of PR13926.
  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a0b = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  %a1b = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1

  switch i32 %x, label %bb0 [ i32 1, label %bb1
  i32 2, label %bb2
  i32 3, label %bb3
  i32 4, label %bb4
  i32 5, label %bb5
  i32 6, label %bb6
  i32 7, label %bb7 ]

bb0:
  br label %exit
bb1:
  br label %exit
bb2:
  br label %exit
bb3:
  br label %exit
bb4:
  br label %exit
bb5:
  br label %exit
bb6:
  br label %exit
bb7:
  br label %exit

exit:
  %phi = phi i32* [ %a1, %bb0 ], [ %a0, %bb1 ], [ %a0, %bb2 ], [ %a1, %bb3 ],
  [ %a1b, %bb4 ], [ %a0b, %bb5 ], [ %a0b, %bb6 ], [ %a1b, %bb7 ]

  %result = load i32, i32* %phi
  ret i32 %result
}

define i32 @test4() {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 0
;
entry:
  %a = alloca [2 x i32]

  %a0 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 0
  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 0, i32* %a0
  store i32 1, i32* %a1
  %v0 = load i32, i32* %a0
  %v1 = load i32, i32* %a1

  %cond = icmp sle i32 %v0, %v1
  %select = select i1 %cond, i32* %a0, i32* %a0

  %result = load i32, i32* %select
  ret i32 %result
}

define i32 @test5(i32* %b) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 1
;
entry:
  %a = alloca [2 x i32]

  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 1, i32* %a1

  %select = select i1 true, i32* %a1, i32* %b

  %result = load i32, i32* %select

  ret i32 %result
}

declare void @f(i32*, i32*)

define i32 @test6(i32* %b) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 false, i32* poison, i32* [[B:%.*]]
; CHECK-NEXT:    [[SELECT3:%.*]] = select i1 false, i32* poison, i32* [[B]]
; CHECK-NEXT:    call void @f(i32* [[SELECT2]], i32* [[SELECT3]])
; CHECK-NEXT:    ret i32 1
;
entry:
  %a = alloca [2 x i32]
  %c = alloca i32

  %a1 = getelementptr [2 x i32], [2 x i32]* %a, i64 0, i32 1
  store i32 1, i32* %a1

  %select = select i1 true, i32* %a1, i32* %b
  %select2 = select i1 false, i32* %a1, i32* %b
  %select3 = select i1 false, i32* %c, i32* %b

  ; Note, this would potentially escape the alloca pointer except for the
  ; constant folding of the select.
  call void @f(i32* %select2, i32* %select3)


  %result = load i32, i32* %select

  %dead = load i32, i32* %c

  ret i32 %result
}

define i32 @test7() {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[GOOD:%.*]], label [[BAD:%.*]]
; CHECK:       good:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       bad:
; CHECK-NEXT:    [[P_SROA_SPECULATE_LOAD_BAD:%.*]] = load i32, i32* poison, align 4
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[P_SROA_SPECULATED:%.*]] = phi i32 [ 0, [[GOOD]] ], [ [[P_SROA_SPECULATE_LOAD_BAD]], [[BAD]] ]
; CHECK-NEXT:    ret i32 [[P_SROA_SPECULATED]]
;

entry:
  %X = alloca i32
  br i1 undef, label %good, label %bad

good:
  %Y1 = getelementptr i32, i32* %X, i64 0
  store i32 0, i32* %Y1
  br label %exit

bad:
  %Y2 = getelementptr i32, i32* %X, i64 1
  store i32 0, i32* %Y2
  br label %exit

exit:
  %P = phi i32* [ %Y1, %good ], [ %Y2, %bad ]
  %Z2 = load i32, i32* %P
  ret i32 %Z2
}

define i32 @test8(i32 %b, i32* %ptr) {
; Ensure that we rewrite allocas to the used type when that use is hidden by
; a PHI that can be speculated.
; CHECK-LABEL: @test8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TEST:%.*]] = icmp ne i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[TEST]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[PHI_SROA_SPECULATE_LOAD_THEN:%.*]] = load i32, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_SROA_SPECULATED:%.*]] = phi i32 [ undef, [[ELSE]] ], [ [[PHI_SROA_SPECULATE_LOAD_THEN]], [[THEN]] ]
; CHECK-NEXT:    ret i32 [[PHI_SROA_SPECULATED]]
;

entry:
  %f = alloca float
  %test = icmp ne i32 %b, 0
  br i1 %test, label %then, label %else

then:
  br label %exit

else:
  %bitcast = bitcast float* %f to i32*
  br label %exit

exit:
  %phi = phi i32* [ %bitcast, %else ], [ %ptr, %then ]
  %loaded = load i32, i32* %phi, align 4
  ret i32 %loaded
}

define i32 @test9(i32 %b, i32* %ptr) {
; Same as @test8 but for a select rather than a PHI node.
; CHECK-LABEL: @test9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[PTR:%.*]], align 4
; CHECK-NEXT:    [[TEST:%.*]] = icmp ne i32 [[B:%.*]], 0
; CHECK-NEXT:    [[LOADED_SROA_SPECULATE_LOAD_FALSE:%.*]] = load i32, i32* [[PTR]], align 4
; CHECK-NEXT:    [[LOADED_SROA_SPECULATED:%.*]] = select i1 [[TEST]], i32 undef, i32 [[LOADED_SROA_SPECULATE_LOAD_FALSE]]
; CHECK-NEXT:    ret i32 [[LOADED_SROA_SPECULATED]]
;

entry:
  %f = alloca float
  store i32 0, i32* %ptr
  %test = icmp ne i32 %b, 0
  %bitcast = bitcast float* %f to i32*
  %select = select i1 %test, i32* %bitcast, i32* %ptr
  %loaded = load i32, i32* %select, align 4
  ret i32 %loaded
}

define float @test10(i32 %b, float* %ptr) {
; Don't try to promote allocas which are not elligible for it even after
; rewriting due to the necessity of inserting bitcasts when speculating a PHI
; node.
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[F:%.*]] = alloca double, align 8
; CHECK-NEXT:    store double 0.000000e+00, double* [[F]], align 8
; CHECK-NEXT:    [[TEST:%.*]] = icmp ne i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[TEST]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[PHI_SROA_SPECULATE_LOAD_THEN:%.*]] = load float, float* [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[F_0_F_0_BITCAST_SROA_CAST:%.*]] = bitcast double* [[F]] to float*
; CHECK-NEXT:    [[F_0_PHI_SROA_SPECULATE_LOAD_ELSE:%.*]] = load float, float* [[F_0_F_0_BITCAST_SROA_CAST]], align 8
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI_SROA_SPECULATED:%.*]] = phi float [ [[F_0_PHI_SROA_SPECULATE_LOAD_ELSE]], [[ELSE]] ], [ [[PHI_SROA_SPECULATE_LOAD_THEN]], [[THEN]] ]
; CHECK-NEXT:    ret float [[PHI_SROA_SPECULATED]]
;

entry:
  %f = alloca double
  store double 0.0, double* %f
  %test = icmp ne i32 %b, 0
  br i1 %test, label %then, label %else

then:
  br label %exit

else:
  %bitcast = bitcast double* %f to float*
  br label %exit

exit:
  %phi = phi float* [ %bitcast, %else ], [ %ptr, %then ]
  %loaded = load float, float* %phi, align 4
  ret float %loaded
}

define float @test11(i32 %b, float* %ptr) {
; Same as @test10 but for a select rather than a PHI node.
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[F:%.*]] = alloca double, align 8
; CHECK-NEXT:    store double 0.000000e+00, double* [[F]], align 8
; CHECK-NEXT:    store float 0.000000e+00, float* [[PTR:%.*]], align 4
; CHECK-NEXT:    [[TEST:%.*]] = icmp ne i32 [[B:%.*]], 0
; CHECK-NEXT:    [[F_0_F_0_BITCAST_SROA_CAST:%.*]] = bitcast double* [[F]] to float*
; CHECK-NEXT:    [[F_0_LOADED_SROA_SPECULATE_LOAD_TRUE:%.*]] = load float, float* [[F_0_F_0_BITCAST_SROA_CAST]], align 8
; CHECK-NEXT:    [[LOADED_SROA_SPECULATE_LOAD_FALSE:%.*]] = load float, float* [[PTR]], align 4
; CHECK-NEXT:    [[LOADED_SROA_SPECULATED:%.*]] = select i1 [[TEST]], float [[F_0_LOADED_SROA_SPECULATE_LOAD_TRUE]], float [[LOADED_SROA_SPECULATE_LOAD_FALSE]]
; CHECK-NEXT:    ret float [[LOADED_SROA_SPECULATED]]
;

entry:
  %f = alloca double
  store double 0.0, double* %f
  store float 0.0, float* %ptr
  %test = icmp ne i32 %b, 0
  %bitcast = bitcast double* %f to float*
  %select = select i1 %test, float* %bitcast, float* %ptr
  %loaded = load float, float* %select, align 4
  ret float %loaded
}

define i32 @test12(i32 %x, i32* %p) {
; Ensure we don't crash or fail to nuke dead selects of allocas if no load is
; never found.
; CHECK-LABEL: @test12(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret i32 [[X:%.*]]
;

entry:
  %a = alloca i32
  store i32 %x, i32* %a
  %dead = select i1 undef, i32* %a, i32* %p
  %load = load i32, i32* %a
  ret i32 %load
}

define i32 @test13(i32 %x, i32* %p) {
; Ensure we don't crash or fail to nuke dead phis of allocas if no load is ever
; found.
; CHECK-LABEL: @test13(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    br i1 undef, label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 [[X:%.*]]
;

entry:
  %a = alloca i32
  store i32 %x, i32* %a
  br label %loop

loop:
  %phi = phi i32* [ %p, %entry ], [ %a, %loop ]
  br i1 undef, label %loop, label %exit

exit:
  %load = load i32, i32* %a
  ret i32 %load
}

define i32 @test14(i1 %b1, i1 %b2, i32* %ptr) {
; Check for problems when there are both selects and phis and one is
; speculatable toward promotion but the other is not. That should block all of
; the speculation.
; CHECK-LABEL: @test14(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[F:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[G:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 0, i32* [[F]], align 4
; CHECK-NEXT:    store i32 0, i32* [[G]], align 4
; CHECK-NEXT:    [[F_SELECT:%.*]] = select i1 [[B1:%.*]], i32* [[F]], i32* [[PTR:%.*]]
; CHECK-NEXT:    br i1 [[B2:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[F_PHI:%.*]] = phi i32* [ [[F]], [[THEN]] ], [ [[F_SELECT]], [[ELSE]] ]
; CHECK-NEXT:    [[G_PHI:%.*]] = phi i32* [ [[G]], [[THEN]] ], [ [[PTR]], [[ELSE]] ]
; CHECK-NEXT:    [[F_LOADED:%.*]] = load i32, i32* [[F_PHI]], align 4
; CHECK-NEXT:    [[G_SELECT:%.*]] = select i1 [[B1]], i32* [[G]], i32* [[G_PHI]]
; CHECK-NEXT:    [[G_LOADED:%.*]] = load i32, i32* [[G_SELECT]], align 4
; CHECK-NEXT:    [[RESULT:%.*]] = add i32 [[F_LOADED]], [[G_LOADED]]
; CHECK-NEXT:    ret i32 [[RESULT]]
;

entry:
  %f = alloca i32
  %g = alloca i32
  store i32 0, i32* %f
  store i32 0, i32* %g
  %f.select = select i1 %b1, i32* %f, i32* %ptr
  br i1 %b2, label %then, label %else

then:
  br label %exit

else:
  br label %exit

exit:
  %f.phi = phi i32* [ %f, %then ], [ %f.select, %else ]
  %g.phi = phi i32* [ %g, %then ], [ %ptr, %else ]
  %f.loaded = load i32, i32* %f.phi
  %g.select = select i1 %b1, i32* %g, i32* %g.phi
  %g.loaded = load i32, i32* %g.select
  %result = add i32 %f.loaded, %g.loaded
  ret i32 %result
}

define i32 @PR13905() {
; Check a pattern where we have a chain of dead phi nodes to ensure they are
; deleted and promotion can proceed.
; CHECK-LABEL: @PR13905(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[LOOP1:%.*]], label [[EXIT:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br i1 undef, label [[LOOP1]], label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    br i1 undef, label [[LOOP1]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI2:%.*]] = phi i32* [ poison, [[LOOP2]] ], [ null, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 undef
;

entry:
  %h = alloca i32
  store i32 0, i32* %h
  br i1 undef, label %loop1, label %exit

loop1:
  %phi1 = phi i32* [ null, %entry ], [ %h, %loop1 ], [ %h, %loop2 ]
  br i1 undef, label %loop1, label %loop2

loop2:
  br i1 undef, label %loop1, label %exit

exit:
  %phi2 = phi i32* [ %phi1, %loop2 ], [ null, %entry ]
  ret i32 undef
}

define i32 @PR13906() {
; Another pattern which can lead to crashes due to failing to clear out dead
; PHI nodes or select nodes. This triggers subtly differently from the above
; cases because the PHI node is (recursively) alive, but the select is dead.
; CHECK-LABEL: @PR13906(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br i1 undef, label [[IF_THEN:%.*]], label [[FOR_COND]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[FOR_COND]]
;

entry:
  %c = alloca i32
  store i32 0, i32* %c
  br label %for.cond

for.cond:
  %d.0 = phi i32* [ undef, %entry ], [ %c, %if.then ], [ %d.0, %for.cond ]
  br i1 undef, label %if.then, label %for.cond

if.then:
  %tmpcast.d.0 = select i1 undef, i32* %c, i32* %d.0
  br label %for.cond
}

define i64 @PR14132(i1 %flag) {
; CHECK-LABEL: @PR14132(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[FLAG:%.*]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[B_0_LOAD_EXT:%.*]] = zext i8 1 to i64
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[PTR_0_SROA_SPECULATED:%.*]] = phi i64 [ [[B_0_LOAD_EXT]], [[IF_THEN]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i64 [[PTR_0_SROA_SPECULATED]]
;
; Here we form a PHI-node by promoting the pointer alloca first, and then in
; order to promote the other two allocas, we speculate the load of the
; now-phi-node-pointer. In doing so we end up loading a 64-bit value from an i8
; alloca. While this is a bit dubious, we were asserting on trying to
; rewrite it. The trick is that the code using the value may carefully take
; steps to only use the not-undef bits, and so we need to at least loosely
; support this..
entry:
  %a = alloca i64, align 8
  %b = alloca i8, align 8
  %ptr = alloca i64*, align 8

  %ptr.cast = bitcast i64** %ptr to i8**
  store i64 0, i64* %a, align 8
  store i8 1, i8* %b, align 8
  store i64* %a, i64** %ptr, align 8
  br i1 %flag, label %if.then, label %if.end

if.then:
  store i8* %b, i8** %ptr.cast, align 8
  br label %if.end

if.end:
  %tmp = load i64*, i64** %ptr, align 8
  %result = load i64, i64* %tmp, align 8

  ret i64 %result
}

define float @PR16687(i64 %x, i1 %flag) {
; CHECK-LABEL: @PR16687(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[X:%.*]] to i32
; CHECK-NEXT:    [[A_SROA_2_0_EXTRACT_SHIFT:%.*]] = lshr i64 [[X]], 32
; CHECK-NEXT:    [[A_SROA_2_0_EXTRACT_TRUNC:%.*]] = trunc i64 [[A_SROA_2_0_EXTRACT_SHIFT]] to i32
; CHECK-NEXT:    br i1 [[FLAG:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32 [[A_SROA_0_0_EXTRACT_TRUNC]] to float
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32 [[A_SROA_2_0_EXTRACT_TRUNC]] to float
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[A_PHI_F_SROA_SPECULATED:%.*]] = phi float [ [[TMP0]], [[THEN]] ], [ [[TMP1]], [[ELSE]] ]
; CHECK-NEXT:    ret float [[A_PHI_F_SROA_SPECULATED]]
;
; Check that even when we try to speculate the same phi twice (in two slices)
; on an otherwise promotable construct, we don't get ahead of ourselves and try
; to promote one of the slices prior to speculating it.

entry:
  %a = alloca i64, align 8
  store i64 %x, i64* %a
  br i1 %flag, label %then, label %else

then:
  %a.f = bitcast i64* %a to float*
  br label %end

else:
  %a.raw = bitcast i64* %a to i8*
  %a.raw.4 = getelementptr i8, i8* %a.raw, i64 4
  %a.raw.4.f = bitcast i8* %a.raw.4 to float*
  br label %end

end:
  %a.phi.f = phi float* [ %a.f, %then ], [ %a.raw.4.f, %else ]
  %f = load float, float* %a.phi.f
  ret float %f
}

; Verifies we fixed PR20425. We should be able to promote all alloca's to
; registers in this test.
;
; %0 = slice
; %1 = slice
; %2 = phi(%0, %1) // == slice
define float @simplify_phi_nodes_that_equal_slice(i1 %cond, float* %temp) {
; CHECK-LABEL: @simplify_phi_nodes_that_equal_slice(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[ARR_SROA_0_0:%.*]] = phi float [ 1.000000e+00, [[THEN]] ], [ 2.000000e+00, [[ELSE]] ]
; CHECK-NEXT:    store float 0.000000e+00, float* [[TEMP:%.*]], align 4
; CHECK-NEXT:    ret float [[ARR_SROA_0_0]]
;
entry:
  %arr = alloca [4 x float], align 4
  br i1 %cond, label %then, label %else

then:
  %0 = getelementptr inbounds [4 x float], [4 x float]* %arr, i64 0, i64 3
  store float 1.000000e+00, float* %0, align 4
  br label %merge

else:
  %1 = getelementptr inbounds [4 x float], [4 x float]* %arr, i64 0, i64 3
  store float 2.000000e+00, float* %1, align 4
  br label %merge

merge:
  %2 = phi float* [ %0, %then ], [ %1, %else ]
  store float 0.000000e+00, float* %temp, align 4
  %3 = load float, float* %2, align 4
  ret float %3
}

; A slightly complicated example for PR20425.
;
; %0 = slice
; %1 = phi(%0) // == slice
; %2 = slice
; %3 = phi(%1, %2) // == slice
define float @simplify_phi_nodes_that_equal_slice_2(i1 %cond, float* %temp) {
; CHECK-LABEL: @simplify_phi_nodes_that_equal_slice_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[THEN2:%.*]]
; CHECK:       then2:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[ARR_SROA_0_0:%.*]] = phi float [ 2.000000e+00, [[THEN2]] ], [ 3.000000e+00, [[ELSE]] ]
; CHECK-NEXT:    store float 0.000000e+00, float* [[TEMP:%.*]], align 4
; CHECK-NEXT:    ret float [[ARR_SROA_0_0]]
;
entry:
  %arr = alloca [4 x float], align 4
  br i1 %cond, label %then, label %else

then:
  %0 = getelementptr inbounds [4 x float], [4 x float]* %arr, i64 0, i64 3
  store float 1.000000e+00, float* %0, align 4
  br label %then2

then2:
  %1 = phi float* [ %0, %then ]
  store float 2.000000e+00, float* %1, align 4
  br label %merge

else:
  %2 = getelementptr inbounds [4 x float], [4 x float]* %arr, i64 0, i64 3
  store float 3.000000e+00, float* %2, align 4
  br label %merge

merge:
  %3 = phi float* [ %1, %then2 ], [ %2, %else ]
  store float 0.000000e+00, float* %temp, align 4
  %4 = load float, float* %3, align 4
  ret float %4
}

%struct.S = type { i32 }

; Verifies we fixed PR20822. We have a foldable PHI feeding a speculatable PHI
; which requires the rewriting of the speculated PHI to handle insertion
; when the incoming pointer is itself from a PHI node. We would previously
; insert a bitcast instruction *before* a PHI, producing an invalid module;
; make sure we insert *after* the first non-PHI instruction.
define void @PR20822() {
; CHECK-LABEL: @PR20822(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[F_SROA_0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 undef, label [[IF_END:%.*]], label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ undef, [[ENTRY:%.*]] ], [ undef, [[FOR_COND]] ]
; CHECK-NEXT:    [[F_SROA_0_0_F2_SROA_CAST1:%.*]] = bitcast i32* [[F_SROA_0]] to %struct.S*
; CHECK-NEXT:    br i1 undef, label [[IF_THEN5:%.*]], label [[IF_THEN2:%.*]]
; CHECK:       if.then2:
; CHECK-NEXT:    br label [[IF_THEN5]]
; CHECK:       if.then5:
; CHECK-NEXT:    [[F1:%.*]] = phi %struct.S* [ undef, [[IF_THEN2]] ], [ [[F_SROA_0_0_F2_SROA_CAST1]], [[IF_END]] ]
; CHECK-NEXT:    [[DOTFCA_0_GEP:%.*]] = getelementptr inbounds [[STRUCT_S:%.*]], %struct.S* [[F1]], i32 0, i32 0
; CHECK-NEXT:    store i32 undef, i32* [[DOTFCA_0_GEP]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %f = alloca %struct.S, align 4
  br i1 undef, label %if.end, label %for.cond

for.cond:                                         ; preds = %for.cond, %entry
  br label %if.end

if.end:                                           ; preds = %for.cond, %entry
  %f2 = phi %struct.S* [ %f, %entry ], [ %f, %for.cond ]
  phi i32 [ undef, %entry ], [ undef, %for.cond ]
  br i1 undef, label %if.then5, label %if.then2

if.then2:                                         ; preds = %if.end
  br label %if.then5

if.then5:                                         ; preds = %if.then2, %if.end
  %f1 = phi %struct.S* [ undef, %if.then2 ], [ %f2, %if.end ]
  store %struct.S undef, %struct.S* %f1, align 4
  ret void
}

define i32 @phi_align(i32* %z) {
; CHECK-LABEL: @phi_align(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_SROA_0:%.*]] = alloca [7 x i8], align 1
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_IDX:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* [[A_SROA_0]], i64 0, i64 3
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_CAST:%.*]] = bitcast i8* [[A_SROA_0_3_A1_SROA_IDX]] to i32*
; CHECK-NEXT:    [[A_SROA_0_0_A0_SROA_CAST:%.*]] = bitcast [7 x i8]* [[A_SROA_0]] to i32*
; CHECK-NEXT:    store i32 0, i32* [[A_SROA_0_0_A0_SROA_CAST]], align 1
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_IDX7:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* [[A_SROA_0]], i64 0, i64 3
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_CAST8:%.*]] = bitcast i8* [[A_SROA_0_3_A1_SROA_IDX7]] to i32*
; CHECK-NEXT:    store i32 1, i32* [[A_SROA_0_3_A1_SROA_CAST8]], align 1
; CHECK-NEXT:    [[A_SROA_0_0_A0_SROA_CAST6:%.*]] = bitcast [7 x i8]* [[A_SROA_0]] to i32*
; CHECK-NEXT:    [[A_SROA_0_0_A_SROA_0_1_V0:%.*]] = load i32, i32* [[A_SROA_0_0_A0_SROA_CAST6]], align 1
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_IDX9:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* [[A_SROA_0]], i64 0, i64 3
; CHECK-NEXT:    [[A_SROA_0_3_A1_SROA_CAST10:%.*]] = bitcast i8* [[A_SROA_0_3_A1_SROA_IDX9]] to i32*
; CHECK-NEXT:    [[A_SROA_0_3_A_SROA_0_4_V1:%.*]] = load i32, i32* [[A_SROA_0_3_A1_SROA_CAST10]], align 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i32 [[A_SROA_0_0_A_SROA_0_1_V0]], [[A_SROA_0_3_A_SROA_0_4_V1]]
; CHECK-NEXT:    br i1 [[COND]], label [[THEN:%.*]], label [[EXIT:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32* [ [[A_SROA_0_3_A1_SROA_CAST]], [[THEN]] ], [ [[Z:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[RESULT:%.*]] = load i32, i32* [[PHI]], align 1
; CHECK-NEXT:    ret i32 [[RESULT]]
;
entry:
  %a = alloca [8 x i8], align 8

  %a0x = getelementptr [8 x i8], [8 x i8]* %a, i64 0, i32 1
  %a0 = bitcast i8* %a0x to i32*
  %a1x = getelementptr [8 x i8], [8 x i8]* %a, i64 0, i32 4
  %a1 = bitcast i8* %a1x to i32*
  store i32 0, i32* %a0, align 1
  store i32 1, i32* %a1, align 4
  %v0 = load i32, i32* %a0, align 1
  %v1 = load i32, i32* %a1, align 4
  %cond = icmp sle i32 %v0, %v1
  br i1 %cond, label %then, label %exit

then:
  br label %exit

exit:
  %phi = phi i32* [ %a1, %then ], [ %z, %entry ]
  %result = load i32, i32* %phi, align 4
  ret i32 %result
}

; Don't speculate a load based on an earlier volatile operation.
define i8 @volatile_select(i8* %p, i1 %b) {
; CHECK-LABEL: @volatile_select(
; CHECK-NEXT:    [[P2:%.*]] = alloca i8, align 1
; CHECK-NEXT:    store i8 0, i8* [[P2]], align 1
; CHECK-NEXT:    store volatile i8 0, i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[PX:%.*]] = select i1 [[B:%.*]], i8* [[P]], i8* [[P2]]
; CHECK-NEXT:    [[V2:%.*]] = load i8, i8* [[PX]], align 1
; CHECK-NEXT:    ret i8 [[V2]]
;
  %p2 = alloca i8
  store i8 0, i8* %p2
  store volatile i8 0, i8* %p
  %px = select i1 %b, i8* %p, i8* %p2
  %v2 = load i8, i8* %px
  ret i8 %v2
}
