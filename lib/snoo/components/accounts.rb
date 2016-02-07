module Snoo
  module Components
    # Account consumer methods
    module Accounts
      def self.included(base)
        base.class_eval do
          consume '/api/v1/me', as: :me
          consume '/api/v1/me/blocked',
                  as: :blocked,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/api/v1/me/friends',
                  as: :friends,
              params: { optional: %i(after before count limit show sr_detail) } # TODO: Genericize into listing type
          consume '/api/v1/me/karma', as: :karma
          consume '/api/v1/me/prefs', as: :prefs
          consume '/api/v1/me/prefs',
                  as: :update_prefs,
               using: :patch
          consume '/api/v1/me/trophies', as: :my_trophies
        end
      end
    end
  end
end
