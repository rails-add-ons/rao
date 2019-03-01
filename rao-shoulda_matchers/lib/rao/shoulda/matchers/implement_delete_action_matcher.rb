module Rao
  module Shoulda
    module Matchers
      # Example:
      #
      #     RSpec.describe '/posts', type: :feature do
      #       let(:resource_class) { Post }
      #       let(:resource)       { create(:post) }
      #     
      #       it { 
      #        expect(subject).to implement_delete_action(self)
      #          .for(resource)
      #          .reducing{ resource_class.count }.by(1)
      #       }
      #     end
      #
      def implement_delete_action(spec)
        ImplementDeleteActionMatcher.new(spec)
      end

      class ImplementDeleteActionMatcher
        include RSpec::Matchers

        def initialize(spec)
          @spec = spec
        end

        # Resource that will be deleted
        def for(resource)
          @resource = resource
          self
        end

        def id
          @resource.to_param
        end

        def reducing(&block)
          @block = block
          self
        end

        def by(expected_reduction)
          @expected_reduction = expected_reduction
          self
        end

        def matches?(base_path)
          @base_path = @spec.class.name.split('::')[0..2].join('::').constantize.description
          # @base_path     = base_path
          @expected_path = @base_path
          @show_path = "#{@base_path}/#{id}"

          @spec.visit(@show_path)

          @before_delete_count = @block.call
          @spec.click_link(delete_link_text)
          @after_delete_count = @block.call

          has_correct_status_code && has_correct_current_path && has_reduced_resource_count
        end

        def delete_link_text
          @delete_link_text ||= I18n.t('rao.component.collection_table.destroy')
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

        def has_reduced_resource_count
          if (@before_delete_count - @after_delete_count) == @expected_reduction
            true
          else
            @error = "Did not reduce by expected [#{@expected_reduction}] but by [#{@before_delete_count - @after_delete_count}]"
            false
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
          "Should expose delete action on #{@base_path} [#{delete_link_text}], clicking on #{delete_link_text}. Error: #{@error}"
        end

        def failure_message_when_negated
          "Should not expose delete action on #{@base_path} [#{delete_link_text}], clicking on #{delete_link_text}. Error: #{@error}"
        end

        alias negative_failure_message failure_message_when_negated

        def description
          "expose delete action on #{@base_path} [#{delete_link_text}]"
        end
      end
    end
  end
end