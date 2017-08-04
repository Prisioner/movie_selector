# Фильм
class Film
  attr_reader :title, :film_director, :year, :link, :length, :country, :genre, :rating

  def self.from_html(html_node)
    film_data = {}

    film_data[:title] = html_node.search("a[@class='all']").text

    link = html_node.search("a[@class='all']").attribute("href").value
    film_data[:link] = "https://www.kinopoisk.ru#{link}"

    year_length = html_node.search("div[@style='margin-bottom: 9px']").text
    film_data[:year] = year_length.match(/\d{4}/)[0].to_i
    film_data[:length] = year_length.match(/\d+ мин\./).to_s

    # ["США," "реж. Фрэнк Дарабонт", "(драма, криминал)"]
    country_director_genre = html_node.search("span[@class='gray_text']")[0].text.strip.split("\n").map(&:strip)
    film_data[:country] = country_director_genre[0].chomp(",").chomp("...")
    film_data[:director] = country_director_genre[1][5..-1].chomp("...")
    film_data[:genre] = country_director_genre[2].delete("()").chomp("...")

    film_data[:rating] = html_node.search("span[@class='all']").text

    new(film_data)
  end

  # Основной конструктор класса
  def initialize(opts)
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
