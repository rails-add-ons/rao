require 'rails_helper'
require 'rao-query'

RSpec.describe Rao::Query::ConditionParser do
  context 'contains condition' do
    describe 'condition_statement' do
      let(:scope) { Post }
      let(:field) { "title(cont)" }
      let(:condition) { "Post Title #1" }
      let(:subject) { described_class.new(scope, field, condition).condition_statement }

      it { expect(subject).to eq(["posts.title LIKE ?", "%Post Title #1%"]) }

      describe 'results' do
        let(:matching_post) { create(:post, title: 'Post Title #1') }
        let(:other_post) { create(:post, title: 'Post Title #2') }
        let(:subject) { Post.where(described_class.new(scope, field, condition).condition_statement) }

        before(:each) do
          matching_post
          other_post
        end
        
        it { expect(subject.all).to eq([matching_post]) }
      end
    end
  end
end