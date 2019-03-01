module Rao
  module Shoulda
    module Matchers
      # Example:
      #
      #    RSpec.describe '/posts', type: :feature do
      #      let(:resource)       { create(:post) }
      #     
      #      it { expect(subject).to implement_show_action(self).for(resource) }
      #    end
      #
      def implement_show_action(spec)
        ImplementShowActionMatcher.new(spec)
      end

      class ImplementShowActionMatcher
        include RSpec::Matchers

        def initialize(spec)
          @spec = spec
        end

        # Resource that will be updated
        def for(resource)
          @resource = resource
          self
        end

        def id
          @resource.to_param
        end

        def matches?(base_path)
          @base_path = @spec.class.name.split('::')[0..2].join('::').constantize.description
          # @base_path     = base_path
          @expected_path = "#{@base_path}/#{id}"

          @spec.visit(@expected_path)
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
            puts "[Warning] Skipping status code check as it is not supported by your driver [#{@spec.driver.instance_variable_get(:@name)}]."
            return true
          end
        end

        def has_correct_current_path
          if @spec.current_path == @expected_path
            true
          else
            @error = "Wrong current path [#{@spec.current_path}] instead of [#{@expected_path}]"
            false
          end
        end

        def failure_message
          "Should expose show action on #{@expected_path}. Error: #{@error}"
        end

        def failure_message_when_negated
          "Should not expose show action on #{@expected_path}. Error: #{@error}"
        end

        alias negative_failure_message failure_message_when_negated

        def description
          "expose show action on #{@expected_path}"
        end
      end
    end
  end
end