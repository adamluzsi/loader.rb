require_relative 'helper'
describe Loader::AutoLoad do

  before do
    Loader::AutoLoad::Support.__send__(:define_singleton_method,:pwd){ __dir__ }
  end

  it 'should raise an constant missing error than' do

    -> {
      begin
        TEST
      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, true

    Loader.autoload

    -> {
      begin
        TEST
      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, false

    -> {
      begin
        Cat::Tail
      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, false

    -> {
      begin

        class Cat
          Dog
        end

      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, false

    -> {
      begin

        SamplesController

      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, false

    -> {
      begin
        BOOOM
      rescue Exception => e
        e
      end
    }.call.is_a?(Exception).must_be :==, true

  end

  # require_relative_directory_r 'lib'

end