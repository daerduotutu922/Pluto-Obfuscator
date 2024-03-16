# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-stats -dispatch-stats=false < %s | FileCheck %s -check-prefix=ALL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-stats                       < %s | FileCheck %s -check-prefixes=ALL,FULL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-stats -dispatch-stats       < %s | FileCheck %s -check-prefixes=ALL,FULL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -dispatch-stats -all-stats       < %s | FileCheck %s -check-prefixes=ALL,FULL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -dispatch-stats=false -all-stats < %s | FileCheck %s -check-prefixes=ALL,FULL

add %eax, %eax

# ALL:       Iterations:        100
# ALL-NEXT:  Instructions:      100
# ALL-NEXT:  Total Cycles:      103
# ALL-NEXT:  Total uOps:        100

# ALL:       Dispatch Width:    2
# ALL-NEXT:  uOps Per Cycle:    0.97
# ALL-NEXT:  IPC:               0.97
# ALL-NEXT:  Block RThroughput: 0.5

# ALL:       Instruction Info:
# ALL-NEXT:  [1]: #uOps
# ALL-NEXT:  [2]: Latency
# ALL-NEXT:  [3]: RThroughput
# ALL-NEXT:  [4]: MayLoad
# ALL-NEXT:  [5]: MayStore
# ALL-NEXT:  [6]: HasSideEffects (U)

# ALL:       [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ALL-NEXT:   1      1     0.50                        addl	%eax, %eax

# FULL:      Dynamic Dispatch Stall Cycles:
# FULL-NEXT: RAT     - Register unavailable:                      0
# FULL-NEXT: RCU     - Retire tokens unavailable:                 0
# FULL-NEXT: SCHEDQ  - Scheduler full:                            61  (59.2%)
# FULL-NEXT: LQ      - Load queue full:                           0
# FULL-NEXT: SQ      - Store queue full:                          0
# FULL-NEXT: GROUP   - Static restrictions on the dispatch group: 0
# FULL-NEXT: USH     - Uncategorised Structural Hazard:           0

# FULL:      Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# FULL-NEXT: [# dispatched], [# cycles]
# FULL-NEXT:  0,              22  (21.4%)
# FULL-NEXT:  1,              62  (60.2%)
# FULL-NEXT:  2,              19  (18.4%)

# ALL:       Schedulers - number of cycles where we saw N micro opcodes issued:
# ALL-NEXT:  [# issued], [# cycles]
# ALL-NEXT:   0,          3  (2.9%)
# ALL-NEXT:   1,          100  (97.1%)

# ALL:       Scheduler's queue usage:
# ALL-NEXT:  [1] Resource name.
# ALL-NEXT:  [2] Average number of used buffer entries.
# ALL-NEXT:  [3] Maximum number of used buffer entries.
# ALL-NEXT:  [4] Total number of buffer entries.

# ALL:        [1]            [2]        [3]        [4]
# ALL-NEXT:  JALU01           15         20         20
# ALL-NEXT:  JFPU01           0          0          18
# ALL-NEXT:  JLSAGU           0          0          12

# ALL:       Retire Control Unit - number of cycles where we saw N instructions retired:
# ALL-NEXT:  [# retired], [# cycles]
# ALL-NEXT:   0,           3  (2.9%)
# ALL-NEXT:   1,           100  (97.1%)

# ALL:       Total ROB Entries:                64
# ALL-NEXT:  Max Used ROB Entries:             22  ( 34.4% )
# ALL-NEXT:  Average Used ROB Entries per cy:  17  ( 26.6% )

# ALL:       Register File statistics:
# ALL-NEXT:  Total number of mappings created:    200
# ALL-NEXT:  Max number of mappings used:         44

# ALL:       *  Register File #1 -- JFpuPRF:
# ALL-NEXT:     Number of physical registers:     72
# ALL-NEXT:     Total number of mappings created: 0
# ALL-NEXT:     Max number of mappings used:      0

# ALL:       *  Register File #2 -- JIntegerPRF:
# ALL-NEXT:     Number of physical registers:     64
# ALL-NEXT:     Total number of mappings created: 200
# ALL-NEXT:     Max number of mappings used:      44

# ALL:       Resources:
# ALL-NEXT:  [0]   - JALU0
# ALL-NEXT:  [1]   - JALU1
# ALL-NEXT:  [2]   - JDiv
# ALL-NEXT:  [3]   - JFPA
# ALL-NEXT:  [4]   - JFPM
# ALL-NEXT:  [5]   - JFPU0
# ALL-NEXT:  [6]   - JFPU1
# ALL-NEXT:  [7]   - JLAGU
# ALL-NEXT:  [8]   - JMul
# ALL-NEXT:  [9]   - JSAGU
# ALL-NEXT:  [10]  - JSTC
# ALL-NEXT:  [11]  - JVALU0
# ALL-NEXT:  [12]  - JVALU1
# ALL-NEXT:  [13]  - JVIMUL

# ALL:       Resource pressure per iteration:
# ALL-NEXT:  [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# ALL-NEXT:  0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -

# ALL:       Resource pressure by instruction:
# ALL-NEXT:  [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# ALL-NEXT:  0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax
