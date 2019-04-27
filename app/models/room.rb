class Room < ApplicationRecord
  belongs_to :user

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true

  has_many_attached :images

  def cover_photo(size)
    if self.images.attached? && self.images[0].variable?
      self.images[0].variant(size)
    else
      "placeholder.jpg"
    end
  end
end

# 1. in listing -> I manage above validations
# 2. in form I require when updating: pricing, description, location(address), photo -> later on
# -> amenities (does not need to be part of equipment (like TV, heating)) => not there
# 3. using Active-storage (storage_blobs, storage_attachment(jointable)) = adding multiple images that will be associated with each room
# 4. cover_photo in index.html, attached from active storage
