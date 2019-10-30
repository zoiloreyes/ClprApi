module ClprApi
  module Support
    module Youtube
      class Url
        class InvalidYoutubeUrl < StandardError; end

        YOUTUBE_URL = "https://www.youtube.com/watch?v="
        YOUTUBE_EMBED_URL = "https://www.youtube.com/embed/"

        include UrlOrHashValues
        include UrlOrHashValidation

        attr_reader :url_or_hash

        def initialize(url_or_hash)
          @url_or_hash = url_or_hash.strip.gsub("?#/", "") #this gsub is to normalize the urls from Youtube mobile links
        end

        def self.valid?(url_or_hash)
          new(url_or_hash).valid?
        end

        def video_url
          @video_url ||= "#{YOUTUBE_URL}#{hash_with_time}" if valid?
        end

        def embed_url
          @embed_url ||= "#{YOUTUBE_EMBED_URL}#{hash_with_time}" if valid?
        end
      end
    end
  end
end
