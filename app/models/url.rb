class Url < ApplicationRecord
	validates_presence_of :long_url, :slug
end
