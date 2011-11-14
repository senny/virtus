require './spec/spec_helper'

class Page
  include Virtus

  attribute :title,        String
  attribute :slug,         String,  :default => lambda { |post, attribute| post.title.downcase.gsub(' ', '-') }
  attribute :view_count,   Integer, :default => 0
  attribute :secret,       Boolean

  attribute :published,    Boolean, :accessor => :private
  attribute :editor_title, String, :default => :default_editor_title

  def initialize(published = false)
    @published = published
  end

  def default_editor_title
    published? ? title : "UNPUBLISHED: #{title}"
  end
end

describe Page do
  describe '#slug' do
    before { subject.title = 'Virtus Is Awesome' }

    its(:slug) { should eql('virtus-is-awesome') }
  end

  describe '#views_count' do
    its(:view_count) { should eql(0) }
  end

  describe '#editor_title' do
    before { subject.title = 'Truly Awesome' }

    context 'published page' do
      subject { Page.new(true) }

      its(:editor_title) { should eql('Truly Awesome') }
    end

    context 'unpublished page' do
      subject { Page.new(false) }

      its(:editor_title) { should eql('UNPUBLISHED: Truly Awesome') }
    end
  end
end
