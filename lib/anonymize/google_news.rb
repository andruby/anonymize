require 'google-search'

module Anonymize::GoogleNews
  class << self
    def related_news(text, char_count = text.length)
      words = longest_words(text)
      new_text = ""
      until new_text.length >= char_count
        Google::Search::News.new(:query => [words.pop, words.pop].join(' ')).each do |result|
          new_text << utf8_to_ascii(strip_html(result.content))
          break if new_text.length >= char_count
        end
      end
      new_text[0..(char_count-1)]
    end

    def longest_words(text)
      strip_html(text).scan(/\w+/).uniq.sort_by(&:length)
    end

    def utf8_to_ascii(string)
      string.encode('ascii', 'utf-8', :undef => :replace, :invalid => :replace, :replace => '')
    end

    def strip_html(string)
      string.gsub(/<[^>]+>/,'')
    end
  end
end