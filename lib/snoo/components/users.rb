module Snoo
  module Components
    # User consumer methods
    module Users
      def self.included(base)
        base.class_eval do
          consume '/api/setpermissions',
                  as: :update_permissions,
               using: :post # TODO: Implement post body params
          consume '/api/username_available',
                  as: :username_available?
          consume '/api/v1/me/friends/:username',
                  as: :friend_info
          consume '/api/v1/me/friends/:username',
                  as: :friend,
               using: :put
          alias_method :update_friend, :friend
          consume '/api/v1/me/friends/:username',
                  as: :delete_friend,
               using: :delete
          consume '/api/v1/user/:username/trophies',
                  as: :trophies
          consume '/user/:username/about',
                  as: :about_user
          consume '/user/:username/overview',
                  as: :user,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/comments',
                  as: :user_comments,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/gilded',
                  as: :user_guilded,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/hidden',
                  as: :user_hidden,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/saved',
                  as: :user_saved,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/submitted',
                  as: :user_submitted,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/upvoted',
                  as: :user_upvoted,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
          consume '/user/:username/downvoted',
                  as: :user_downvoted,
              params: { optional: %i(show sort t after before count limit sr_detail) } # TODO: Genericize into listing type
        end
      end
    end
  end
end
