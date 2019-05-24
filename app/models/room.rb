class Room < ApplicationRecord
  # instant booking -> if instant is 0 -> request booking otherwise instant
  enum instant: {Request: 0, Instant: 1}

  belongs_to :user

  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true

  has_many_attached :images
  has_many :reservations, dependent: :destroy
  has_many :guest_reviews, dependent: :destroy
  has_many :calendars

  geocoded_by :address
  # after_validation :geocode, if: :will_save_change_to_address?
  after_validation :geocode, if: :address_changed?

  def cover_photo(size)
    if self.images.attached? && self.images[0].variable?
      self.images[0].variant(size)
    else
      "placeholder.jpg"
    end
  end

  # double equal :)
  def avarage_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end
end

# 1. in listing -> I manage above validations
# 2. in form I require when updating: pricing, description, location(address), photo -> later on
# -> amenities (does not need to be part of equipment (like TV, heating)) => not there
# 3. using Active-storage (storage_blobs, storage_attachment(jointable)) = adding multiple images that will be associated with each room
# 4. cover_photo in index.html, attached from active storage
# 5. added two lines for google maps -> when changing address to apply new lat, lng
# 6. relations -> Reviews .. has_many guest_reviews (no need host + User model
# 7. avarage method -> avarage - rails method, taking star table, rounded and to integer
