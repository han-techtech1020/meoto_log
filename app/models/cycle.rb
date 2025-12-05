class Cycle < ActiveHash::Base
  self.data = [
    { id: 1, name: 'キラキラ期（好調・排卵前）' },
    { id: 2, name: 'イライラ期（PMS・生理前）' },
    { id: 3, name: 'どんより期（腹痛・生理中）' },
    { id: 4, name: '不安定（産後・不順など）' },
    { id: 5, name: 'わからない・観察中' } # ← これが大事！
  ]

  include ActiveHash::Associations
  has_many :partner_statuses
end
