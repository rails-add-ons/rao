require "rails_helper"

RSpec.describe Rao::ActiveCollection::Base do
  let(:post) do
    Class.new(described_class) do
      def self.collection
        [
          { id: 1, title: "Post 1" },
          { id: 2, title: "Post 2" },
          { id: 3, title: "Post 3" },
        ]
      end
    end
  end

  before { stub_const("Post", post)}
  
  describe "class methods" do
    describe "all" do
      subject { Post.all }

      it { expect(subject).to be_a(Rao::ActiveCollection::Relation) }
      it { expect(subject.to_a).to be_a(Array) }
    end

    describe "count" do
      subject { Post.count }

      it { expect(subject).to eq(3) }
    end
  end
end
