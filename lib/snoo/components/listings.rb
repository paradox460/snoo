module Snoo
  module Components
    # Listings consumer methods
    module Listings
      def self.included(base)
        base.class_eval do
          consume '/by_id/:names', as: :by_id
          consume '/r/:subreddit/comments/:article',
                  as: :comments,
              params: { optional: %i(comment context depth limit showedits showmore sort sr_detail) }
          consume '/duplicates/:article',
                  as: :duplicates,
              params: { optional: %i(after before count limit name show sr_detail) } # TODO: Genericize into listing type
          consume 'related/:article',
                  as: :related
          consume '/r/:subreddit/hot',
                  as: :hot,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/new',
                  as: :new_posts,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/random',
                  as: :random,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/top',
                  as: :top,
              params: { optional: %i(t after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/controversial',
                  as: :controversial,
              params: { optional: %i(t after before count limit show sr_detail) } # TODO: Genericize into listing type
        end
      end
    end
  end
end
