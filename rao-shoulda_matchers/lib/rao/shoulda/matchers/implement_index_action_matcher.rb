module Rao
  module Shoulda
    module Matchers
      # Example:
      #
      #    RSpec.describe '/posts', type: :feature do
      #      before(:each) { create_list(:post, 3) }
      #
      #      it { expect(subject).to implement_index_action(self) }
      #    end
      #
      def implement_index_action(spec)
        ImplementIndexActionMatcher.new(spec)
      end

      class ImplementIndexActionMatcher
        include RSpec::Matchers

        def initialize(spec)
          @spec = spec
        end

        def matches?(base_path)
          @base_path = @spec.respond_to?(:base_path) ? @spec.base_path : @spec.class.name.split('::')[0..2].join('::').constantize.description

          @spec.visit(@base_path)
          has_correct_status_code && has_correct_current_path
        end

        def has_correct_status_code
          begin
            if @spec.status_code == 200
              true
            else
              @error = "Wrong status code [#{@spec.status_code}] instead of [200]"
              false
            end
          rescue Capybara::NotSupportedByDriverError => e
            if @spec.respond_to?(:driver)
              puts "[Warning] Skipping status code check as it is not supported by your driver [#{@spec.driver.instance_variable_get(:@name)}]."
            else
              puts "[Warning] Skipping status code check as it is not supported by your driver [#{@spec.page.driver.class.name}]."
            end
            return true
          end
        end

        def has_correct_current_path
          if @spec.current_path == @base_path
            true
          else
            @error = "Wrong current path [#{@spec.current_path}] instead of [#{@base_path}]"
            false
          end
        end

        def failure_message
          "Should expose index action on #{@base_path}. Error: #{@error}"
        end

        def failure_message_when_negated
          "Should not expose index action on #{@base_path}. Error: #{@error}"
        end

        alias negative_failure_message failure_message_when_negated

        def description
          "expose index action on #{@base_path}"
        end
      end
    end
  end
end