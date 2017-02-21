# encoding: UTF-8

require "thor"

require_relative 'doi_utils'
require_relative 'utils'

module Bolognese
  class CLI < Thor
    include Bolognese::DoiUtils
    include Bolognese::Utils

    def self.exit_on_failure?
      true
    end

    # from http://stackoverflow.com/questions/22809972/adding-a-version-option-to-a-ruby-thor-cli
    map %w[--version -v] => :__print_version

    desc "--version, -v", "print the version"
    def __print_version
      puts Bolognese::VERSION
    end

    desc "read id", "read metadata for ID"
    method_option :as, default: "schema_org"
    method_option :schema_version
    def read(id)
      id = normalize_id(id)
      provider = find_provider(id)
      output = options[:as] || "schema_org"

      if provider.present?
        p = case provider
            when "crossref" then Crossref.new(id: id)
            when "datacite" then Datacite.new(id: id, schema_version: options[:schema_version])
            else SchemaOrg.new(id: id)
            end

        puts p.send(output)
      else
        puts "not implemented"
      end
    end
  end
end
