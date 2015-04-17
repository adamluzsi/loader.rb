require_relative '../spec_helper'
describe Loader::Helpers do

  let(:project_folder) { 'Path/To/Project/Folder' }
  subject { Loader::Helpers }

  describe '#pwd' do

    before do
      allow(ENV).to receive(:[]).with('BUNDLE_GEMFILE').and_return(nil)
    end

    context 'bundler envernioment variable set' do

      before do
        allow(ENV).to receive(:[]).with('BUNDLE_GEMFILE').and_return(File.join(project_folder,'Gemfile'))
      end

      it 'should return the project root folder by bundler gemfile env' do
        expect(subject.pwd).to eq project_folder
      end

    end

    context 'Rails is present and the root methot return not nil object' do

      let(:rails) { double('rails', root: project_folder) }
      before { stub_const('Rails', rails) }

      it 'should fetch rails root path' do
        expect(subject.pwd).to eq project_folder
      end

    end

    context 'when everything fails, fall back use build in Dir module' do

      it 'should use dir pwd on fallback' do

        expect(Dir).to receive(:pwd).and_return(project_folder)
        expect(subject.pwd).to eq project_folder

      end

    end

  end



end