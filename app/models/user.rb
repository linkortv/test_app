class User < ApplicationRecord
    has_and_belongs_to_many :interests
    has_and_belongs_to_many :skills

    validates :email, presence: true, uniqueness: true
end
