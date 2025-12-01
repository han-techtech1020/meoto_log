class Mood < ActiveHash::Base
  self.data = [
    { id: 1, name: '神様（全て許される）' },
    { id: 2, name: '天使（にこやかである）' },
    { id: 3, name: '平穏（穏やかである）' },
    { id: 4, name: '修羅（近づきがたい）' },
    { id: 5, name: '厄災（離れた方がよい）' }
  ]

  include ActiveHash::Associations
  has_many :partner_statuses
end
