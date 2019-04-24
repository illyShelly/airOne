class Room < ApplicationRecord
  belongs_to :user

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
end

# 1. in listing -> I manage above validations
# 2. in form I require when updating: pricing, description, location(address), photo -> later on
# -> amenities (does not need to be part of equipment (like TV, heating)) => not there
