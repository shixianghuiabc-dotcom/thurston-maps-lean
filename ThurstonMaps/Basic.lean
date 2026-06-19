import Mathlib.Analysis.Complex.Basic
import Mathlib.Topology.Basic
import Mathlib.Data.Set.Finite.Basic

namespace ThurstonMaps

open Set Function

/-- 复平面中的单位圆盘 𝔻 -/
def unitDisk : Set ℂ := Metric.ball 0 1

/-- 一个简化的分歧覆盖映射结构。 -/
structure BranchedCover (S : Type*) [TopologicalSpace S] (f : S → S) where
  continuous : Continuous f
  deg : S → ℕ+  -- 本地度数
  hasCriticalPoints : ∃ x : S, deg x ≥ 2

/-- Thurston 映射的后临界点集。 -/
def postcriticalSet {S : Type*} [TopologicalSpace S]
    (f : S → S) (bc : BranchedCover S f) : Set S :=
  ⋃ n > 0, (f^[n]) '' {x | bc.deg x ≥ 2}


theorem postcriticalSet_nonempty {S : Type*} [TopologicalSpace S]
    {f : S → S} (bc : BranchedCover S f) :
    (postcriticalSet f bc).Nonempty := by
  rcases bc.hasCriticalPoints with ⟨x, hx⟩
  refine ⟨f x, ?_⟩
  have h01 : 0 < 1 := Nat.succ_pos 0
  exact ⟨1, h01, ⟨x, hx, rfl⟩⟩


/-- 拓扑 2-球面的判定。 -/
def IsTopologicalSphere (S : Type*) [TopologicalSpace S] : Prop :=
  Nonempty (S ≃ₜ Metric.sphere (0 : Fin 3 → ℝ) 1)

/-- Thurston 映射的基本定义。 -/
structure ThurstonMap (S : Type*) [TopologicalSpace S] [CompactSpace S] [T2Space S] (f : S → S) where
  isSphere : IsTopologicalSphere S
  branchedCover : BranchedCover S f
  notHomeo : ¬ Bijective f
  postFinite : (postcriticalSet f branchedCover).Finite

end ThurstonMaps
