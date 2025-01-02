class TmdbService
  def initialize(fetcher: MovieFetcher.new, parser: MovieParser.new)
    @fetcher = fetcher
    @parser = parser
  end

  def movies
    parse_to_application_format(@fetcher.movies)
  end

  private
    def parse_to_application_format(data = [])
      data.map { |movie| @parser.parse(movie) }
    end
end
