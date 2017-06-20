class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  #validates :email, uniqueness: true
  validate :rule_confirmed_valid?

  has_many :users
  has_many :likes, dependent: :destroy
  has_many :board_likes, dependent: :destroy
  has_many :view_histories
  has_many :comments
  has_many :boards
  has_many :board_comments

  validates :profile, length: {maximum: 1000}
  validates :username, uniqueness: true

  paginates_per 30  # 1ページあたり30項目表示

  private
    def rule_confirmed_valid?
      errors.add(:rule_confirmed, 'に同意して頂かない場合は、登録できません。') unless rule_confirmed == true
    end
end
