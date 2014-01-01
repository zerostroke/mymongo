require 'bcrypt'

class User
  include Mongoid::Document
  include BCrypt
  
  attr_accessor :password

  before_save :encrypt_password
  after_save :clear_password

  field :name, type: String
  field :email, type: String
  field :password_salt, type: String
  field :password_hash, type: String

  EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
  validates :name, :presence => true, :uniqueness => true, :length => { :in => 3..40 }
  validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
  validates :password, :confirmation => true
  validates_length_of :password, :in => 6..20, :on => :create

  def self.authenticate(email="", password="")
    user = User.where(:email => email).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      return user
    else
      return nil
    end
  end

  def encrypt_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def clear_password
    self.password = nil
  end

end
