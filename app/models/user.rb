class User < ActiveRecord::Base
  attr_accessor :current_password, :new_password, :confirm_new_password
  before_update :check_password
  has_many :books
  has_many :checkout_histories
  has_secure_password
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
# #TODO can put more validation for password strength
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  private
  def check_password
    is_ok = self.password.nil? || self.password.empty? || self.password.length >= 6

    self.errors[:password] << "Password is too short (minimum is 6 characters)" unless is_ok

    is_ok # The callback returns a Boolean value indicating success; if it fails, the save is blocked
  end
end
