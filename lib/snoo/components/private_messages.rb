module Snoo
  module Components
    # Private Message consumer methods
    module PrivateMessages
      def self.included(base)
        base.class_eval do
          consume '/api/block',
                  as: :block,
               using: :post # TODO: Implement post body params
          consume '/api/collapse_message',
                  as: :collapse_message,
               using: :post # TODO: Implement post body params
          consume '/api/compose',
                  as: :compose,
               using: :post # TODO: Implement post body params
          consume '/api/read_all_messages',
                  as: :read_all_messages,
               using: :post # TODO: Implement post body params
          consume '/api/read_message',
                  as: :read_message,
               using: :post # TODO: Implement post body params
          consume '/api/unblock_subreddit',
                  as: :unblock_subreddit,
               using: :post # TODO: Implement post body params
          consume '/api/uncollapse_message',
                  as: :uncollapse_message,
               using: :post # TODO: Implement post body params
          consume '/api/unread_message',
                  as: :unread_message,
               using: :post # TODO: Implement post body params
          consume '/message/inbox',
                  as: :inbox,
              params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/message/sent',
                  as: :sent,
              params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/message/unread',
                  as: :unread,
              params: { optional: %i(mark mid after before count limit show sr_detail) } # TODO: Genericize into listing type
        end
      end
    end
  end
end
