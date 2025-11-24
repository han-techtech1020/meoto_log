class Mood < ActiveHash::Base
  self.data = [
    { id: 1, name: '最高（女神）' },
    { id: 2, name: '普通（平穏）' },
    { id: 3, name: 'やや不機嫌（要注意）' },
    { id: 4, name: '不機嫌（鬼のような人）' },
    { id: 5, name: '激怒（人のような鬼）' }
  ]

  include ActiveHash::Associations
  has_many :partner_statuses
end
