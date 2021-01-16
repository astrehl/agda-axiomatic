module net.cruhland.axioms.AbstractAlgebra.Inverse where

open import net.cruhland.axioms.AbstractAlgebra.Reductive using
  (Identityᴸ; Identityᴿ)
open import net.cruhland.axioms.Eq as Eq using (_≃_; Eq)
open import net.cruhland.models.Function using (ConstrainableFn; toConstrainedFn)

record Inverseᴸ
    {A F : Set} {{cf : ConstrainableFn F}} {{_ : Eq A}} (inv : F) : Set where
  constructor inverseᴸ
  field
    {_⊙_} : A → A → A
    {e} : A
    {{idᴸ}} : Identityᴸ _⊙_ e
    {{idᴿ}} : Identityᴿ _⊙_ e
    invᴸ : ∀ {a} {{c : ConstrainableFn.C cf a}} → toConstrainedFn inv a ⊙ a ≃ e

open Inverseᴸ {{...}} public using (invᴸ)

record Inverseᴿ {A : Set} (inv : A → A) : Set₁ where
  constructor inverseᴿ
  field
    {_⊙_} : A → A → A
    {e} : A
    {{eq}} : Eq A
    {{idᴸ}} : Identityᴸ _⊙_ e
    {{idᴿ}} : Identityᴿ _⊙_ e
    invᴿ : ∀ {a} → a ⊙ inv a ≃ e

open Inverseᴿ {{...}} public using (invᴿ)
