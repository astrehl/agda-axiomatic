open import Agda.Builtin.FromNat using (Number)
import Agda.Builtin.Nat as Nat
open import Function using (const)
open import net.cruhland.axioms.Peano.Base
  using () renaming (Peano to PeanoBase)
open import net.cruhland.models.Logic using (⊤)

module net.cruhland.axioms.Peano.Literals (PB : PeanoBase) where
  open PeanoBase PB using (ℕ; step; zero)

  fromNat : Nat.Nat → {{_ : ⊤}} → ℕ
  fromNat Nat.zero = zero
  fromNat (Nat.suc n) = step (fromNat n)

  instance
    number : Number ℕ
    number = record { Constraint = const ⊤ ; fromNat = fromNat }