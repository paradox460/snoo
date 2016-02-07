module Snoo
  module Components
    # Wiki consumer methods
    module Wiki
      def self.included(base)
        base.class_eval do
          consume '/r/:subreddit/api/wiki/alloweditor/add',
                  as: :add_wiki_editor_to_page,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/wiki/alloweditor/del',
                  as: :remove_wiki_editor_from_page,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/wiki/edit',
                  as: :edit_wiki_page,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/wiki/hide',
                  as: :hide_wiki_page,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/wiki/revert',
                  as: :revert_wiki_page,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/wiki/discussions/:page',
                  as: :wiki_page_discussions,
              params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/wiki/pages',
                  as: :wiki_pages
          consume '/r/:subreddit/wiki/revisions',
                  as: :recent_wiki_revisions,
              params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/wiki/revisions/:page',
                  as: :recent_wiki_page_revisions,
              params: { optional: %i(after before count limit page show sr_detail) } # TODO: Genericize into listing type
          consume '/r/:subreddit/wiki/settings/:page',
                  as: :wiki_page_settings
          consume '/r/:subreddit/wiki/settings/:page',
                  as: :update_wiki_page_settings,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/wiki/:page',
                  as: :wiki_page,
              params: { optional: %i(v v2) }
        end
      end
    end
  end
end
