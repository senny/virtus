require 'spec_helper'
require 'dm-validations'

describe 'Integration with dm-validations' do
  let(:model) do
    Class.new do
      include Virtus
      include DataMapper::Validations

      attribute :name,       String
      attribute :age,        Integer

      validates_presence_of     :name, :age
      validates_numericality_of :age
    end
  end

  let(:object) do
    model.new(attributes)
  end

  context 'with invalid attributes' do
    let(:attributes) do
      { :name => nil, :age => 'not-a-number' }
    end

    before { object.valid? }

    it 'has errors on :name' do
      object.errors[:name].should_not be_empty
    end

    it 'has errors on :age' do
      object.errors[:age].should_not be_empty
    end
  end

  context 'with valid attributes' do
    let(:attributes) do
      { :name => 'solnic', :age => 28 }
    end

    before { object.valid? }

    it 'has no errors' do
      object.errors.should be_empty
    end
  end
end
