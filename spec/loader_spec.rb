require 'spec_helper'
describe Loader do

  describe '.autoload!' do
    let(:root_folder) { File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'autoload')) }
    before { Loader.autoload!(root_folder) }

    it 'should lazy load all the constants upon being used' do
      expect { Sample }.to_not raise_error
      expect { Sample::Dog }.to_not raise_error
      expect { Sample::Dog::Tail }.to_not raise_error
      expect { Sample::Cat::Paw }.to_not raise_error
    end

    it 'should be able to fetch constant even during in an another namespace' do
      expect { SomeClass.class_eval { TopConstant } }.to_not raise_error
    end

    it "should able to fetch the constant even if it's referenced through not the main namespace" do
      expect { TopLevel::TopLevelToo }.to_not raise_error
    end

    it 'should require unrequired gems' do
      expect { YAML }.to_not raise_error
    end

  end

  describe '.require_relative_directory' do

    it 'should require the given relative folder content' do
      require_relative_directory 'fixtures/require_relative_directory/relative_folder'

      expect { TestConstant::Stuff }.to raise_error(NameError, 'uninitialized constant TestConstant::Stuff')

      expect { TestConstant }.to_not raise_error
    end

    it 'should require the given relative folder content recursively like this' do
      require_relative_directory 'fixtures/require_relative_directory/relative_folder_recursive/**'

      expect { TestConstant2::Stuff2 }.to_not raise_error
    end

  end

end