# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -iterations=1 -resource-pressure=false -timeline < %s | FileCheck %s

# An instruction that writes to a 32-bit register will not have any false
# dependence on the corresponding 64-bit register because the upper part of
# the 64-bit register is set to zero

imulq %rax, %rcx
addl  %edx, %ecx
addq  %rcx, %rdx

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      3
# CHECK-NEXT: Total Cycles:      8
# CHECK-NEXT: Total uOps:        3

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    0.38
# CHECK-NEXT: IPC:               0.38
# CHECK-NEXT: Block RThroughput: 1.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      3     1.00                        imulq	%rax, %rcx
# CHECK-NEXT:  1      1     0.25                        addl	%edx, %ecx
# CHECK-NEXT:  1      1     0.25                        addq	%rcx, %rdx

# CHECK:      Timeline view:
# CHECK-NEXT: Index     01234567

# CHECK:      [0,0]     DeeeER .   imulq	%rax, %rcx
# CHECK-NEXT: [0,1]     D===eER.   addl	%edx, %ecx
# CHECK-NEXT: [0,2]     D====eER   addq	%rcx, %rdx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       imulq	%rax, %rcx
# CHECK-NEXT: 1.     1     4.0    0.0    0.0       addl	%edx, %ecx
# CHECK-NEXT: 2.     1     5.0    0.0    0.0       addq	%rcx, %rdx
# CHECK-NEXT:        1     3.3    0.3    0.0       <total>
