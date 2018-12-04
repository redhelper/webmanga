class Manga < ApplicationRecord
	belongs_to :user
	validates :title, presence: true
	validates :mal_id, presence: true
	validates :img, presence: true
	validates :m_type, presence: true
end
