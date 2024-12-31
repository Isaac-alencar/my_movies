class MovieParser
  def initialize(mapping = default_mapping)
    @mapping = mapping
  end

  def parse(data)
    movie_poster_path_value = "https://image.tmdb.org/t/p/w500".freeze
    @mapping.each_with_object({}) do |(key, path), parsed_data|
      value = extract_value(data, path)

      if key.to_sym == :poster_path
        parsed_data[key] = "#{movie_poster_path_value}/#{value}"
        next
      end

      parsed_data[key] = value
    end
  end

  private

    def extract_value(data, path)
      path.split(".").reduce(data) { |memo, key| memo[key] }
    end

    def default_mapping
      {
        tmdb_id: "id",
        title: "title",
        overview: "overview",
        genres_id: "genre_ids",
        vote_count: "vote_count",
        vote_average: "vote_average",
        release_date: "release_date",
        poster_path: "poster_path"
      }
    end
end
