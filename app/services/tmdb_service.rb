class TmdbService
  TMDB_API_KEY = ENV.fetch("TMDB_API_KEY")


  def popular_movies(page)
    fetch_api("/3/movie/popular", { params: { language: "en", page: page } })
  end

  def now_playing_movies(page)
    fetch_api("/3/movie/now_playing", { params: { language: "en", page: page } })
  end

  def top_rated_movies(page)
    fetch_api("/3/movie/top_rated", { params: { language: "en", page: page } })
  end

  def trending_movies(page)
    fetch_api("/3/trending/movie/day", { params: { language: "en", page: page } })
  end


  private

    def fetch_api(endpoint, params)
      response = connection.get(endpoint, config: {
        params: { include_video: false, include_adult: true }
      })

      data = parse_to_application_format(JSON.parse(response.body)["results"])

      save_data(data)
    end

    def save_data(data)
      data.each do |movie|
        new_movie = Movie.new(movie)

        raise "Error while saving #{movie["title"]} tmdb_id #{movie["title"]}" unless new_movie.valid?

        new_movie.save!
      end
    end

    def connection(query_params = {})
      Faraday.new(
        url: "https://api.themoviedb.org/",
        params: query_params[:params],
        headers: ({
          "Content-Type" => "application/json",
          "accept" => "application/json",
          "Authorization" => "Bearer #{TMDB_API_KEY}"
        })
      )
    end

    def parse_to_application_format(data = [])
      data.map do |data|
        {
          tmdb_id: data["id"],
          title: data["title"],
          overview: data["overview"],
          genres_id: data["genre_ids"],
          vote_count: data["vote_count"],
          vote_average: data["vote_average"],
          release_date: data["release_date"],
          poster_path: "https://image.tmdb.org/t/p/w500/#{data["poster_path"]}"
        }
      end
    end
end
