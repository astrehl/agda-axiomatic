module net.cruhland.axioms.DecEq where

open import Level using () renaming (suc to sℓ)
open import net.cruhland.axioms.Eq using (_≃_; Eq)
open import net.cruhland.models.Logic using (Dec)

record DecEq {α} (A : Set α) : Set (sℓ α) where
  infix 4 _≃?_
  field
    {{eq}} : Eq A
    Constraint : A → A → Set α
    _≃?_ : (x y : A) {{_ : Constraint x y}} → Dec (x ≃ y)

open DecEq {{...}} public
