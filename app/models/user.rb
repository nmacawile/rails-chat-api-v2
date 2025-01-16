class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  default_scope { order(:first_name, :last_name) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :joins, dependent: :destroy
  has_many :chats, through: :joins,
                   source: :joinable,
                   source_type: "Chat"
  has_many :messages

  validates_presence_of :first_name, :last_name, :handle

  def full_name
    "#{first_name} #{last_name}"
  end

  def contacts
    query = ContactsQuery.new self
    query.call
  end

  def data
    slice(:id, :first_name, :last_name, :full_name, :handle)
  end

  def complete_data
    slice(:id, :first_name, :last_name, :full_name, :handle, :email)
  end
end
