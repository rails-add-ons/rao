module Rao
  module Shoulda
    module Matchers
      # Example checking for changed resource attributes:
      #
      #    RSpec.describe '/posts', type: :feature do
      #      let(:post) { create(:post) }
      #      it {
      #        expect(subject).to implement_update_action(self)
      #          .for(post)
      #          .within_form('.edit_post') {
      #            fill_in 'post[title]', with: 'New title'
      #            fill_in 'post[body]',  with: 'New body'
      #          }
      #          .updating
      #          .from(post.attributes)
      #          .to({ 'title' => 'New title', 'body' => 'New body' })
      #      }
      #    end
      #
      # Example checking for changed state:
      #
      #    RSpec.describe '/posts', type: :feature do
      #      let(:post) { create(:post) }
      #      it {
      #        expect(subject).to implement_update_action(self)
      #          .for(post)
      #          .within_form('.edit_post') {
      #            fill_in 'post[title]', with: 'New title'
      #            fill_in 'post[body]',  with: 'New body'
      #          }
      #          .updating{ |resource| resource.updated_by }
      #          .from(nil)
      #          .to(User.current)
      #      }
      #    end
      #
      def implement_update_action(spec)
        ImplementUpdateActionMatcher.new(spec)
      end

      class ImplementUpdateActionMatcher
        include RSpec::Matchers

        def initialize(spec)
          @spec = spec
        end

        # Resource that will be updated
        def for(resource)
          @resource = resource
          self
        end

        def from(value)
          @from = value
          self
        end

        def to(value)
          @to = value
          self
        end

        # Specifies the form css id to fill to create the resource.
        def within_form(id, &block)
          @form_id = id
          @form_block = block
          self
        end

        def updating(&block)
          @updating_block = block if block_given?
          self
        end

        def id
          @resource.to_param
        end

        def matches?(base_path)
          @base_path = @spec.class.name.split('::')[0..2].join('::').constantize.description
          # @base_path     = base_path
          @show_path = "#{@base_path}/#{id}"
          @edit_path = "#{@base_path}/#{id}/edit"

          @expected_path = @show_path

          @spec.visit(@edit_path)

          return unless has_correct_attributes_before if @expected_before_attributes.present?

          @spec.within(@form_id) do
            @form_block.call
            @spec.find('input[name="commit"]').click
          end
                      
          @resource.reload

          has_correct_status_code && has_correct_current_path && has_correct_attributes_after
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

        def has_correct_attributes_before
          expected = @from
          if @updating_block.present?
            given = @updating_block.call(@resource)

            if given == expected
              return true
            else
              @error = "Before update state [#{given.inspect}] did not match expected [#{expected.inspect}]"
              return false
            end
          else
            given = @resource.attributes.with_indifferent_access.slice(*@expected_before_attributes.keys)

            if given == expected
              true
            else
              @error = "Attributes before update [#{given}] did not match expected attributes [#{@expected_before_attributes}]"
              false
            end
          end
        end

        def has_correct_attributes_after
          expected = @to
          if @updating_block.present?
            given = @updating_block.call(@resource)

            if given == expected
              return true
            else
              @error = "After update state [#{given.inspect}] did not match expected [#{expected.inspect}]"
              return false
            end
          else
            given = @resource.attributes.with_indifferent_access.slice(*@to.keys)
            
            if given == expected
              true
            else
              @error = "Attributes after update [#{given}] did not match expected attributes [#{@expected_before_attributes}]"
              false
            end
          end
        end

        def failure_message
          "Should expose update action on #{@edit_path}. Error: #{@error}"
        end

        def failure_message_when_negated
          "Should not expose update action on #{@edit_path}. Error: #{@error}"
        end

        alias negative_failure_message failure_message_when_negated

        def description
          "expose update action on #{@edit_path}"
        end
      end
    end
  end
end