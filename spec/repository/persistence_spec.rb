require_relative '../spec_helper'

describe Datamappify::Repository do
  let!(:user_repository) { UserRepository.instance }
  let(:user)             { User.new(:id => 1, :first_name => 'Fred', :gender => 'male', :passport => 'FREDWU42') }
  let(:user_valid)       { User.new(:first_name => 'Batman', :gender => 'male', :passport => 'ARKHAMCITY') }
  let(:user_invalid)     { User.new(:first_name => 'a') }

  let(:has_db_user) do
    Datamappify::Data::User.create!(:first_name => 'Fred', :sex => 'male')
    Datamappify::Data::UserPassport.create!(:number => 'FREDWU42', :user_id => 1)
  end

  describe "#find" do
    it "found" do
      has_db_user

      user_repository.find(1).should == user
      user_repository.find([1]).should == [user]
    end

    it "not found" do
      user_repository.find(1).should == nil
    end

    it "partial found collection" do
      has_db_user

      user_repository.find([1, 2]).should == [user]
    end
  end

  describe "#save" do
    it "success" do
      user_repository.save(user_valid)
      user_repository.count.should == 1

      new_user = user_repository.find(1)
      new_user.should be_kind_of(User)
      new_user.first_name.should == 'Batman'
      new_user.passport.should == 'ARKHAMCITY'
    end

    it "failure" do
      -> { user_repository.save!(user_invalid) }.should raise_error(Datamappify::Data::EntityNotSaved)
    end

    it "transaction" do
      user_valid.driver_license = 'DEVOPS'
      -> { user_repository.save(user_valid) }.should raise_error(ActiveRecord::StatementInvalid)

      user_repository.count.should == 0
      Datamappify::Data::UserPassport.count.should == 0
      Datamappify::Data::UserDriverLicense.count.should == 0
    end
  end

  it "updates an existing record" do
    has_db_user

    user.first_name = 'Vivian'
    user.gender = 'female'
    user.passport = 'LOCOMOTE'

    updated_user = user_repository.save(user)

    updated_user.first_name.should == 'Vivian'
    updated_user.gender.should == 'female'
    updated_user.passport.should == 'LOCOMOTE'

    persisted_user = user_repository.find(user.id)

    persisted_user.first_name.should == 'Vivian'
    persisted_user.gender.should == 'female'
    persisted_user.passport.should == 'LOCOMOTE'

    user_repository.count.should == 1
  end

  it "#destroy via id" do
    has_db_user

    user_repository.destroy!(1)
    user_repository.count.should == 0
  end

  it "#destroy via entity" do
    has_db_user

    user_repository.destroy!(user)
    user_repository.count.should == 0
  end
end
