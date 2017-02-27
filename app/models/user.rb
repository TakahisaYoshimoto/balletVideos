class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #validates :email, uniqueness: true

  has_many :users
  has_many :likes, dependent: :destroy
  has_many :view_histories
end
