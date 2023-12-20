; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 -fp-contract=fast < %s | FileCheck -check-prefix=GFX9-CONTRACT %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX9-DENORM %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -fp-contract=fast < %s | FileCheck -check-prefix=GFX10-CONTRACT %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 --denormal-fp-math=preserve-sign < %s | FileCheck -check-prefix=GFX10-DENORM %s

; fold (fsub (fmul x, y), z) -> (fma x, y, (fneg z))
; fold (fsub x, (fmul y, z)) -> (fma (fneg y), z, x)

define float @test_f32_sub_mul(float %x, float %y, float %z) {
; GFX9-LABEL: test_f32_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f32_e32 v0, v0, v1
; GFX9-NEXT:    v_sub_f32_e32 v0, v0, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_f32_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_f32_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_f32 v0, v0, v1, -v2
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_f32_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f32_e32 v0, v0, v1
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_f32_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f32 v0, v0, v1, -v2
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_f32_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mad_f32 v0, v0, v1, -v2
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul float %x, %y
  %b = fsub float %a, %z
  ret float %b
}

define float @test_f32_sub_mul_rhs(float %x, float %y, float %z) {
; GFX9-LABEL: test_f32_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f32_e32 v0, v0, v1
; GFX9-NEXT:    v_sub_f32_e32 v0, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_f32_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f32 v0, -v0, v1, v2
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_f32_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_f32 v0, -v0, v1, v2
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_f32_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f32_e32 v0, v0, v1
; GFX10-NEXT:    v_sub_f32_e32 v0, v2, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_f32_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f32 v0, -v0, v1, v2
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_f32_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mad_f32 v0, -v0, v1, v2
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul float %x, %y
  %b = fsub float %z, %a
  ret float %b
}

define half @test_half_sub_mul(half %x, half %y, half %z) {
; GFX9-LABEL: test_half_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f16_e32 v0, v0, v1
; GFX9-NEXT:    v_add_f16_e64 v0, v0, -v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_half_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_xor_b32_e32 v2, 0x8000, v2
; GFX9-CONTRACT-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_half_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_legacy_f16 v0, v0, v1, -v2
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_half_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f16_e32 v0, v0, v1
; GFX10-NEXT:    v_add_f16_e64 v0, v0, -v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_half_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_xor_b32_e32 v2, 0x8000, v2
; GFX10-CONTRACT-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_half_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f16_e32 v0, v0, v1
; GFX10-DENORM-NEXT:    v_add_f16_e64 v0, v0, -v2
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul half %x, %y
  %b = fsub half %a, %z
  ret half %b
}

define half @test_half_sub_mul_rhs(half %x, half %y, half %z) {
; GFX9-LABEL: test_half_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f16_e64 v0, v0, -v1
; GFX9-NEXT:    v_add_f16_e32 v0, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_half_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_xor_b32_e32 v0, 0x8000, v0
; GFX9-CONTRACT-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_half_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_legacy_f16 v0, v0, -v1, v2
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_half_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f16_e64 v0, v0, -v1
; GFX10-NEXT:    v_add_f16_e32 v0, v2, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_half_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_xor_b32_e32 v0, 0x8000, v0
; GFX10-CONTRACT-NEXT:    v_fma_f16 v0, v0, v1, v2
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_half_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f16_e64 v0, v0, -v1
; GFX10-DENORM-NEXT:    v_add_f16_e32 v0, v2, v0
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul half %x, %y
  %b = fsub half %z, %a
  ret half %b
}

define double @test_double_sub_mul(double %x, double %y, double %z) {
; GFX9-LABEL: test_double_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX9-NEXT:    v_add_f64 v[0:1], v[0:1], -v[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_double_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], -v[4:5]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_double_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX9-DENORM-NEXT:    v_add_f64 v[0:1], v[0:1], -v[4:5]
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_double_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-NEXT:    v_add_f64 v[0:1], v[0:1], -v[4:5]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_double_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[0:1], v[0:1], v[2:3], -v[4:5]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_double_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-DENORM-NEXT:    v_add_f64 v[0:1], v[0:1], -v[4:5]
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul double %x, %y
  %b = fsub double %a, %z
  ret double %b
}

define double @test_double_sub_mul_rhs(double %x, double %y, double %z) {
; GFX9-LABEL: test_double_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX9-NEXT:    v_add_f64 v[0:1], v[4:5], -v[0:1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_double_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[0:1], -v[0:1], v[2:3], v[4:5]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_double_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX9-DENORM-NEXT:    v_add_f64 v[0:1], v[4:5], -v[0:1]
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_double_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-NEXT:    v_add_f64 v[0:1], v[4:5], -v[0:1]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_double_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[0:1], -v[0:1], v[2:3], v[4:5]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_double_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[2:3]
; GFX10-DENORM-NEXT:    v_add_f64 v[0:1], v[4:5], -v[0:1]
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul double %x, %y
  %b = fsub double %z, %a
  ret double %b
}

define <4 x float> @test_v4f32_sub_mul(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; GFX9-LABEL: test_v4f32_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f32_e32 v0, v0, v4
; GFX9-NEXT:    v_mul_f32_e32 v1, v1, v5
; GFX9-NEXT:    v_mul_f32_e32 v2, v2, v6
; GFX9-NEXT:    v_mul_f32_e32 v3, v3, v7
; GFX9-NEXT:    v_sub_f32_e32 v0, v0, v8
; GFX9-NEXT:    v_sub_f32_e32 v1, v1, v9
; GFX9-NEXT:    v_sub_f32_e32 v2, v2, v10
; GFX9-NEXT:    v_sub_f32_e32 v3, v3, v11
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f32_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f32 v0, v0, v4, -v8
; GFX9-CONTRACT-NEXT:    v_fma_f32 v1, v1, v5, -v9
; GFX9-CONTRACT-NEXT:    v_fma_f32 v2, v2, v6, -v10
; GFX9-CONTRACT-NEXT:    v_fma_f32 v3, v3, v7, -v11
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f32_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_f32 v0, v0, v4, -v8
; GFX9-DENORM-NEXT:    v_mad_f32 v1, v1, v5, -v9
; GFX9-DENORM-NEXT:    v_mad_f32 v2, v2, v6, -v10
; GFX9-DENORM-NEXT:    v_mad_f32 v3, v3, v7, -v11
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f32_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f32_e32 v0, v0, v4
; GFX10-NEXT:    v_mul_f32_e32 v1, v1, v5
; GFX10-NEXT:    v_mul_f32_e32 v2, v2, v6
; GFX10-NEXT:    v_mul_f32_e32 v3, v3, v7
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v8
; GFX10-NEXT:    v_sub_f32_e32 v1, v1, v9
; GFX10-NEXT:    v_sub_f32_e32 v2, v2, v10
; GFX10-NEXT:    v_sub_f32_e32 v3, v3, v11
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f32_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f32 v0, v0, v4, -v8
; GFX10-CONTRACT-NEXT:    v_fma_f32 v1, v1, v5, -v9
; GFX10-CONTRACT-NEXT:    v_fma_f32 v2, v2, v6, -v10
; GFX10-CONTRACT-NEXT:    v_fma_f32 v3, v3, v7, -v11
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f32_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mad_f32 v0, v0, v4, -v8
; GFX10-DENORM-NEXT:    v_mad_f32 v1, v1, v5, -v9
; GFX10-DENORM-NEXT:    v_mad_f32 v2, v2, v6, -v10
; GFX10-DENORM-NEXT:    v_mad_f32 v3, v3, v7, -v11
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x float> %x, %y
  %b = fsub <4 x float> %a, %z
  ret <4 x float> %b
}

define <4 x float> @test_v4f32_sub_mul_rhs(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; GFX9-LABEL: test_v4f32_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f32_e32 v0, v0, v4
; GFX9-NEXT:    v_mul_f32_e32 v1, v1, v5
; GFX9-NEXT:    v_mul_f32_e32 v2, v2, v6
; GFX9-NEXT:    v_mul_f32_e32 v3, v3, v7
; GFX9-NEXT:    v_sub_f32_e32 v0, v8, v0
; GFX9-NEXT:    v_sub_f32_e32 v1, v9, v1
; GFX9-NEXT:    v_sub_f32_e32 v2, v10, v2
; GFX9-NEXT:    v_sub_f32_e32 v3, v11, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f32_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f32 v0, -v0, v4, v8
; GFX9-CONTRACT-NEXT:    v_fma_f32 v1, -v1, v5, v9
; GFX9-CONTRACT-NEXT:    v_fma_f32 v2, -v2, v6, v10
; GFX9-CONTRACT-NEXT:    v_fma_f32 v3, -v3, v7, v11
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f32_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mad_f32 v0, -v0, v4, v8
; GFX9-DENORM-NEXT:    v_mad_f32 v1, -v1, v5, v9
; GFX9-DENORM-NEXT:    v_mad_f32 v2, -v2, v6, v10
; GFX9-DENORM-NEXT:    v_mad_f32 v3, -v3, v7, v11
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f32_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f32_e32 v0, v0, v4
; GFX10-NEXT:    v_mul_f32_e32 v1, v1, v5
; GFX10-NEXT:    v_mul_f32_e32 v2, v2, v6
; GFX10-NEXT:    v_mul_f32_e32 v3, v3, v7
; GFX10-NEXT:    v_sub_f32_e32 v0, v8, v0
; GFX10-NEXT:    v_sub_f32_e32 v1, v9, v1
; GFX10-NEXT:    v_sub_f32_e32 v2, v10, v2
; GFX10-NEXT:    v_sub_f32_e32 v3, v11, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f32_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f32 v0, -v0, v4, v8
; GFX10-CONTRACT-NEXT:    v_fma_f32 v1, -v1, v5, v9
; GFX10-CONTRACT-NEXT:    v_fma_f32 v2, -v2, v6, v10
; GFX10-CONTRACT-NEXT:    v_fma_f32 v3, -v3, v7, v11
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f32_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mad_f32 v0, -v0, v4, v8
; GFX10-DENORM-NEXT:    v_mad_f32 v1, -v1, v5, v9
; GFX10-DENORM-NEXT:    v_mad_f32 v2, -v2, v6, v10
; GFX10-DENORM-NEXT:    v_mad_f32 v3, -v3, v7, v11
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x float> %x, %y
  %b = fsub <4 x float> %z, %a
  ret <4 x float> %b
}

define <4 x half> @test_v4f16_sub_mul(<4 x half> %x, <4 x half> %y, <4 x half> %z) {
; GFX9-LABEL: test_v4f16_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-NEXT:    v_add_f16_e64 v2, v0, -v4
; GFX9-NEXT:    v_add_f16_sdwa v0, v0, -v4 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_add_f16_e64 v3, v1, -v5
; GFX9-NEXT:    v_add_f16_sdwa v1, v1, -v5 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX9-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f16_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_pk_fma_f16 v0, v0, v2, v4 neg_lo:[0,0,1] neg_hi:[0,0,1]
; GFX9-CONTRACT-NEXT:    v_pk_fma_f16 v1, v1, v3, v5 neg_lo:[0,0,1] neg_hi:[0,0,1]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f16_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-DENORM-NEXT:    v_add_f16_e64 v2, v0, -v4
; GFX9-DENORM-NEXT:    v_add_f16_sdwa v0, v0, -v4 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-DENORM-NEXT:    v_add_f16_e64 v3, v1, -v5
; GFX9-DENORM-NEXT:    v_add_f16_sdwa v1, v1, -v5 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-DENORM-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-DENORM-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX9-DENORM-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f16_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX10-NEXT:    v_add_f16_e64 v2, v0, -v4
; GFX10-NEXT:    v_add_f16_sdwa v0, v0, -v4 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_add_f16_e64 v3, v1, -v5
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    v_add_f16_sdwa v1, v1, -v5 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX10-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f16_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_pk_fma_f16 v0, v0, v2, v4 neg_lo:[0,0,1] neg_hi:[0,0,1]
; GFX10-CONTRACT-NEXT:    v_pk_fma_f16 v1, v1, v3, v5 neg_lo:[0,0,1] neg_hi:[0,0,1]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f16_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX10-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX10-DENORM-NEXT:    v_add_f16_e64 v2, v0, -v4
; GFX10-DENORM-NEXT:    v_add_f16_sdwa v0, v0, -v4 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-DENORM-NEXT:    v_add_f16_e64 v3, v1, -v5
; GFX10-DENORM-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-DENORM-NEXT:    v_add_f16_sdwa v1, v1, -v5 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-DENORM-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX10-DENORM-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x half> %x, %y
  %b = fsub <4 x half> %a, %z
  ret <4 x half> %b
}

define <4 x half> @test_v4f16_sub_mul_rhs(<4 x half> %x, <4 x half> %y, <4 x half> %z) {
; GFX9-LABEL: test_v4f16_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-NEXT:    v_add_f16_e64 v2, v4, -v0
; GFX9-NEXT:    v_add_f16_sdwa v0, v4, -v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_add_f16_e64 v3, v5, -v1
; GFX9-NEXT:    v_add_f16_sdwa v1, v5, -v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX9-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f16_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_pk_fma_f16 v0, v0, v2, v4 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX9-CONTRACT-NEXT:    v_pk_fma_f16 v1, v1, v3, v5 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f16_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX9-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX9-DENORM-NEXT:    v_add_f16_e64 v2, v4, -v0
; GFX9-DENORM-NEXT:    v_add_f16_sdwa v0, v4, -v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-DENORM-NEXT:    v_add_f16_e64 v3, v5, -v1
; GFX9-DENORM-NEXT:    v_add_f16_sdwa v1, v5, -v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX9-DENORM-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-DENORM-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX9-DENORM-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f16_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX10-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX10-NEXT:    v_add_f16_e64 v2, v4, -v0
; GFX10-NEXT:    v_add_f16_sdwa v0, v4, -v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_add_f16_e64 v3, v5, -v1
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    v_add_f16_sdwa v1, v5, -v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX10-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f16_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_pk_fma_f16 v0, v0, v2, v4 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX10-CONTRACT-NEXT:    v_pk_fma_f16 v1, v1, v3, v5 neg_lo:[1,0,0] neg_hi:[1,0,0]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f16_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_pk_mul_f16 v0, v0, v2
; GFX10-DENORM-NEXT:    v_pk_mul_f16 v1, v1, v3
; GFX10-DENORM-NEXT:    v_add_f16_e64 v2, v4, -v0
; GFX10-DENORM-NEXT:    v_add_f16_sdwa v0, v4, -v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-DENORM-NEXT:    v_add_f16_e64 v3, v5, -v1
; GFX10-DENORM-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-DENORM-NEXT:    v_add_f16_sdwa v1, v5, -v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX10-DENORM-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX10-DENORM-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x half> %x, %y
  %b = fsub <4 x half> %z, %a
  ret <4 x half> %b
}

define <4 x double> @test_v4f64_sub_mul(<4 x double> %x, <4 x double> %y, <4 x double> %z) {
; GFX9-LABEL: test_v4f64_sub_mul:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX9-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX9-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX9-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX9-NEXT:    v_add_f64 v[0:1], v[0:1], -v[16:17]
; GFX9-NEXT:    v_add_f64 v[2:3], v[2:3], -v[18:19]
; GFX9-NEXT:    v_add_f64 v[4:5], v[4:5], -v[20:21]
; GFX9-NEXT:    v_add_f64 v[6:7], v[6:7], -v[22:23]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f64_sub_mul:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[0:1], v[0:1], v[8:9], -v[16:17]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[2:3], v[2:3], v[10:11], -v[18:19]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[4:5], v[4:5], v[12:13], -v[20:21]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[6:7], v[6:7], v[14:15], -v[22:23]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f64_sub_mul:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX9-DENORM-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX9-DENORM-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX9-DENORM-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX9-DENORM-NEXT:    v_add_f64 v[0:1], v[0:1], -v[16:17]
; GFX9-DENORM-NEXT:    v_add_f64 v[2:3], v[2:3], -v[18:19]
; GFX9-DENORM-NEXT:    v_add_f64 v[4:5], v[4:5], -v[20:21]
; GFX9-DENORM-NEXT:    v_add_f64 v[6:7], v[6:7], -v[22:23]
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f64_sub_mul:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX10-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX10-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX10-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX10-NEXT:    v_add_f64 v[0:1], v[0:1], -v[16:17]
; GFX10-NEXT:    v_add_f64 v[2:3], v[2:3], -v[18:19]
; GFX10-NEXT:    v_add_f64 v[4:5], v[4:5], -v[20:21]
; GFX10-NEXT:    v_add_f64 v[6:7], v[6:7], -v[22:23]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f64_sub_mul:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[0:1], v[0:1], v[8:9], -v[16:17]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[2:3], v[2:3], v[10:11], -v[18:19]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[4:5], v[4:5], v[12:13], -v[20:21]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[6:7], v[6:7], v[14:15], -v[22:23]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f64_sub_mul:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX10-DENORM-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX10-DENORM-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX10-DENORM-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX10-DENORM-NEXT:    v_add_f64 v[0:1], v[0:1], -v[16:17]
; GFX10-DENORM-NEXT:    v_add_f64 v[2:3], v[2:3], -v[18:19]
; GFX10-DENORM-NEXT:    v_add_f64 v[4:5], v[4:5], -v[20:21]
; GFX10-DENORM-NEXT:    v_add_f64 v[6:7], v[6:7], -v[22:23]
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x double> %x, %y
  %b = fsub <4 x double> %a, %z
  ret <4 x double> %b
}

define <4 x double> @test_v4f64_sub_mul_rhs(<4 x double> %x, <4 x double> %y, <4 x double> %z) {
; GFX9-LABEL: test_v4f64_sub_mul_rhs:
; GFX9:       ; %bb.0: ; %.entry
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX9-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX9-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX9-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX9-NEXT:    v_add_f64 v[0:1], v[16:17], -v[0:1]
; GFX9-NEXT:    v_add_f64 v[2:3], v[18:19], -v[2:3]
; GFX9-NEXT:    v_add_f64 v[4:5], v[20:21], -v[4:5]
; GFX9-NEXT:    v_add_f64 v[6:7], v[22:23], -v[6:7]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-CONTRACT-LABEL: test_v4f64_sub_mul_rhs:
; GFX9-CONTRACT:       ; %bb.0: ; %.entry
; GFX9-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[0:1], -v[0:1], v[8:9], v[16:17]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[2:3], -v[2:3], v[10:11], v[18:19]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[4:5], -v[4:5], v[12:13], v[20:21]
; GFX9-CONTRACT-NEXT:    v_fma_f64 v[6:7], -v[6:7], v[14:15], v[22:23]
; GFX9-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-DENORM-LABEL: test_v4f64_sub_mul_rhs:
; GFX9-DENORM:       ; %bb.0: ; %.entry
; GFX9-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX9-DENORM-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX9-DENORM-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX9-DENORM-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX9-DENORM-NEXT:    v_add_f64 v[0:1], v[16:17], -v[0:1]
; GFX9-DENORM-NEXT:    v_add_f64 v[2:3], v[18:19], -v[2:3]
; GFX9-DENORM-NEXT:    v_add_f64 v[4:5], v[20:21], -v[4:5]
; GFX9-DENORM-NEXT:    v_add_f64 v[6:7], v[22:23], -v[6:7]
; GFX9-DENORM-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: test_v4f64_sub_mul_rhs:
; GFX10:       ; %bb.0: ; %.entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX10-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX10-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX10-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX10-NEXT:    v_add_f64 v[0:1], v[16:17], -v[0:1]
; GFX10-NEXT:    v_add_f64 v[2:3], v[18:19], -v[2:3]
; GFX10-NEXT:    v_add_f64 v[4:5], v[20:21], -v[4:5]
; GFX10-NEXT:    v_add_f64 v[6:7], v[22:23], -v[6:7]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-CONTRACT-LABEL: test_v4f64_sub_mul_rhs:
; GFX10-CONTRACT:       ; %bb.0: ; %.entry
; GFX10-CONTRACT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-CONTRACT-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[0:1], -v[0:1], v[8:9], v[16:17]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[2:3], -v[2:3], v[10:11], v[18:19]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[4:5], -v[4:5], v[12:13], v[20:21]
; GFX10-CONTRACT-NEXT:    v_fma_f64 v[6:7], -v[6:7], v[14:15], v[22:23]
; GFX10-CONTRACT-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-DENORM-LABEL: test_v4f64_sub_mul_rhs:
; GFX10-DENORM:       ; %bb.0: ; %.entry
; GFX10-DENORM-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-DENORM-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-DENORM-NEXT:    v_mul_f64 v[0:1], v[0:1], v[8:9]
; GFX10-DENORM-NEXT:    v_mul_f64 v[2:3], v[2:3], v[10:11]
; GFX10-DENORM-NEXT:    v_mul_f64 v[4:5], v[4:5], v[12:13]
; GFX10-DENORM-NEXT:    v_mul_f64 v[6:7], v[6:7], v[14:15]
; GFX10-DENORM-NEXT:    v_add_f64 v[0:1], v[16:17], -v[0:1]
; GFX10-DENORM-NEXT:    v_add_f64 v[2:3], v[18:19], -v[2:3]
; GFX10-DENORM-NEXT:    v_add_f64 v[4:5], v[20:21], -v[4:5]
; GFX10-DENORM-NEXT:    v_add_f64 v[6:7], v[22:23], -v[6:7]
; GFX10-DENORM-NEXT:    s_setpc_b64 s[30:31]
.entry:
  %a = fmul <4 x double> %x, %y
  %b = fsub <4 x double> %z, %a
  ret <4 x double> %b
}
