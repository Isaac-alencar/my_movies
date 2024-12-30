class Genre < ApplicationRecord
  belongs_to :movies, class_name: "Movie", foreign_key: "genre_ids"
end
