import Relation.Binary.PropositionalEquality as Eq
open Eq using (_≡_; sym; trans; cong)
open Eq.≡-Reasoning
open import net.cruhland.axiomatic.Logic using (LogicBundle)
open import net.cruhland.axiomatic.Peano using (PeanoBundle)

module net.cruhland.axiomatic.Peano.Multiplication
  (LB : LogicBundle)
  (PB : PeanoBundle LB) where
  open LogicBundle LB
  open PeanoBundle PB
  open import net.cruhland.axiomatic.Peano.Addition LB PB
  open import net.cruhland.axiomatic.Peano.Ordering LB PB

  _*_ : ℕ → ℕ → ℕ
  n * m = rec zero (_+ m) n

  infixl 7 _*_

  *-zeroᴸ : ∀ {m} → zero * m ≡ zero
  *-zeroᴸ = rec-zero

  *-stepᴸ : ∀ {n m} → step n * m ≡ n * m + m
  *-stepᴸ = rec-step

  *-zeroᴿ : ∀ {n} → n * zero ≡ zero
  *-zeroᴿ {n} = ind P Pz Ps n
    where
      P = λ x → x * zero ≡ zero
      Pz = *-zeroᴸ

      Ps : stepProp P
      Ps {k} Pk =
        begin
          step k * zero
        ≡⟨ *-stepᴸ ⟩
          k * zero + zero
        ≡⟨ +-zeroᴿ ⟩
          k * zero
        ≡⟨ Pk ⟩
          zero
        ∎

  *-stepᴿ : ∀ {n m} → n * step m ≡ n * m + n
  *-stepᴿ {n} {m} = ind P Pz Ps n
    where
      P = λ x → x * step m ≡ x * m + x

      Pz =
        begin
          zero * step m
        ≡⟨ *-zeroᴸ ⟩
          zero
        ≡⟨ sym *-zeroᴸ ⟩
          zero * m
        ≡⟨ sym +-zeroᴿ ⟩
          zero * m + zero
        ∎

      Ps : stepProp P
      Ps {k} Pk =
        begin
          step k * step m
        ≡⟨ *-stepᴸ ⟩
          k * step m + step m
        ≡⟨ cong (_+ step m) Pk ⟩
          k * m + k + step m
        ≡⟨ with-+-assoc (trans +-comm +-stepᴸ⃗ᴿ) ⟩
          k * m + m + step k
        ≡⟨ cong (_+ step k) (sym *-stepᴸ) ⟩
          step k * m + step k
        ∎

  *-comm : ∀ {n m} → n * m ≡ m * n
  *-comm {n} {m} = ind P Pz Ps n
    where
      P = λ x → x * m ≡ m * x
      Pz = trans *-zeroᴸ (sym *-zeroᴿ)

      Ps : stepProp P
      Ps {k} Pk =
        begin
          step k * m
        ≡⟨ *-stepᴸ ⟩
          k * m + m
        ≡⟨ cong (_+ m) Pk ⟩
          m * k + m
        ≡⟨ sym *-stepᴿ ⟩
          m * step k
        ∎

  *-oneᴸ : ∀ {n} → step zero * n ≡ n
  *-oneᴸ {n} =
    begin
      step zero * n
    ≡⟨ *-stepᴸ ⟩
      zero * n + n
    ≡⟨ cong (_+ n) *-zeroᴸ ⟩
      zero + n
    ≡⟨ +-zeroᴸ ⟩
      n
    ∎

  *-oneᴿ : ∀ {n} → n * step zero ≡ n
  *-oneᴿ = trans *-comm *-oneᴸ

  *-either-zero : ∀ {n m} → n * m ≡ zero → n ≡ zero ∨ m ≡ zero
  *-either-zero {n} {m} n*m≡z = ∨-mapᴿ (Σ-rec use-pred) (case n)
    where
      use-pred : ∀ p → n ≡ step p → m ≡ zero
      use-pred p n≡sp = ∧-elimᴿ (+-both-zero p*m+m≡z)
        where
          p*m+m≡z =
            begin
              p * m + m
            ≡⟨ sym *-stepᴸ ⟩
              step p * m
            ≡⟨ cong (_* m) (sym n≡sp) ⟩
              n * m
            ≡⟨ n*m≡z ⟩
              zero
            ∎

  *-distrib-+ᴸ : ∀ {a b c} → a * (b + c) ≡ a * b + a * c
  *-distrib-+ᴸ {a} {b} {c} = ind P Pz Ps c
    where
      P = λ x → a * (b + x) ≡ a * b + a * x
      Pz =
        begin
          a * (b + zero)
        ≡⟨ cong (a *_) +-zeroᴿ ⟩
          a * b
        ≡⟨ sym +-zeroᴿ ⟩
          a * b + zero
        ≡⟨ cong (a * b +_) (sym *-zeroᴿ) ⟩
          a * b + a * zero
        ∎

      Ps : stepProp P
      Ps {k} a[b+k]≡ab+ak =
        begin
          a * (b + step k)
        ≡⟨ cong (a *_) +-stepᴿ ⟩
          a * step (b + k)
        ≡⟨ *-stepᴿ ⟩
          a * (b + k) + a
        ≡⟨ cong (_+ a) a[b+k]≡ab+ak ⟩
          a * b + a * k + a
        ≡⟨ +-assoc ⟩
          a * b + (a * k + a)
        ≡⟨ cong (a * b +_) (sym *-stepᴿ) ⟩
          a * b + a * step k
        ∎

  *-distrib-+ᴿ : ∀ {a b c} → (a + b) * c ≡ a * c + b * c
  *-distrib-+ᴿ {a} {b} {c} =
    begin
      (a + b) * c
    ≡⟨ *-comm ⟩
      c * (a + b)
    ≡⟨ *-distrib-+ᴸ ⟩
      c * a + c * b
    ≡⟨ cong (_+ c * b) *-comm ⟩
      a * c + c * b
    ≡⟨ cong (a * c +_) *-comm ⟩
      a * c + b * c
    ∎

  *-assoc : ∀ {a b c} → (a * b) * c ≡ a * (b * c)
  *-assoc {a} {b} {c} = sym (ind P Pz Ps b)
    where
      P = λ x → a * (x * c) ≡ (a * x) * c
      Pz =
        begin
          a * (zero * c)
        ≡⟨ cong (a *_) *-zeroᴸ ⟩
          a * zero
        ≡⟨ *-zeroᴿ ⟩
          zero
        ≡⟨ sym *-zeroᴸ ⟩
          zero * c
        ≡⟨ cong (_* c) (sym *-zeroᴿ) ⟩
          (a * zero) * c
        ∎

      Ps : stepProp P
      Ps {k} a[kc]≡[ak]c =
        begin
          a * (step k * c)
        ≡⟨ cong (a *_) *-stepᴸ ⟩
          a * (k * c + c)
        ≡⟨ *-distrib-+ᴸ ⟩
          a * (k * c) + a * c
        ≡⟨ cong (_+ a * c) a[kc]≡[ak]c ⟩
          (a * k) * c + a * c
        ≡⟨ sym *-distrib-+ᴿ ⟩
          (a * k + a) * c
        ≡⟨ cong (_* c) (sym *-stepᴿ) ⟩
          (a * step k) * c
        ∎

  *-positive : ∀ {a b} → Positive a → Positive b → Positive (a * b)
  *-positive {a} {b} a≢z b≢z ab≡z = ∨-rec a≢z b≢z (*-either-zero ab≡z)

  *-preserves-< : ∀ {a b c} → a < b → c ≢ zero → a * c < b * c
  *-preserves-< {a} {b} {c} a<b c≢z = Σ-rec use-b≡a+d (<→positive-diff a<b)
    where
      use-b≡a+d : ∀ d → d ≢ zero ∧ b ≡ a + d → a * c < b * c
      use-b≡a+d d d≢z∧b≡a+d = positive-diff→< (Σ-intro (d * c) dc≢z∧bc≡ac+dc)
        where
          dc≢z = *-positive (∧-elimᴸ d≢z∧b≡a+d) c≢z
          bc≡ac+dc = trans (cong (_* c) (∧-elimᴿ d≢z∧b≡a+d)) *-distrib-+ᴿ
          dc≢z∧bc≡ac+dc = ∧-intro dc≢z bc≡ac+dc

  *-cancelᴿ : ∀ {a b c} → c ≢ zero → a * c ≡ b * c → a ≡ b
  *-cancelᴿ c≢z ac≡bc = ∨-forceᴸ a≯b (∨-forceᴿ a≮b trichotomy)
    where
      a≮b = λ a<b → (∧-elimᴿ (*-preserves-< a<b c≢z)) ac≡bc
      a≯b = λ b<a → (∧-elimᴿ (*-preserves-< b<a c≢z)) (sym ac≡bc)