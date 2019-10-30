module ClprApi
  module Support
    module Youtube
      module UrlOrHashValidation
        VALID_YOUTUBE_HOSTS = ["youtube.com", "youtu.be", "www.youtube.com", "m.youtube.com"]

        VALID_HASH_REGEX = /^[a-zA-Z0-9_-]*$/

        def valid?
          return true if url_or_hash =~ URI::regexp && valid_domain? && hash_from_parsed_url.present?
          return true if url_or_hash =~ VALID_HASH_REGEX
          return false
        end

        def valid_domain?
          VALID_YOUTUBE_HOSTS.include?(parsed_url.hostname.downcase)
        end
      end
    end
  end
end
