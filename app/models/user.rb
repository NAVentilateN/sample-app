class User < ApplicationRecord
  before_save { self.email = email.downcase }
  
  VALID_EMAIL_REGEX= /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  
  validates :first_name, :last_name, presence: true
  validates :name, presence: true, uniqueness:{case_sensetive:false}, length: { maximum: 20 }
  validates :email , presence: true, uniqueness:{case_sensetive:false},format:{with:VALID_EMAIL_REGEX,multiline:true}
  validates :password, presence:  true, length: { minimum: 6 }
  
  has_secure_password
end
