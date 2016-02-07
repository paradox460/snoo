module Snoo
  # rubocop:disable Metrics/ClassLength
  class Client < Support::BaseClient
    base_url 'https://www.reddit.com'

    include Snoo::Components::Accounts
    include Snoo::Components::Captcha
    include Snoo::Components::Flair
    include Snoo::Components::Gold
    include Snoo::Components::Listings
    include Snoo::Components::LiveThreads
    include Snoo::Components::Moderation
    include Snoo::Components::Multis
    include Snoo::Components::PrivateMessages
    include Snoo::Components::Subreddits
    include Snoo::Components::Users
    include Snoo::Components::Wiki

    # misc
    consume '/api/v1/scopes',
            as: :scopes,
        params: { optional: :scopes }
    # search
    consume '/r/:subreddit/search',
            as: :search,
        params: { required: :q, optional: %i(after before count include_facets limit restrict_sr show sort sr_detail syntax t type) } # TODO: Genericize into listing type
  end
end
