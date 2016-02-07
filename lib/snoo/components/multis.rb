module Snoo
  module Components
    # Multi consumer methods
    module Multis
      def self.included(base)
        base.class_eval do
          consume '/api/multi/mine',
                  as: :my_multis
          consume '/api/multi/user/:username',
                  as: :user_multis
          consume '/api/multi/:multipath/description',
                  as: :multi_description
          consume '/api/multi/:multipath/description',
                  as: :update_multi_description,
               using: :put
          consume '/api/multi/:multipath/r/:srname',
                  as: :multi_subreddit_info
          consume '/api/multi/:multipath/r/:srname',
                  as: :delete_subreddit_from_multi,
               using: :delete
          consume '/api/multi/:multipath/r/:srname',
                  as: :add_subreddit_to_multi,
               using: :put
          consume '/api/multi/:multipath',
                  as: :multi,
              params: { optional: :expand_srs }
          consume '/api/multi/:multipath',
                  as: :new_multi,
               using: :post # TODO: Implement post body params
          consume '/api/multi/:multipath',
                  as: :update_multi,
               using: :put
          consume '/api/multi/:multipath',
                  as: :delete_multi,
               using: :delete
          consume '/api/multi/copy',
                  as: :copy_multi,
               using: :post # TODO: Implement post body params
          consume '/api/multi/rename',
                  as: :rename_multi,
               using: :post # TODO: Implement post body params
        end
      end
    end
  end
end
