# -*- coding: utf-8 -*-
# Ukrainian transliteration for Jekyll
module Jekyll
  class UA
    MAP = { 
      'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'h', 'ґ' => 'g', 'д' => 'd', 
      'е' => 'e', 'є' => 'ya', 'ж' => 'zh', 'з' => 'z', 'и' => 'y',
      'і' => 'i', 'й' => 'j', 'ї' => 'yi', 'к' => 'k', 'л' => 'l', 
      'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r', 
      'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'kh', 
      'ц' => 'ts', 'ч' => 'ch', 'ш' => 'sh', 'щ' => 'shch', 
      'ю' =>'yu', 'я' => 'ya',

      'А' => 'A', 'Б' => 'B', 'В' => 'V', 'Г' => 'H', 'Ґ' => 'G', 
      'Д' => 'D', 'Е' => 'E', 'Є' => 'YA', 'Ж' => 'ZH', 'З' => 'Z',
      'И' => 'Y', 'І' => 'I', 'Й' => 'J', 'Ї' => 'YI', 'К' => 'K', 
      'Л' => 'L', 'М' => 'M', 'Н' => 'N', 'О' => 'O', 'П' => 'P', 
      'Р' => 'R', 'С' => 'S', 'Т' => 'T', 'У' => 'U', 'Ф' => 'F', 
      'Х' => 'KH', 'Ц' => 'TS', 'Ч' => 'CH', 'Ш' => 'SH', 'Щ' => 'SHCH', 
      'Ю' => 'YU', 'Я' => 'YA'
    }

    def self.transliterate input, ext='html'
      return '' unless input
      # text = input.split('').map {  |x| MAP[x] }.join
      text = input.dup
      MAP.keys.each do |key|
        text.gsub!(/#{key}/, MAP[key])
      end
      text = text.gsub(/\s+/, '_') + ".#{ext}"
    end
    
  end

end

