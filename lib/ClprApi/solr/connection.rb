require "singleton"
require "forwardable"

module ClprApi
  module Solr
    class Connection
      include Singleton
      extend Forwardable

      class << self
        attr_accessor :server_read_url, :server_write_url

        def config
          yield(self)
        end
      end

      class RecordNotFound < StandardError; end

      def_delegators :solr_read, :get
      def_delegators :solr_write, :add, :delete_by_id, :delete_by_query

      def solr_read
        @solr_read ||= RSolr.connect faraday_connection, url: self.class.server_read_url, update_format: :xml, read_timeout: 120, open_timeout: 120
      end

      def solr_write
        @solr_write ||= RSolr.connect faraday_connection, url: self.class.server_write_url, update_format: :xml, read_timeout: 120, open_timeout: 120
      end

      def find_by_id_with_params(id, params = {})
        results = get(:select, params: { q: "id:(#{id})" }.merge(params))["response"]["docs"]
        results.first or raise RecordNotFound
      end

      def find_by_id(id)
        all_by_ids(id).first or raise RecordNotFound
      end

      def all_by_ids(*ids)
        ids_clause = ids.flatten.join(" OR ")
        get(:select, params: { q: "id:(#{ids_clause})" })["response"]["docs"]
      end

      def add!(data)
        delete_by_id(data["id"])
        solr_write.add(data)
        commit
      end

      # Sometimes the connection timesout on commits against the development server and returns an empty response
      def commit
        solr_write.commit if development?
      end

      private

      def development?
        ["development", "test"].include?(ENV["RAILS_ENV"])
      end

      def faraday_options
        {
          request: {
            params_encoder: Faraday::FlatParamsEncoder,
          },
        }
      end

      def faraday_connection
        @faraday_connection ||= Faraday.new(faraday_options) do |faraday|
          faraday.response :logger if ENV["DEBUG_SOLR_RESPONSE"].present?
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
