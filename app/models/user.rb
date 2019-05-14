class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         # :confirmable,
         :omniauthable, omniauth_providers: %i[facebook]
  validates :fullname, presence: true, length: { maximum: 50 }

  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy

  has_many :guest_reviews, class_name: "GuestReview", foreign_key: "guest_id"
  has_many :host_reviews, class_name: "HostReview", foreign_key: "host_id"

  def self.from_omniauth(auth)
    # check if user already has email created by FB
    user = User.where(email: auth.info.email).first
    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20] # generated random password when signup FB
        user.fullname = auth.info.name   # assuming the user model has a name
        user.image = auth.info.image # assuming the user model has an image
        user.uid = auth.uid
        user.provider = auth.provider
        # If you are using confirmable and the provider(s) you use validate emails,
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      end
    end
  end

  def generate_pin
    # create new random pin number assign to user object's pin ...
    self.pin = SecureRandom.hex(2)
    self.phone_verified = false
    save
  end

  # when user save his phone number -> twilio generate message send to him
  def send_pin
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: '+447429169492',
      to: self.phone_number,
      body: "Your pin is #{self.pin}"
    )
  end

  # column changed to true if confirmed pin match our generated pin in DB
  def verify_pin(entered_pin)
    update(phone_verified: true) if self.pin == entered_pin
  end
end

# 1. validation
# 2. fb login
# 3. generated Rooms -> association
# 4. has_many guest and host reviews
