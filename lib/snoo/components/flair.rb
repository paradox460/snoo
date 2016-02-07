module Snoo
  module Components
    # Flair consumer methods
    module Flair
      def self.included(base)
        base.class_eval do
          consume '/r/:subreddit/api/clearflairtemplates',
                  as: :clear_flair_templates,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/deleteflair',
                  as: :delete_flair,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/deleteflairtemplate',
                  as: :delete_flair_template,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/flair',
                  as: :flair,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/flairconfig',
                  as: :flair_config,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/flaircsv',
                  as: :flair_csv,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/flairlist',
                  as: :flairs,
              params: { optional: %i(after before count limit name show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/api/flairselector',
                  as: :flair_selector,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/flairtemplate',
                  as: :flair_template,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/selectflair',
                  as: :select_flair,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/setflairenabled',
                  as: :toggle_flair,
               using: :post # TODO: Implement post body params
        end
      end
    end
  end
end
