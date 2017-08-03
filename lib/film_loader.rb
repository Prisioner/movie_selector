# Формирует хэш-массив фильмов
require 'net/http'

class FilmLoader
  def self.from_url(url)
    uri = URI.parse(url)
    response = Net::HTTP.get(uri).encode("utf-8", "windows-1251")

    # <tr id="tr_326" > ... </tr>
    films_list = response.scan(/id=\"tr_\d+\" >(.*?)<\/tr>/mi).flatten

    films_list.map { |film_string| Film.from_html_string(film_string) }
  end
end
