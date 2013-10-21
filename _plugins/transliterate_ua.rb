# -*- coding: utf-8 -*-
module Jekyll
  module TransliterateUA

    LETTERS = { 

      'а' => 'a',
      'б' => 'b',
      'в' => 'v',
      'г' => 'h',
      'ґ' => 'g',
      'д' => 'd',
      'е' => 'e',
      'є' => 'ya',
      'ж' => 'zh',
      'з' => 'z',
      'и' => 'y',
      'і' => 'i',
      'й' => 'j',
      'ї' => 'yi',
      'к' => 'k',
      'л' => 'l',
      'м' => 'm',
      'н' => 'n',
      'о' => 'o',
      'п' => 'p',
      'р' => 'r',
      'с' => 's',
      'т' => 't',
      'у' => 'u',
      'ф' => 'f',
      'х' => 'kh',
      'ц' => 'ts',
      'ч' => 'ch',
      'ш' => 'sh',
      'щ' => 'shch',
      'ю' => 'yu',
      'я' => 'ya',

      'А' => 'A',
      'Б' => 'B',
      'В' => 'V',
      'Г' => 'H',
      'Ґ' => 'G',
      'Д' => 'D',
      'Е' => 'E',
      'Є' => 'YA',
      'Ж' => 'ZH',
      'З' => 'Z',
      'И' => 'Y',
      'І' => 'I',
      'Й' => 'J',
      'Ї' => 'YI',
      'К' => 'K',
      'Л' => 'L',
      'М' => 'M',
      'Н' => 'N',
      'О' => 'O',
      'П' => 'P',
      'Р' => 'R',
      'С' => 'S',
      'Т' => 'T',
      'У' => 'U',
      'Ф' => 'F',
      'Х' => 'KH',
      'Ц' => 'TS',
      'Ч' => 'CH',
      'Ш' => 'SH',
      'Щ' => 'SHCH',
      'Ю' => 'YU',
      'Я' => 'YA',
      "\s" => '_'
    }

    def transliterate input
      return '' unless input
      text = input.split('').map {  |x| LETTERS[x] }.join
      text
    end

    alias t14e transliterate
  end
end

Liquid::Template.register_filter(Jekyll::TransliterateUA)
