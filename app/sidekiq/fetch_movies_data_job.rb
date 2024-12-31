class FetchMoviesDataJob
  include Sidekiq::Job

  def perform(*args)
    tmdb_service = TmdbService.new

    tmdb_service.movies.each { |movie| save_movie(movie) }
  end

  def save_movie(movie)
    new_movie = Movie.new(movie)

    new_movie.save if new_movie.valid?
  end
end
