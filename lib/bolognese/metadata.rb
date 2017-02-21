require_relative 'doi_utils'
require_relative 'author_utils'
require_relative 'date_utils'
require_relative 'datacite_utils'
require_relative 'utils'

module Bolognese
  class Metadata
    include Bolognese::DoiUtils
    include Bolognese::AuthorUtils
    include Bolognese::DateUtils
    include Bolognese::DataciteUtils
    include Bolognese::Utils

    attr_reader :id, :raw, :provider, :schema_version

    alias_method :datacite, :as_datacite

    def url

    end

    def version

    end

    def keywords

    end

    def date_created

    end

    def page_start

    end

    def page_end

    end

    def has_part

    end

    def publisher

    end

    def contributor

    end

    def language

    end

    def spatial_coverage

    end

    def content_size

    end

    def schema_version

    end

    def as_schema_org
      { "@context" => "http://schema.org",
        "@type" => type,
        "@id" => id,
        "url" => url,
        "additionalType" => additional_type,
        "name" => name,
        "alternateName" => alternate_name,
        "author" => author,
        "editor" => editor,
        "description" => description,
        "license" => license,
        "version" => version,
        "keywords" => keywords,
        "language" => language,
        "contentSize" => content_size,
        "dateCreated" => date_created,
        "datePublished" => date_published,
        "dateModified" => date_modified,
        "pageStart" => page_start,
        "pageEnd" => page_end,
        "spatialCoverage" => spatial_coverage,
        "isPartOf" => is_part_of,
        "hasPart" => has_part,
        "citation" => citation,
        "schemaVersion" => schema_version,
        "publisher" => publisher,
        "provider" => provider
      }.compact.to_json
    end
  end
end
