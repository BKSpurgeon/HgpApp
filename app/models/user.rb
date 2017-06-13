class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  alias_attribute :student, :genius

  has_many :projects
  has_many :friendships
  has_many :friends, through: :friendships, class_name: "User"
  has_one :room
  has_one :cohort
  has_many :features
  has_many :messages

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, format: { with: /\.org\z/, message: "only allows HGP addresses" }
  after_create :create_chatroom

  self.per_page = 20

  def full_name
    [first_name, last_name].join(" ")
  end

  def self.search_by_name(name)
    names_array = name.split(' ')

    if names_array.size == 1
      where('first_name LIKE ? or last_name LIKE ?',
        "%#{names_array[0]}%", "%#{names_array[0]}%").order(:first_name)
    else
      where('first_name LIKE ? or first_name LIKE ? or last_name LIKE ?
        or last_name LIKE ?', "%#{names_array[0]}%",
        "%#{names_array[1]}%", "%#{names_array[0]}%",
        "%#{names_array[1]}%").order(:first_name)
    end
  end

  def follows_or_same?(new_friend)
    friendships.map(&:friend).include?(new_friend) || self == new_friend
  end

  def current_friendship(friend)
    friendships.where(friend: friend).first
  end

  private

  def create_chatroom
    hyphenated_username = self.full_name.split.join('-')
    Room.create(name: hyphenated_username, user_id: self.id)
  end
end