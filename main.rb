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
films = []

loop do
  page = rand(1..5)
  url = "https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/perpage/100/page/#{page}/"

  # Данные кэшируются, если возникнет необходимость сделать доп. заход
  # films[page] ||= [<#Film >, <#Film >, ...]
  films[page] ||= FilmLoader.from_url(url)

  user_io.output("\n\n", "Предлагаю сегодня посмотреть:", films[page].sample)

  choice = user_io.input("Смотрим? (y/n)")
  break if choice.downcase == 'y'
end

user_io.output(nil, "Желаем приятного просмотра!")
