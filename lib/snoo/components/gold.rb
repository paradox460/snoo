module Snoo
  module Components
    # Gold consumer methods
    module Gold
      def self.included(base)
        base.class_eval do
          consume '/api/v1/gold/gild/:fullname',
                  as: :guild,
               using: :post # TODO: Implement post body params
          consume '/api/v1/gold/give/:username',
                  as: :give_gold,
               using: :post # TODO: Implement post body params
          # Links & Comments
          consume '/api/comment',
                  as: :comment,
               using: :post # TODO: Implement post body params
          
          consume '/api/del',
                  as: :delete,
               using: :post # TODO: Implement post body params
          consume '/api/editusertext',
                  as: :edit_user_text,
               using: :post # TODO: Implement post body params
          consume '/api/hide',
                  as: :hide,
               using: :post # TODO: Implement post body params
          consume '/r/:subreddit/api/info',
                  as: :info,
              params: { required: %i(id url) }
          consume '/api/lock',
                  as: :lock,
               using: :post # TODO: Implement post body params
          consume '/api/marknsfw',
                  as: :mark_nsfw,
               using: :post # TODO: Implement post body params
          consume '/api/morechildren',
                  as: :more_children,
              params: { required: %i(children link_id), optional: %i(id sort) }
          consume '/api/report',
                  as: :report,
               using: :post # TODO: Implement post body params
          consume '/api/save',
                  as: :save,
               using: :post # TODO: Implement post body params
          consume '/api/saved_categories',
                  as: :saved_categories
          consume '/api/sendreplies',
                  as: :send_replies,
               using: :post # TODO: Implement post body params
          consume '/api/set_contest_mode',
                  as: :set_contest_mode,
               using: :post # TODO: Implement post body params
          consume '/api/set_subreddit_sticky',
                  as: :set_subreddit_sticky,
               using: :post # TODO: Implement post body params
          consume '/api/set_suggested_sort',
                  as: :set_suggested_sort,
               using: :post # TODO: Implement post body params
          consume '/api/store_visits',
                  as: :store_visits,
               using: :post # TODO: Implement post body params
          consume '/api/submit',
                  as: :submit,
               using: :post # TODO: Implement post body params
          consume '/api/unhide',
                  as: :unhide,
               using: :post # TODO: Implement post body params
          consume '/api/unlock',
                  as: :unlock,
               using: :post # TODO: Implement post body params
          consume '/api/unmarknsfw',
                  as: :unmark_nsfw,
               using: :post # TODO: Implement post body params
          consume '/api/unsave',
                  as: :unsave,
               using: :post # TODO: Implement post body params
          consume '/api/vote',
                  as: :vote,
               using: :post # TODO: Implement post body params
        end
      end
    end
  end
end
