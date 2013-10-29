# -*- coding: utf-8 -*-
# Ukrainian transliteration for Jekyll
module Jekyll
  module Transliterate
    
    # Convert string into ASCII only filename.
    def transliterate *args
      ::Jekyll::UA.transliterate *args
    end

    alias t14e transliterate
  end
end

Liquid::Template.register_filter(Jekyll::Transliterate)
