class FetchMoviesDataJob
  include Sidekiq::Job

  def perform(*args)
    tmdb_service = TmdbService.new

    page = last_fetched_page&.value || 1

    tmdb_service.popular_movies(page)
    tmdb_service.now_playing_movies(page)
    tmdb_service.trending_movies(page)
    tmdb_service.top_rated_movies(page)

    last_fetched_page.update_attribute(:value, page + 1)
  end

  def last_fetched_page
    SystemConfig.find_or_initialize_by(key: "last_fetched_page")
  end
end
