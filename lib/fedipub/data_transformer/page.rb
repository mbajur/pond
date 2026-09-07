require "fedipub/utils/context"

module Fedipub
  module DataTransformer
    module Page
      def self.to_federation(entity, content:, name: nil, custom: {})
        # Merge default and custom contexts
        context = Utils::Context.generate(additional: custom.delete("@context"))
        # Merge in standard Page fields
        custom.merge "@context"     => context,
                     "id"           => entity.federated_url,
                     "url"          => Rails.application.routes.url_helpers.post_url(entity),
                     "type"         => "Page",
                     "name"         => name,
                     "content"      => content,
                     "attributedTo" => entity.fedipub_actor.federated_url,
                     "published"    => entity.created_at,
                     "updated"      => entity.updated_at,
                     "attachment"   => {
                        "type"      => "Link",
                        "mediaType" => "text/html",
                        "href"      => entity.url
                      }
      end
    end
  end
end
