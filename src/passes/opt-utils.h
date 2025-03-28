/*
 * Copyright 2018 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_passes_opt_utils_h
#define wasm_passes_opt_utils_h

#include <functional>
#include <unordered_set>

#include "ir/element-utils.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "passes/pass-utils.h"
#include "wasm-validator.h"
#include "wasm.h"

namespace wasm::OptUtils {

// Given a PassRunner, applies a set of useful passes that make sense to run
// after inlining.
inline void addUsefulPassesAfterInlining(PassRunner& runner) {
  // Propagating constants makes a lot of sense after inlining, as new constants
  // may have arrived.
  runner.add("precompute-propagate");
  // Do all the usual stuff.
  runner.addDefaultFunctionOptimizationPasses();
}

// Run useful optimizations after inlining new code into a set of functions.
inline void optimizeAfterInlining(const PassUtils::FuncSet& funcs,
                                  Module* module,
                                  PassRunner* parentRunner) {
  // In pass-debug mode, validate before and after these optimizations. This
  // helps catch bugs in the middle of passes like inlining and dae. We do this
  // at level 2+ and not 1 so that this extra validation is not added to the
  // timings that level 1 reports.
  if (PassRunner::getPassDebug() >= 2) {
    if (!WasmValidator().validate(*module, parentRunner->options)) {
      Fatal() << "invalid wasm before optimizeAfterInlining";
    }
  }
  PassUtils::FilteredPassRunner runner(module, funcs, parentRunner->options);
  runner.setIsNested(true);
  addUsefulPassesAfterInlining(runner);
  runner.run();
  if (PassRunner::getPassDebug() >= 2) {
    if (!WasmValidator().validate(*module, parentRunner->options)) {
      Fatal() << "invalid wasm after optimizeAfterInlining";
    }
  }
}

struct FunctionRefReplacer
  : public WalkerPass<PostWalker<FunctionRefReplacer>> {
  bool isFunctionParallel() override { return true; }

  using MaybeReplace = std::function<void(Name&)>;

  FunctionRefReplacer(MaybeReplace maybeReplace) : maybeReplace(maybeReplace) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionRefReplacer>(maybeReplace);
  }

  void visitCall(Call* curr) { maybeReplace(curr->target); }

  void visitRefFunc(RefFunc* curr) { maybeReplace(curr->func); }

private:
  MaybeReplace maybeReplace;
};

inline void replaceFunctions(PassRunner* runner,
                             Module& module,
                             const std::map<Name, Name>& replacements) {
  auto maybeReplace = [&](Name& name) {
    auto iter = replacements.find(name);
    if (iter != replacements.end()) {
      name = iter->second;
    }
  };
  // replace direct calls in code both functions and module elements
  FunctionRefReplacer replacer(maybeReplace);
  replacer.run(runner, &module);
  replacer.runOnModuleCode(runner, &module);

  // replace in start
  if (module.start.is()) {
    maybeReplace(module.start);
  }
  // replace in exports
  for (auto& exp : module.exports) {
    if (exp->kind == ExternalKind::Function) {
      maybeReplace(*exp->getInternalName());
    }
  }
}

} // namespace wasm::OptUtils

#endif // wasm_passes_opt_utils_h
