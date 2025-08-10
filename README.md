# Line Search Methods in MATLAB — Alternate Equal-Interval & Golden Section

This README explains two derivative-free, bracket-based line search algorithms and shows how to run them on two example functions, `funca` and `funcb`. Both methods assume the objective is **unimodal** on the search interval.

---

## Contents
- [Algorithms](#algorithms)
  - [Alternate Equal-Interval Search (EQI)](#alternate-equal-interval-search-eqi)
  - [Golden Section Search (GSS)](#golden-section-search-gss)
- [Function Signatures](#function-signatures)
- [Example Objectives](#example-objectives)
  - [`funca(a)`](#funcaa)
  - [`funcb(a)`](#funcba)
- [How to Run](#how-to-run)
- [Tips](#tips)

---

## Algorithms

### Alternate Equal-Interval Search (EQI)

**Goal:** Find a bracket around the minimum using fixed steps, then shrink the interval using evaluations at the 1/3 and 2/3 points.

**Phase 1 — Bracketing (equal steps `Δ`):**
1. Initialize `a_l = 0`, `a_m = a_l + Δ`, `a_u = a_m + Δ`.
2. Evaluate `f(a_l), f(a_m), f(a_u)` and repeat:
   - If `f(a_u) ≥ f(a_m)`: bracket found.
   - Else if `f(a_m) ≥ f(a_l)`: set `a_u = a_m`; bracket found.
   - Else slide window right by `Δ`:  
     `a_l ← a_m`, `a_m ← a_u`, `a_u ← a_u + Δ`.

**Phase 2 — Reduction (ternary-like):**
- While `a_u − a_l > ε`:
  - `a_a = a_l + (a_u − a_l)/3`, `a_b = a_u − (a_u − a_l)/3`.
  - If `f(a_a) ≤ f(a_b)`: `a_u ← a_b`; else `a_l ← a_a`.

**Return:** `a = (a_l + a_u)/2`.

**Notes:** Very simple and robust; usually needs more function evaluations than GSS because both inner points are discarded each iteration.

---

### Golden Section Search (GSS)

**Goal:** Use golden-ratio geometry to both bracket and reduce the interval while reusing one interior evaluation each step.

**Phase 1 — Bracketing (golden expansion):**
1. Let `φ = (1+√5)/2`, `τ = (√5−1)/2`.
2. Initialize `a_l = 0`, `a_m = Δ`, `a_u = Δ·φ`, then:
   - If `f(a_u) ≥ f(a_m)`: bracket found.
   - Else if `f(a_m) ≥ f(a_l)`: set `a_u = a_m`; bracket found.
   - Else shift right and expand:  
     `a_l ← a_m`, `a_m ← a_u`, `a_u ← a_u + Δ·φ^k` (increase `k`).

**Phase 2 — Golden reduction:**
- Maintain two interior points and reuse one evaluation:
  - `a_b = a_l + τ(a_u − a_l)`, `a_a = a_u − τ(a_u − a_l)`.
  - If `f(a_a) ≤ f(a_b)`: `a_u ← a_b` (reuse `a_a`); else `a_l ← a_a` (reuse `a_b`).

**Return:** `a = (a_l + a_u)/2`.

**Notes:** Asymptotically optimal among comparison-based interval methods; fewer evaluations than EQI due to reuse.

---

## How to Run

The example one dimentional functions are prepared beforehand and the code can be modified to assign the example function to a function variable named `func` at the beginning of the solver codes. The solver codes print out the optimum variable and its cost value at the end.

```matlab
func = @funcb;
eps = 0.0001;
delta = 0.05;
```

- `func`  — function handle `@funca`
- `eps`   — stop when interval length `≤ eps` (e.g., `1e-4`)  
- `delta` — Phase-1 step size (e.g., `0.05`) 

---

## Example Objectives

Both examples are convex quadratics (derived from the homework). Analytic minimizers are shown for validation.

### `funca(a)`

$$
\begin{aligned}
f(a) &= \big(5(-1+a) + 3(-1+3a) + 2(-1+a)\big)^2
      + 24\big(({-}1+a) - ({-}1+3a)\big)^2 \\
     &= (16a - 10)^2 + 96a^2
\end{aligned}
$$

```matlab
function y = funca(a)
y = (5*(-1+a)+3*(-1+3*a)+2*(-1+a)).^2 + 24*((-1+a) - (-1+3*a)).^2;
end
```

---

### `funcb(a)`

$$
\begin{aligned}
f(a) &= \tfrac{1}{2}(5-a)^2 + 2(1-2a)^2 - 10 \\
     &= 8.5\,a^2 - 13\,a + 4.5
\end{aligned}
$$

```matlab
function y = funcb(a)
y = 0.5*(5 - a).^2 + 2*(1 - 2*a).^2 - 10;
end
```

---

**Sanity checks**
- `funca`: `a` should be close to `5/11 ≈ 0.454545`
- `funcb`: `a` should be close to `13/17 ≈ 0.764706`

---

## Tips
- If Phase-1 doesn’t bracket a minimum, **increase `delta`** (or choose a different start).
- Smaller `eps` ⇒ tighter accuracy but **more iterations**.
- These methods are **derivative-free** and robust when gradients are unavailable or noisy.

