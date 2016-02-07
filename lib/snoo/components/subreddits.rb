module Snoo
  module Components
    # Subreddit consumer methods
    module Subreddits
      def self.included(base)
        base.class_eval do
          consume '/r/:subreddit/about/banned',
                  as: :banned,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/about/contributors',
                  as: :contributors,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/about/moderators',
                  as: :moderators,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/about/muted',
                  as: :muted,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/about/wikibanned',
                  as: :wikibanned,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/about/wikicontributors',
                  as: :wikicontributors,
              params: { optional: %i(after before count limit show sr_detail user) } # TODO: Genericize into listing type
          consume '/r/:subreddit/api/delete_sr_banner',
                  as: :delete_banner,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/delete_sr_header',
                  as: :delete_header,
               using: :post # TODO: Implement post body params
          alias_method :delete_logo, :delete_header
          consume '/r/:subreddit/api/delete_sr_icon',
                  as: :delete_icon,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/delete_sr_img',
                  as: :delete_image,
               using: :post # TODO: Implement post body params
          consume '/api/recommend/sr/:srnames',
                  as: :recommended_reddits,
              params: { optional: :omit }
          consume '/api/search_reddit_names',
                  as: :search_reddit_names,
               using: :post # TODO: Implement post body params
          consume '/api/site_admin',
                  as: :new_subreddit,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/submit_text',
                  as: :submission_text
          consume '/r/:subreddit/api/subreddit_stylesheet',
                  as: :update_stylesheet,
               using: :post # TODO: Implement post body params
          consume '/api/subreddits_by_topic',
                  as: :subreddits_by_topic,
              params: { required: :query }
          consume '/api/subscribe',
                  as: :subscribe,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/upload_sr_img',
                  as: :new_image,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/about',
                  as: :subreddit_info
          consume '/r/:subreddit/about/edit',
                  as: :subreddit_settings
          consume '/r/:subreddit/rules',
                  as: :subreddit_rules
          consume '/r/:subreddit/sidebar',
                  as: :subreddit_sidebar
          consume '/r/:subreddit/sticky',
                  as: :subreddit_sticky
          consume '/subreddits/mine/subscriber',
                  as: :my_subscribed,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/mine/contributor',
                  as: :my_approved,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/mine/moderator',
                  as: :my_moderated,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/search',
                  as: :subreddit_search,
              params: { required: :q, optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/default',
                  as: :default_subreddits,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/gold',
                  as: :gold_subreddits,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/new',
                  as: :new_subreddits,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/subreddits/popular',
                  as: :popular_subreddits,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
        end
      end
    end
  end
end
