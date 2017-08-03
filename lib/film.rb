# Фильм
class Film
  attr_reader :title, :film_director, :year, :link, :length, :country, :genre, :rating

  def self.from_html_string(html_string)
    return if html_string.nil? || html_string.empty?

    film_data = {}

    # <a ... href="/film/326/" class="all">Побег из Шоушенка</a>
    # ["/film/326/", "Побег из Шоушенка"]
    pattern = /<a.*?href=\"(\/film\/\d+\/)\" class=\"all\">(.*?)<\/a>/
    link_title = html_string.scan(pattern).flatten

    # https://www.kinopoisk.ru/film/326/
    film_data[:link] = "https://kinopoisk.ru#{link_title[0]}"
    film_data[:title] = link_title[1]

    # <span ... (1994) ... 142 мин.
    # ["1994", "142 мин."]
    pattern = /<span .*? \((\d{4})\).*?(\d+ мин\.)/
    year_length = html_string.scan(pattern).flatten

    film_data[:year] = year_length[0].to_i
    film_data[:length] = year_length[1]

    # <span class="gray_text"> ... </span>
    # ["США," "<i>реж. ... Фрэнк Дарабонт</a></i><br />", "(драма, криминал)"]
    pattern = /<span class=\"gray_text\">(.*?)<\/span>/mi
    country_director_genre = html_string.scan(pattern)[0][0]
    country_director_genre = country_director_genre.strip.split("\n").map(&:strip)

    film_data[:country] = country_director_genre[0].chomp(",").chomp("...")
    film_data[:director] = country_director_genre[1].match(/<a .*?>(.*?)<\/a>/)[1]
    film_data[:genre] = country_director_genre[2].delete("()").chomp("...")

    #  <span class="all" style="color: #fff; cursor:default;">9.065
    pattern = /<span class=\"all\".*?>([\d\.]+)/
    film_data[:rating] = html_string.match(pattern)[1]

    new(film_data)
  end

  # Основной конструктор класса
  def initialize(opts = {})
    @title = opts[:title]
    @film_director = opts[:director]
    @year = opts[:year]
    @link = opts[:link]
    @length = opts[:length]
    @country = opts[:country]
    @genre = opts[:genre]
    @rating = opts[:rating]
  end

  def to_s
    <<~FILM_INFO
    фильм: #{title} (#{year}, #{length}, #{country})
    жанр: #{genre}
    реж: #{film_director}
    рейтинг: #{rating}
    #{link}
    FILM_INFO
  end
end
