require 'rspec'
require 'film'
require 'film_loader'

describe FilmLoader do
  let(:film_list_file) { "#{__dir__}/fixtures/list.html" }
  let(:response_placeholder) { File.read(film_list_file, encoding: "windows-1251") }

  describe '.from_url' do
    it 'should return array of films from html page' do
      allow(Net::HTTP).to receive_messages(get: response_placeholder)
      films = FilmLoader.from_url("https://www.some.url/")

      expect(films.size).to eq 10
      expect(films).to all be_an(Film)

      titles = films.map(&:title)
      expect(titles).to contain_exactly(
                          "Зеленая миля", "Побег из Шоушенка", "Форрест Гамп",
                          "Список Шиндлера", "1+1", "Начало", "Король Лев",
                          "Леон", "Бойцовский клуб", "Жизнь прекрасна"
                        )
    end
  end
end
