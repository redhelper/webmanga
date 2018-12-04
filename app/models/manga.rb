class Manga < ApplicationRecord
	validates :title, presence: true
	validates :mal_id, presence: true
	validates :img, presence: true
end
