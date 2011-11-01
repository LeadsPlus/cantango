require 'rspec'
require 'cantango'
require 'fixtures/models'
require 'cantango/rspec'

def config_folder
  File.dirname(__FILE__)+ "/../fixtures/config/"
end

CanTango.configure do |config|
  config.clear!
  config.ability.mode = :no_cache
end

class UserPermit < CanTango::UserPermit
  def initialize ability
    super
  end

  protected

  def static_rules
    can :read, Article
  end
end

describe CanTango::PermitEngine do
  context 'no-cache' do
    before do
      @user = User.new 'kris'
    end

    describe 'UserAc engine' do
      let (:ability) do
        CanTango::Ability.new @user
      end
      subject { CanTango::PermitEngine.new ability }

      describe '#execute!' do
        before do
          subject.execute!
        end

        specify { subject.ability.send(:rules).should_not be_empty }
      end
    end
  end
end

