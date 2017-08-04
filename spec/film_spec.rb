require 'rspec'
require 'film'
require 'nokogiri'

describe Film do
  let(:data_hash) {
    {
      title: "Побег из Шоушенка",
      director: "Фрэнк Дарабонт",
      year: 1994,
      link: "https://www.kinopoisk.ru/film/326/",
      length: "142 мин.",
      country: "США",
      genre: "драма, криминал",
      rating: "9.115 (427 892)"
    }
  }
  let(:film_info) {
    <<~FILM_INFO
    фильм: Побег из Шоушенка (1994, 142 мин., США)
    жанр: драма, криминал
    реж: Фрэнк Дарабонт
    рейтинг: 9.115 (427 892)
    https://www.kinopoisk.ru/film/326/
    FILM_INFO
  }
  let(:film_file) { "#{__dir__}/fixtures/film_html_node.txt" }
  let(:file_content) { File.read(film_file, encoding: "UTF-8") }
  let(:film_html_node) { Nokogiri::HTML(file_content) }

  describe '.from_html' do
    it 'assigns instance variables' do
      film = Film.from_html(film_html_node)
      expect(film).to have_attributes(
                        title: "Король Лев",
                        film_director: "Роджер Аллерс",
                        year: 1994,
                        link: "https://www.kinopoisk.ru/film/2360/",
                        length: "88 мин.",
                        country: "США",
                        genre: "мультфильм, мюзикл, драма",
                        rating: start_with("8.775 (279")
                      )
      expect(film.rating).to end_with("377)")
    end
  end

  describe '#initialize' do
    it 'assigns instance variables' do
      film = Film.new(data_hash)
      expect(film).to have_attributes(
                        title: "Побег из Шоушенка",
                        film_director: "Фрэнк Дарабонт",
                        year: 1994,
                        link: "https://www.kinopoisk.ru/film/326/",
                        length: "142 мин.",
                        country: "США",
                        genre: "драма, криминал",
                        rating: "9.115 (427 892)"
                      )
    end
  end

  describe '#to_s' do
    it 'returns film info in right format' do
      film = Film.new(data_hash)
      expect(film.to_s).to eq film_info
    end
  end
end
