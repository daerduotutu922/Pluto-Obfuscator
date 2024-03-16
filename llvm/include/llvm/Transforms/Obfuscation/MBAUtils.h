#include "llvm/IR/Instructions.h"

using namespace llvm;

namespace MBAUtils {

int64_t *generateLinearMBA(int termsNumber);

Value *insertLinearMBA(int64_t *params, Instruction *insertBefore);

Value *insertPolynomialMBA(Value *linearMBAExpr, Instruction *insertBefore);

} // namespace MBAUtils