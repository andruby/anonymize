require 'google-search'
require 'faker'

module Anonymize::Profile
  class << self
    def introduction
      "#{time_ago} I #{join_action} the department of \"#{catch_phrase}\" as #{title} where we #{bs_action} and #{bs_action}. I specialize in #{catch_phrase.downcase}."
    end

    def time_ago
      (rand(20)+2).to_s + " " + %w{months years weeks}.sample + " ago"
    end

    def join_action
      %w{joined founded started joined created}.sample
    end

    def catch_phrase
      Faker::Company.catch_phrase
    end

    def bs_action
      Faker::Company.bs
    end

    # Thanks to http://www.bullshitjob.com/title/
    def title
      one = %w{Lead Senior Direct VP National Regional District Central Global Customer International Internal Chief Principal}.sample
      two = %w{Solutions Program Brand Security Research Marketing Directives Implementation Integration Functionality Response Paradigm Engineering Identity Markets Group Division Applications Optimization Operations Infrastructure Intranet Communications Web Branding Quality Assurance Mobility Accounts Data Creative Configuration Accountability Interactions Factors Usability Metrics}.sample
      three = %w{Supervisor Associate Executive Liason Officer Manager Engineer Specialist Director Coordinator Administrator Architect Analyst Designer Planner Orchestrator Technician Developer Producer Consultant Assistant Facilitator Agent Representative Strategist}.sample
      [one, two, three].join(' ')
    end
  end
end