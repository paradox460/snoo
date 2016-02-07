module Snoo
  module Components
    # Captcha consumer methods
    module Captcha
      def self.included(base)
        base.class_eval do
          consume '/api/needs_captcha',
                  as: :needs_captcha?
          consume '/api/new_captcha',
                  as: :new_captcha,
               using: :post # TODO: Implement post body params
          consume '/captcha/:iden',
                  as: :captcha
        end
      end
    end
  end
end
