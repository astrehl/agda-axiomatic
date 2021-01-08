module net.cruhland.axioms.AbstractAlgebra where

open import Function using (_∘_)
open import net.cruhland.axioms.Eq as Eq using (_≃_; _≄_; Eq)
open Eq.≃-Reasoning
open import net.cruhland.models.Logic using (_∨_; ∨-rec; ¬_)

open import net.cruhland.axioms.AbstractAlgebra.Commutative public
open import net.cruhland.axioms.AbstractAlgebra.Compatible public
open import net.cruhland.axioms.AbstractAlgebra.Injective public
open import net.cruhland.axioms.AbstractAlgebra.Reductive public
open import net.cruhland.axioms.AbstractAlgebra.Substitutive public

record Associative {A : Set} {{eq : Eq A}} (_⊙_ : A → A → A) : Set where
  field
    assoc : ∀ {a b c} → (a ⊙ b) ⊙ c ≃ a ⊙ (b ⊙ c)

open Associative {{...}} public using (assoc)

record ZeroProduct {A : Set} {{eq : Eq A}} (_⊙_ : A → A → A) (z : A) : Set where
  field
    zero-prod : ∀ {a b} → a ⊙ b ≃ z → a ≃ z ∨ b ≃ z

open ZeroProduct {{...}} public using (zero-prod)

record Inverseᴸ
    {A : Set} {{eq : Eq A}} (_⊙_ : A → A → A) (inv : A → A) (e : A) : Set where
  field
    invᴸ : ∀ {a} → inv a ⊙ a ≃ e

open Inverseᴸ {{...}} public using (invᴸ)

record Inverseᴿ
    {A : Set} {{eq : Eq A}} (_⊙_ : A → A → A) (inv : A → A) (e : A) : Set where
  field
    invᴿ : ∀ {a} → a ⊙ inv a ≃ e

open Inverseᴿ {{...}} public using (invᴿ)

record Inverseⁱᴸ
    {A : Set} {C : A → Set} {{eq : Eq A}}
      (_⊙_ : A → A → A) (inv : (a : A) {{c : C a}} → A) (e : A) : Set where
  field
    invⁱᴸ : ∀ {a} {{c : C a}} → inv a ⊙ a ≃ e

open Inverseⁱᴸ {{...}} public using (invⁱᴸ)

record Inverseⁱᴿ
    {A : Set} {C : A → Set} {{eq : Eq A}}
      (_⊙_ : A → A → A) (inv : (a : A) {{c : C a}} → A) (e : A) : Set where
  field
    invⁱᴿ : ∀ {a} {{c : C a}} → a ⊙ inv a ≃ e

open Inverseⁱᴿ {{...}} public using (invⁱᴿ)

record Antisymmetric {A : Set} {{eq : Eq A}} (_~_ : A → A → Set) : Set where
  field
    antisym : ∀ {a b} → a ~ b → b ~ a → a ≃ b

open Antisymmetric {{...}} public using (antisym)

data OneOfThree (A B C : Set) : Set where
  1st : A → OneOfThree A B C
  2nd : B → OneOfThree A B C
  3rd : C → OneOfThree A B C

data TwoOfThree (A B C : Set) : Set where
  1∧2 : A → B → TwoOfThree A B C
  1∧3 : A → C → TwoOfThree A B C
  2∧3 : B → C → TwoOfThree A B C

record ExactlyOneOfThree (A B C : Set) : Set where
  field
    at-least-one : OneOfThree A B C
    at-most-one : ¬ TwoOfThree A B C

distributiveᴿ-from-distributiveᴸ :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{_ : Eq A}} {{_ : Commutative _⊙_}} {{_ : Substitutive₂ _⊕_}}
      {{_ : Distributiveᴸ _⊙_ _⊕_}} → Distributiveᴿ _⊙_ _⊕_
distributiveᴿ-from-distributiveᴸ {A} {_⊙_} {_⊕_} = distributiveᴿ distribᴿ₀
  where
    distribᴿ₀ : ∀ {a b c} → (a ⊕ b) ⊙ c ≃ (a ⊙ c) ⊕ (b ⊙ c)
    distribᴿ₀ {a} {b} {c} =
      begin
        (a ⊕ b) ⊙ c
      ≃⟨ comm ⟩
        c ⊙ (a ⊕ b)
      ≃⟨ distribᴸ ⟩
        (c ⊙ a) ⊕ (c ⊙ b)
      ≃⟨ subst comm ⟩
        (a ⊙ c) ⊕ (c ⊙ b)
      ≃⟨ subst comm ⟩
        (a ⊙ c) ⊕ (b ⊙ c)
      ∎

inverseᴿ :
  {A : Set} {_⊙_ : A → A → A} {inv : A → A} →
    ∀ {e} {{_ : Eq A}} {{_ : Commutative _⊙_}} {{_ : Inverseᴸ _⊙_ inv e}} →
      Inverseᴿ _⊙_ inv e
inverseᴿ = record { invᴿ = Eq.trans comm invᴸ }

inverseⁱᴿ :
  {A : Set} {C : A → Set} {_⊙_ : A → A → A} {inv : (a : A) {{c : C a}} → A} →
    ∀ {e} {{_ : Eq A}} {{_ : Commutative _⊙_}} {{_ : Inverseⁱᴸ _⊙_ inv e}} →
      Inverseⁱᴿ _⊙_ inv e
inverseⁱᴿ = record { invⁱᴿ = Eq.trans comm invⁱᴸ }

[ab][cd]≃a[[bc]d] :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Substitutiveᴿ _⊙_}} →
      ∀ {a b c d} → (a ⊙ b) ⊙ (c ⊙ d) ≃ a ⊙ ((b ⊙ c) ⊙ d)
[ab][cd]≃a[[bc]d] {A} {_⊙_} {a} {b} {c} {d} =
  begin
    (a ⊙ b) ⊙ (c ⊙ d)
  ≃⟨ assoc ⟩
    a ⊙ (b ⊙ (c ⊙ d))
  ≃˘⟨ subst assoc ⟩
    a ⊙ ((b ⊙ c) ⊙ d)
  ∎

swap-middle :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Commutative _⊙_}} {{_ : Substitutive₂ _⊙_}} →
      ∀ {a b c d} → a ⊙ ((b ⊙ c) ⊙ d) ≃ a ⊙ ((c ⊙ b) ⊙ d)
swap-middle = subst (subst comm)

transpose :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Commutative _⊙_}}
    {{_ : Substitutive₂ _⊙_}} →
      ∀ {w x y z} → (w ⊙ x) ⊙ (y ⊙ z) ≃ (w ⊙ y) ⊙ (x ⊙ z)
transpose {A} {_⊙_} {w} {x} {y} {z} =
  begin
    (w ⊙ x) ⊙ (y ⊙ z)
  ≃⟨ [ab][cd]≃a[[bc]d] ⟩
    w ⊙ ((x ⊙ y) ⊙ z)
  ≃⟨ swap-middle ⟩
    w ⊙ ((y ⊙ x) ⊙ z)
  ≃˘⟨ [ab][cd]≃a[[bc]d] ⟩
    (w ⊙ y) ⊙ (x ⊙ z)
  ∎

perm-adcb :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Commutative _⊙_}}
    {{_ : Substitutive₂ _⊙_}} →
      ∀ {a b c d} → (a ⊙ d) ⊙ (c ⊙ b) ≃ (a ⊙ b) ⊙ (c ⊙ d)
perm-adcb {A} {_⊙_} {a} {b} {c} {d} =
  begin
    (a ⊙ d) ⊙ (c ⊙ b)
  ≃⟨ subst comm ⟩
    (a ⊙ d) ⊙ (b ⊙ c)
  ≃⟨ transpose ⟩
    (a ⊙ b) ⊙ (d ⊙ c)
  ≃⟨ subst comm ⟩
    (a ⊙ b) ⊙ (c ⊙ d)
  ∎

distrib-twoᴸ :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{_ : Eq A}} {{_ : Distributiveᴸ _⊙_ _⊕_}} {{_ : Substitutive₂ _⊕_}} →
      ∀ {a b c d e f} →
        (a ⊙ (b ⊕ c)) ⊕ (d ⊙ (e ⊕ f)) ≃
          ((a ⊙ b) ⊕ (a ⊙ c)) ⊕ ((d ⊙ e) ⊕ (d ⊙ f))
distrib-twoᴸ {A} {_⊙_} {_⊕_} {a} {b} {c} {d} {e} {f} =
  begin
    (a ⊙ (b ⊕ c)) ⊕ (d ⊙ (e ⊕ f))
  ≃⟨ subst distribᴸ ⟩
    ((a ⊙ b) ⊕ (a ⊙ c)) ⊕ (d ⊙ (e ⊕ f))
  ≃⟨ subst distribᴸ ⟩
    ((a ⊙ b) ⊕ (a ⊙ c)) ⊕ ((d ⊙ e) ⊕ (d ⊙ f))
  ∎

distrib-twoᴿ :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{_ : Eq A}} {{_ : Distributiveᴿ _⊙_ _⊕_}} {{_ : Substitutive₂ _⊕_}} →
      ∀ {a b c d e f} →
        ((a ⊕ b) ⊙ c) ⊕ ((d ⊕ e) ⊙ f) ≃
          ((a ⊙ c) ⊕ (b ⊙ c)) ⊕ ((d ⊙ f) ⊕ (e ⊙ f))
distrib-twoᴿ {A} {_⊙_} {_⊕_} {a} {b} {c} {d} {e} {f} =
  begin
    ((a ⊕ b) ⊙ c) ⊕ ((d ⊕ e) ⊙ f)
  ≃⟨ subst distribᴿ ⟩
    ((a ⊙ c) ⊕ (b ⊙ c)) ⊕ ((d ⊕ e) ⊙ f)
  ≃⟨ subst distribᴿ ⟩
    ((a ⊙ c) ⊕ (b ⊙ c)) ⊕ ((d ⊙ f) ⊕ (e ⊙ f))
  ∎

nonzero-prod :
  {A : Set} {_⊙_ : A → A → A} →
    ∀ {a b z} {{_ : Eq A}} {{_ : ZeroProduct _⊙_ z}} →
      a ≄ z → b ≄ z → a ⊙ b ≄ z
nonzero-prod a≄z b≄z = ∨-rec a≄z b≄z ∘ zero-prod

substᴿ-with-assoc :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Substitutiveᴿ _⊙_}} →
      ∀ {a b c d e} → b ⊙ c ≃ d ⊙ e → (a ⊙ b) ⊙ c ≃ (a ⊙ d) ⊙ e
substᴿ-with-assoc {A} {_⊙_} {a} {b} {c} {d} {e} bc≃de =
  begin
    (a ⊙ b) ⊙ c
  ≃⟨ assoc ⟩
    a ⊙ (b ⊙ c)
  ≃⟨ subst bc≃de ⟩
    a ⊙ (d ⊙ e)
  ≃˘⟨ assoc ⟩
    (a ⊙ d) ⊙ e
  ∎

a[bc]-chain :
  {A : Set} {_⊙_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Substitutiveᴸ _⊙_}} →
      ∀ {a b c d e} → a ⊙ b ≃ d → d ⊙ c ≃ e → a ⊙ (b ⊙ c) ≃ e
a[bc]-chain {A} {_⊙_} {a} {b} {c} {d} {e} ab≃d dc≃e =
  begin
    a ⊙ (b ⊙ c)
  ≃˘⟨ assoc ⟩
    (a ⊙ b) ⊙ c
  ≃⟨ subst ab≃d ⟩
    d ⊙ c
  ≃⟨ dc≃e ⟩
    e
  ∎

eq→idᴿ :
  {A : Set} {_⊙_ : A → A → A} {a b d e : A}
    {{_ : Eq A}} {{_ : Identityᴿ _⊙_ e}}
    {{cancel : Cancellativeᴸ _⊙_ _≃_}} {{_ : Cancellativeᴸ.C cancel a}} →
      a ⊙ d ≃ b → a ≃ b → d ≃ e
eq→idᴿ {A} {_⊙_} {a} {b} {d} {e} ad≃b a≃b = cancelᴸ ad≃ae
  where
    ad≃ae =
      begin
        a ⊙ d
      ≃⟨ ad≃b ⟩
        b
      ≃˘⟨ a≃b ⟩
        a
      ≃˘⟨ identᴿ ⟩
        a ⊙ e
      ∎

idᴿ→eq :
  {A : Set} {_⊙_ : A → A → A} {a b d e : A}
    {{_ : Eq A}} {{_ : Identityᴿ _⊙_ e}} {{_ : Substitutiveᴿ _⊙_}} →
      a ⊙ d ≃ b → d ≃ e → a ≃ b
idᴿ→eq {A} {_⊙_} {a} {b} {d} {e} ad≃b d≃e =
  begin
    a
  ≃˘⟨ identᴿ ⟩
    a ⊙ e
  ≃˘⟨ subst d≃e ⟩
    a ⊙ d
  ≃⟨ ad≃b ⟩
    b
  ∎

assoc-four :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{_ : Eq A}} {{_ : Associative _⊙_}} {{_ : Substitutive₂ _⊕_}} →
      ∀ {a₁ a₂ a₃ b₁ b₂ b₃ c₁ c₂ c₃ d₁ d₂ d₃} →
        (((a₁ ⊙ a₂) ⊙ a₃) ⊕ ((b₁ ⊙ b₂) ⊙ b₃)) ⊕
          (((c₁ ⊙ c₂) ⊙ c₃) ⊕ ((d₁ ⊙ d₂) ⊙ d₃))
        ≃ ((a₁ ⊙ (a₂ ⊙ a₃)) ⊕ (b₁ ⊙ (b₂ ⊙ b₃))) ⊕
            ((c₁ ⊙ (c₂ ⊙ c₃)) ⊕ (d₁ ⊙ (d₂ ⊙ d₃)))
assoc-four
    {A} {_⊙_} {_⊕_}
      {a₁} {a₂} {a₃} {b₁} {b₂} {b₃} {c₁} {c₂} {c₃} {d₁} {d₂} {d₃} =
  begin
    (((a₁ ⊙ a₂) ⊙ a₃) ⊕ ((b₁ ⊙ b₂) ⊙ b₃)) ⊕
      (((c₁ ⊙ c₂) ⊙ c₃) ⊕ ((d₁ ⊙ d₂) ⊙ d₃))
  ≃⟨ subst (subst assoc) ⟩
    ((a₁ ⊙ (a₂ ⊙ a₃)) ⊕ ((b₁ ⊙ b₂) ⊙ b₃)) ⊕
      (((c₁ ⊙ c₂) ⊙ c₃) ⊕ ((d₁ ⊙ d₂) ⊙ d₃))
  ≃⟨ subst (subst assoc) ⟩
    ((a₁ ⊙ (a₂ ⊙ a₃)) ⊕ (b₁ ⊙ (b₂ ⊙ b₃))) ⊕
      (((c₁ ⊙ c₂) ⊙ c₃) ⊕ ((d₁ ⊙ d₂) ⊙ d₃))
  ≃⟨ subst (subst assoc) ⟩
    ((a₁ ⊙ (a₂ ⊙ a₃)) ⊕ (b₁ ⊙ (b₂ ⊙ b₃))) ⊕
      ((c₁ ⊙ (c₂ ⊙ c₃)) ⊕ ((d₁ ⊙ d₂) ⊙ d₃))
  ≃⟨ subst (subst assoc) ⟩
    ((a₁ ⊙ (a₂ ⊙ a₃)) ⊕ (b₁ ⊙ (b₂ ⊙ b₃))) ⊕
      ((c₁ ⊙ (c₂ ⊙ c₃)) ⊕ (d₁ ⊙ (d₂ ⊙ d₃)))
  ∎

refactor :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{eq : Eq A}} {{_ : Associative _⊙_}} {{_ : Associative _⊕_}}
    {{_ : Commutative _⊕_}} {{_ : Substitutive₂ _⊕_}}
    {{_ : Distributiveᴸ _⊙_ _⊕_}} {{_ : Distributiveᴿ _⊙_ _⊕_}} →
      ∀ {b₁ b₂ a₁ a₂ a₃ a₄} →
        (((a₁ ⊙ a₃) ⊕ (a₂ ⊙ a₄)) ⊙ b₁) ⊕ (((a₁ ⊙ a₄) ⊕ (a₂ ⊙ a₃)) ⊙ b₂) ≃
          (a₁ ⊙ ((a₃ ⊙ b₁) ⊕ (a₄ ⊙ b₂))) ⊕ (a₂ ⊙ ((a₃ ⊙ b₂) ⊕ (a₄ ⊙ b₁)))
refactor {A} {_⊙_} {_⊕_} {b₁} {b₂} {a₁} {a₂} {a₃} {a₄} =
  begin
    (((a₁ ⊙ a₃) ⊕ (a₂ ⊙ a₄)) ⊙ b₁) ⊕ (((a₁ ⊙ a₄) ⊕ (a₂ ⊙ a₃)) ⊙ b₂)
  ≃⟨ distrib-twoᴿ ⟩
    (((a₁ ⊙ a₃) ⊙ b₁) ⊕ ((a₂ ⊙ a₄) ⊙ b₁)) ⊕
      (((a₁ ⊙ a₄) ⊙ b₂) ⊕ ((a₂ ⊙ a₃) ⊙ b₂))
  ≃⟨ transpose ⟩
    (((a₁ ⊙ a₃) ⊙ b₁) ⊕ ((a₁ ⊙ a₄) ⊙ b₂)) ⊕
      (((a₂ ⊙ a₄) ⊙ b₁) ⊕ ((a₂ ⊙ a₃) ⊙ b₂))
  ≃⟨ subst comm ⟩
    (((a₁ ⊙ a₃) ⊙ b₁) ⊕ ((a₁ ⊙ a₄) ⊙ b₂)) ⊕
      (((a₂ ⊙ a₃) ⊙ b₂) ⊕ ((a₂ ⊙ a₄) ⊙ b₁))
  ≃⟨ assoc-four ⟩
    ((a₁ ⊙ (a₃ ⊙ b₁)) ⊕ (a₁ ⊙ (a₄ ⊙ b₂))) ⊕
      ((a₂ ⊙ (a₃ ⊙ b₂)) ⊕ (a₂ ⊙ (a₄ ⊙ b₁)))
  ≃˘⟨ distrib-twoᴸ ⟩
    (a₁ ⊙ ((a₃ ⊙ b₁) ⊕ (a₄ ⊙ b₂))) ⊕ (a₂ ⊙ ((a₃ ⊙ b₂) ⊕ (a₄ ⊙ b₁)))
  ∎
