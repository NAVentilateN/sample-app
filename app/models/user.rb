class User < ApplicationRecord
  # create a memory of remember token without storing it in the database 
  attr_accessor :remember_token 
  
  before_save { self.email = email.downcase }
  
  VALID_EMAIL_REGEX= /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  validates :first_name, :last_name, presence: true
  validates :name, presence: true, uniqueness:{case_sensetive:false}, length: { maximum: 20 }
  validates :email , presence: true, uniqueness:{case_sensetive:false},format:{with:VALID_EMAIL_REGEX,multiline:true}
  validates :password, presence:  true, length: { minimum: 6 }
  
  has_secure_password
  
  # Returns the hash digest of the given string.
  # A generic method to be used for multiple use cases 
  # (Bridge Design Pattern)
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Create a random token. This is kept generic so whenever a new token 
  # is required to be generate, method can be used. This is not a specific 
  # method. (Bridge Design Pattern)
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  # remember a user in the database for use in persistent sessions
  def remember
    # Self is required here if not this will be a local variable
    # that is only usable in the method.
    # having a self here will make it model attribute
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def session_token
    remember_digest || remember
  end
  
  # to authenticate user using cookies
  def authenticate?(remember_token)
    # In Bcrypt, the comparator method "==" have been redefine
    # instead of comparing first encrypting the token to compare
    # it looks like it is decrypting the digested token and comparing 
    # THIS IS A SECURITY ISSUE
    # but the redefine comparator actually encrypt the remember token
    # and compare both encrypted token. Therefore NOT exposing the 
    # previously store remember token at all
    # this should set to return false if remember digest is nil
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
