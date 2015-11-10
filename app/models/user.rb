class User < ActiveRecord::Base
  has_many :favorites, dependent: :destroy
  attr_accessor :remember_token

  #First we have to make sure, the user doesn't already exist and every information is correctly entered (no same e-mail, and all e-mail recorded in downcase for example)
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: {minimum: 6}, allow_blank: true

  # Returns the hash digest of the given string (To hash password/remember tokens before saving them)
  def User.digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
  end

  #Methods for the "remember" checkbox
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:rember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
      update_attribute(:rember_digest, nil)
    end

  #If the Facebook user is not registered yet in database, we add him
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.password = auth.uid
      user.name     = auth.info.name
      user.email    = auth.info.email.nil? ? "#{auth.uid}@facebook.com" : auth.info.email
      user.save!
    end
  end

end
