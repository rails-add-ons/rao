module Rao
  module Shoulda
    module Matchers
      # Example:
      #
      #    RSpec.describe '/posts', type: :feature do
      #      it {
      #        expect(subject).to implement_create_action(self)
      #          .for(Post)
      #          .within_form('#new_post') {
      #            fill_in 'post[title]', with: 'My first post'
      #          }
      #          .increasing{ |resource_class| resource_class.count }.by(1)
      #      }
      #    end
      #
      # The newly created resource is found by calling @resource_class.last.
      # If you need to change this you can call #finding_created_resource_with.
      #
      # Example:
      #
      #     RSpec.describe '/posts', type: :feature do
      #       it {
      #         expect(subject).to implement_create_action(self)
      #           .for(resource_class)
      #           .within_form('#new_user') {
      #             # fill the needed form inputs via capybara here
      #             #
      #             # Example:
      #             #
      #             #     select 'de', from: 'slider[locale]'
      #             #     fill_in 'slider[name]', with: 'My first slider'
      #             #     check 'slider[auto_start]'
      #             #     fill_in 'slider[interval]', with: '3'
      #             fill_in 'user[email]', with: 'jane.doe@local.domain'
      #             fill_in 'user[password]', with: 'password'
      #             fill_in 'user[password_confirmation]', with: 'password'
      #           }
      #           .finding_created_resource_with{ Ecm::UserArea::User.order(created_at: :desc).first }
      #           .increasing{ Ecm::UserArea::User.count }.by(1)
      #       }
      #     end
      #
      def implement_create_action(spec)
        ImplementCreateActionMatcher.new(spec)
      end

      class ImplementCreateActionMatcher
        include RSpec::Matchers

        def initialize(spec)
          @spec = spec
        end

        def id(id)
          @id = id
          self
        end

        def increasing(&block)
          @block = block
          self
        end

        def by(expected_increase)
          @expected_increase = expected_increase
          self
        end
        
        # Resource class that will be created
        def for(resource_class)
          @resource_class = resource_class
          self
        end

        # Specifies the form css id to fill to create the resource.
        def within_form(id, &block)
          @form_id = id
          @form_block = block
          self
        end

        def finding_created_resource_with(&block)
          @created_resource_finder_block = block
          self
        end

        def matches?(base_path)
          @base_path = @spec.respond_to?(:base_path) ? @spec.base_path : @spec.class.name.split('::')[0..2].join('::').constantize.description
          @new_path = "#{@base_path}/new"

          @spec.visit(@new_path)

          @before_count = @block.call(@resource_class)
          @spec.within(@form_id) do
            @form_block.call
            submit_button.click
          end
          @after_count = @block.call(@resource_class)

          has_correct_status_code && has_increased_resource_count && has_correct_current_path
        end

        def created_resource
          @created_resource ||= @created_resource_finder_block.present? ? @created_resource_finder_block.call : @resource_class.last
        end

        def expected_path
          @expected_path ||= "#{@base_path}/#{created_resource.to_param}"
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

        def has_increased_resource_count
          if (@after_count - @before_count) == @expected_increase
            true
          else
            @error = "Did not increase by expected [#{@expected_increase}] but by [#{@after_count - @before_count}]"
            false
          end
        end

        def has_correct_current_path
          if @spec.current_path == expected_path
            true
          else
            @error = "Wrong current path [#{@spec.current_path}] instead of [#{expected_path}]"
            false
          end
        end

        def failure_message
          "Should expose create action on #{@new_path}. Error: #{@error}"
        end

        def failure_message_when_negated
          "Should not expose create action on #{@new_path}. Error: #{@error}"
        end

        alias negative_failure_message failure_message_when_negated

        def description
          "expose create action on #{@new_path}"
        end

        def submit_button
          @spec.find('input[name="commit"]')
        end
      end
    end
  end
end