class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :presence

  def presence
    @presence ||= false
  end

  default_scope { order(:first_name, :last_name) }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :joins, dependent: :destroy
  has_many :chats, through: :joins,
                   source: :joinable,
                   source_type: "Chat"
  has_many :messages
  has_many :presence_connections

  validates_presence_of :first_name, :last_name, :handle

  def full_name
    "#{first_name} #{last_name}"
  end

  def contacts
    query = ContactsQuery.new self
    query.call
  end

  def data
    slice(included_columns)
  end

  def data_with_presence_fields
    slice(included_columns + [:presence, :last_seen])
  end

  def complete_data
    slice(*included_columns, :email, :visibility)
  end

  private 

  def included_columns
    [:id,
     :first_name,
     :last_name,
     :full_name,
     :handle]
  end
end
