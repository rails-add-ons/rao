require "rails_helper"

RSpec.describe Rao::ActiveCollection::Base do
  around do |example|
    Post.delete_all
    example.run
    Post.delete_all
  end

  let(:posts) {
    create_list(:post, 3)
  }

  before(:each) { posts }

  describe "class methods" do
    describe "all" do
      subject { Post.all }

      it { expect(subject).to be_a(Rao::ActiveCollection::Relation) }
      it { expect(subject.to_a).to be_a(Array) }
      it { expect(subject.to_a.size).to eq(3) }
    end

    describe "attribute_names" do
      subject { Post.attribute_names }

      it { expect(subject).to be_a(Array) }
      it { expect(subject).to match_array([:id, :title]) }
    end

    describe "count" do
      subject { Post.count }

      it { expect(subject).to eq(3) }
    end

    describe "create" do
      subject { Post }

      it { expect(subject).to respond_to(:create) }
      it { expect { subject.create(title: "Some title") }.to change { Post.count }.by(1) }
    end

    describe "create!" do
      subject { Post }

      it { expect(subject).to respond_to(:create!) }

      describe "when valid" do
        describe "return value" do
          it { expect(subject.create!(title: "Some title")).to be_a(Post) }
        end

        describe "persistence changes" do
          it { expect { subject.create!(title: "Some title") }.to change { Post.count }.by(1) }
        end
      end

      describe "when invalid" do
        it { expect { subject.create!(title: nil) }.to raise_error(ActiveRecord::RecordInvalid) }
      end
    end

    describe "delete_all" do
      subject { Post.where(id: 3) }

      it { expect { subject.delete_all }.to change { Post.count }.from(3).to(2) }
    end

    describe "each" do
      subject { described_class }

      it { expect(subject).to respond_to(:each) }
      it { expect(subject).to respond_to(:map) }
    end

    describe "find" do
      subject { Post.find(1) }

      it { expect(subject).to be_a(Post) }
    end

    describe "first" do
      subject { Post.first }

      it { expect(subject).to be_a(Post) }
      it { expect(subject.id).to eq(1) }
    end

    describe "first!" do
      subject { Post.where(id: "some-non-existent-id") }

      it { expect { subject.first! }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    describe "order" do
      subject { Post.order(id: :desc) }

      it { expect(subject.all.map(&:id)).to eq([3, 2, 1]) }
    end

    describe "last" do
      subject { Post.last }

      it { expect(subject).to be_a(Post) }
      it { expect(subject.id).to eq(3) }
    end

    describe "last!" do
      subject { Post.where(id: "some-non-existent-id") }

      it { expect { subject.last! }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    describe "primary_key" do
      subject { Post.primary_key }

      it { expect(subject).to eq(:id) }
    end

    describe "reorder" do
      subject { Post.order(title: :asc).reorder(id: :desc) }

      it { expect(subject.all.map(&:id)).to eq([3, 2, 1]) }
    end

    describe "validates" do
      it { expect(described_class).to respond_to(:validates) }
    end

    describe "where" do
      subject { Post.where(id: 1) }

      it { expect(subject.all).to be_a(Rao::ActiveCollection::Relation) }
      it { expect(subject.count).to eq(1) }
      it { expect(subject.first).to be_a(Post) }
    end
  end

  describe "instance methods" do
    describe "new_record?" do
      describe "when new record" do
        subject { Post.new }

        it { expect(subject.new_record?).to be_truthy }
      end

      describe "when persisted record" do
        subject { create(:post) }

        it { expect(subject.new_record?).to be_falsey }
      end
    end

    describe "destroy" do
      subject { create(:post) }

      describe "persistence changes" do
        it { expect { subject.destroy }.to change { Post.count }.by(-1) }
      end

      describe "return value" do
        it { expect(subject.destroy).to eq(subject) }
      end
    end

    describe "destroyed?" do
      describe "when not destroyed" do
        subject { create(:post) }

        it { expect(subject.destroyed?).to be_falsey }
      end

      describe "when destroyed" do
        subject { create(:post).destroy }

        it { expect(subject.destroyed?).to be_truthy }
      end
    end
  end
end
