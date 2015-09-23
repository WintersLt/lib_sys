class User < ActiveRecord::Base
  #attr_accessor :name, :email, :password, :password_confirmation, :is_admin, :is_lib_member
# attr_accessor :password
# attr_accessor :password_confirmation
  has_secure_password
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
# #TODO can put more validation for password strength
  validates :password, presence: true, length: { minimum: 6 }
end
