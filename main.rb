# Киновыбиратель

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

require_relative 'lib/film'
require_relative 'lib/film_loader'
require_relative 'lib/user_io'

user_io = UserIO.new

user_io.output("\n", "Программа «Фильм на вечер»\n", "Формируем список фильмов...")

page = rand(1..10)
url = "https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/perpage/50/page/#{page}/"
films_arr = FilmLoader.from_url(url)

# Группируем по режиссёрам
films = films_arr.group_by { |film| film.film_director }

directors_list = films.keys.map.with_index { |director, index| "#{index + 1}. #{director}" }.join("\n")

user_io.output(nil, directors_list)

user_choice = 0
until user_choice.between?(1,films.keys.size)
  user_choice = user_io.input("Фильм какого режиссёра Вы бы хотели посмотреть? (укажите номер из списка)")
  user_choice = user_choice.to_i
end

# Определяем выбранного режиссёра и случайный фильм
director = films.keys[user_choice - 1]
film = films[director].sample

user_io.output("\n", "Рекомендуем к просмотру:", film, "Желаем приятного просмотра!")
