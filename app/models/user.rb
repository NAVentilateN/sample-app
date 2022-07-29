class User < ApplicationRecord
  # create a memory of remember token without storing it in the database 
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy
  
  has_many :passive_relationships, class_name: "Relationship", 
                                  foreign_key: "followed_id", 
                                  dependent: :destroy
                                  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  VALID_EMAIL_REGEX= /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  validates :first_name, :last_name, presence: true
  validates :name, presence: true, uniqueness:{case_sensetive:false}, length: { maximum: 50 }
  validates :email , presence: true, uniqueness:{case_sensetive:false},format:{with:VALID_EMAIL_REGEX,multiline:true}
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_secure_password
  
  # Returns the hash digest of the given string.
  # A generic method to be used for multiple use cases 
  # (Bridge Design Pattern
  
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
    self.remember_token ||= User.new_token
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
  def authenticate?(attribute, token)
    # In Bcrypt, the comparator method "==" have been redefine
    # instead of comparing first encrypting the token to compare
    # it looks like it is decrypting the digested token and comparing 
    # THIS IS A SECURITY ISSUE
    # but the redefine comparator actually encrypt the remember token
    # and compare both encrypted token. Therefore NOT exposing the 
    # previously store remember token at all
    # this should set to return false if remember digest is nil
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def activate
    # update_attribute(:activated, true) 
    # update_attribute(:activated_at, Time.zone.now)
    update_columns(activated: true, activated_at: Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
                     .includes(:user, image_attachment: :blob)
  end

  def follow(other_user)
    following << other_user unless self == other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  # 
  private
  # this is a Class method but within it, it call on self referring to the class instance
  def create_activation_digest
    # Create the token and digest.
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
  
  def downcase_email
    self.email = email.downcase
  end
end
