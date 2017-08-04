# Формирует массив фильмов
require 'net/http'
require 'nokogiri'

class FilmLoader
  def self.from_url(url = "https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/perpage/100/page/1/")
    uri = URI.parse(url)
    response = Net::HTTP.get(uri).encode("utf-8", "windows-1251")

    html_doc = Nokogiri::HTML(response)

    films_list = html_doc.search("//tr[starts-with(@id, 'tr_')]")

    films_list.map { |film_node| Film.from_html(film_node) }
  end
end
