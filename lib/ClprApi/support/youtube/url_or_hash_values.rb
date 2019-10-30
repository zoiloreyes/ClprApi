module ClprApi
  module Support
    module Youtube
      module UrlOrHashValues
        def hash
          return nil if !valid?

          if url_or_hash =~ URI::regexp
            hash_from_parsed_url
          else
            url_or_hash
          end
        end

        def hash_with_time
          @hash_with_time ||= time ? "#{hash}&t=#{time}" : hash
        end

        def time
          @time ||= query_value("t")
        end

        private

        def hash_from_parsed_url
          @hash_from_parsed_url ||= query_value("v") || hash_from_embed_url
        end

        def hash_from_embed_url
          path = parsed_url.path.sub("/", "")
          path.include?("embed") ? path.gsub("embed/", "") : path
        end

        def parsed_url
          @parsed_url ||= Addressable::URI.parse(url_or_hash)
        end

        def query
          @query ||= CGI::parse(parsed_url.query || "")
        end

        def query_value(key)
          values = query.select { |x| x == key }.values
          values.first.first if values.any?
        end
      end
    end
  end
end
