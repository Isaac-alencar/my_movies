class MovieFetcher
  MOVIES_API_BASE_URL = "https://api.themoviedb.org/".freeze

  attr_accessor :movies

  def initialize(http_client: nil)
    @http_client = http_client || default_http_client
  end

  def movies
    response = @http_client.get do |req|
      req.url "/3/movie/top_rated"
      req.params = { include_vide: false,
                    include_adult: false,
                    "vote_average.desc": "",
                    "vote_count.gte": 200,
                    page: current_page
                    }
      req.headers = { "Content-Type" => "application/json", "accept" => "application/json" }
    end

    last_fetched_page.update_attribute(:value, current_page + 1)

    @movies = JSON.parse(response.body)["results"]
  end

  private

    def default_http_client
      Faraday.new(url: MOVIES_API_BASE_URL) do |conn|
        conn.request :authorization, "Bearer", -> { ENV["TMDB_API_KEY"] }
      end
    end

    def current_page
      last_fetched_page&.value || 1
    end


    def last_fetched_page
      SystemConfig.find_or_initialize_by(key: "last_fetched_page")
    end
end
