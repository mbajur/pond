require "fedipub/utils/context"

module Fedipub
  module DataTransformer
    module Image
      def self.to_federation(entity, content:, name: nil, custom: {})
        # Merge default and custom contexts
        context = Utils::Context.generate(additional: custom.delete("@context"))
        # Merge in standard Page fields
        custom.merge "@context"     => context,
                     "id"           => entity.federated_url,
                     "url"          => Rails.application.routes.url_helpers.post_url(entity),
                     "type"         => "Image",
                     "name"         => name,
                     "content"      => content,
                     "attributedTo" => entity.fedipub_actor.federated_url,
                     "published"    => entity.created_at,
                     "updated"      => entity.updated_at,
                     "attachment"   => (entity.files.map do |file|
                       {
                        "type"      => "Image",
                        "mediaType" => file.content_type,
                        "href"      => RailsBlobUrlGenerator.new(file.variant(:large)).call
                       }
                     end)
      end
    end
  end
end
