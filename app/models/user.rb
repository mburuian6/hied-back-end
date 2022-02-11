class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

    # has_many :access_tokens,
    #          class_name: 'Doorkeeper::AccessToken',
    #          foreign_key: :resource_owner_id,
    #          dependent: :delete_all # or :destroy if you need callbacks

end