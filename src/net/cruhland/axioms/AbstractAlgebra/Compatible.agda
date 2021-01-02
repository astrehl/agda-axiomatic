module net.cruhland.axioms.AbstractAlgebra.Compatible where

open import net.cruhland.axioms.Eq as Eq using (_≃_; Eq)

private
  record IsCompatible₁
      {A B : Set} {{_ : Eq B}} (f : A → B) (g : A → A) (h : B → B) : Set where
    constructor isCompatible₁
    field
      compat₁ : ∀ {a} → f (g a) ≃ h (f a)

open IsCompatible₁ {{...}} using () renaming (compat₁ to private-compat₁)

record Compatible₁
    {A B : Set} {{_ : Eq B}} (f : A → B) (g : A → A) : Set where
  field
    h : B → B
    isCompat₁ : IsCompatible₁ f g h

  open IsCompatible₁ isCompat₁ public

open Compatible₁ {{...}} public using (compat₁)

compatible₁ :
  {A B : Set} {{_ : Eq B}} {f : A → B} {g : A → A}
    (h : B → B) → (∀ {a} → f (g a) ≃ h (f a)) → Compatible₁ f g
compatible₁ h prf =
  record { h = h ; isCompat₁ = isCompatible₁ prf }

private
  record IsCompatible₂
      {A B : Set} {{_ : Eq B}}
        (f : A → B) (_⊙_ : A → A → A) (_⊕_ : B → B → B) : Set where
    field
      {{isCompat₁}} : ∀ {b} → IsCompatible₁ f (_⊙ b) (_⊕ f b)

  isCompatible₂ :
    {A B : Set} {{_ : Eq B}} {f : A → B} {_⊙_ : A → A → A} {_⊕_ : B → B → B} →
      (∀ {a b} → f (a ⊙ b) ≃ f a ⊕ f b) → IsCompatible₂ f _⊙_ _⊕_
  isCompatible₂ prf = record { isCompat₁ = isCompatible₁ prf }

  private-compat₂ :
    {A B : Set} {f : A → B} {_⊙_ : A → A → A} {_⊕_ : B → B → B}
      {{_ : Eq B}} {{r : IsCompatible₂ f _⊙_ _⊕_}} →
        ∀ {a b} → f (a ⊙ b) ≃ f a ⊕ f b
  private-compat₂ = private-compat₁

record Compatible₂
    {A B : Set} {{_ : Eq B}} (f : A → B) (_⊙_ : A → A → A) : Set where
  constructor compatible₂
  field
    _⊕_ : B → B → B
    compat₂ : ∀ {a b} → f (a ⊙ b) ≃ f a ⊕ f b

open Compatible₂ {{...}} public using (compat₂)

record Distributiveᴸ {A : Set} {{_ : Eq A}} (_⊙_ _⊕_ : A → A → A) : Set where
  constructor distributiveᴸ
  field
    distribᴸ : ∀ {a b c} → a ⊙ (b ⊕ c) ≃ (a ⊙ b) ⊕ (a ⊙ c)

open Distributiveᴸ {{...}} public using (distribᴸ)

{- Equivalences -}
compatible₂→isCompatible₂ :
  {A B : Set} {f : A → B} {_⊙_ : A → A → A}
    {{_ : Eq B}} {{r : Compatible₂ f _⊙_}} →
      let open Compatible₂ r using (_⊕_) in IsCompatible₂ f _⊙_ _⊕_
compatible₂→isCompatible₂ = isCompatible₂ compat₂

isCompatible₂→compatible₂ :
  {A B : Set} {f : A → B} {_⊙_ : A → A → A} {_⊕_ : B → B → B}
    {{_ : Eq B}} {{_ : IsCompatible₂ f _⊙_ _⊕_}} →
      Compatible₂ f _⊙_
isCompatible₂→compatible₂ {_⊕_ = _⊕_} = compatible₂ _⊕_ private-compat₂

distributiveᴸ→isCompatible₂ :
  {A : Set} {_⊙_ _⊕_ : A → A → A} {{_ : Eq A}} {{_ : Distributiveᴸ _⊙_ _⊕_}} →
    ∀ {a} → IsCompatible₂ (a ⊙_) _⊕_ _⊕_
distributiveᴸ→isCompatible₂ {a} = isCompatible₂ distribᴸ

isCompatible₂→distributiveᴸ :
  {A : Set} {_⊙_ _⊕_ : A → A → A}
    {{_ : Eq A}} {{_ : ∀ {a} → IsCompatible₂ (a ⊙_) _⊕_ _⊕_}} →
      Distributiveᴸ _⊙_ _⊕_
isCompatible₂→distributiveᴸ = distributiveᴸ private-compat₂
