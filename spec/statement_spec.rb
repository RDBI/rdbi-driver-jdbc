require File.expand_path("../spec_helper", __FILE__)
require 'rdbi-driver-jdbc'

describe RDBI::Driver::JDBC::Statement do
  let(:dbh) { init_database }
  let(:sth) { dbh.new_statement "SELECT * FROM TB1 WHERE COL1 = ?"
  subject   { sth }

  after :each do
    sth.finish     if sth and not sth.finished?
    dbh.disconnect if dbh and dbh.connected?
  end

  it { should_not be_nil }
  it { should be_a RDBI::Driver::JDBC::Statement }
  it { should be_a RDBI::Statement }

  specify "#new_execution" do
    rs = sth.new_execution("A")
    rs.should_not be_nil
    rs.should be_an Array
    rs[0].should be_an RDBI::Driver::JDBC::Cursor
    rs[1].should be_an RDBI::Schema
    rs[2].should be_an Hash

    rs[1][:columns][0][:name].should        == :COL1
    rs[1][:columns][0][:type].should        == "CHAR"
    rs[1][:columns][0][:ruby_type].should   == :default
    rs[1][:columns][0][:precision].should   == 0
    rs[1][:columns][0][:scale].should       == 0
    rs[1][:columns][0][:nullable].should    == true
    rs[1][:columns][0][:table].should       == "TB1"
    rs[1][:columns][0][:primary_key].should == false

    rs[1][:columns][1][:name].should        == :COL2
    rs[1][:columns][1][:type].should        == "INTEGER"
    rs[1][:columns][1][:ruby_type].should   == :integer
    rs[1][:columns][1][:precision].should   == 10
    rs[1][:columns][1][:scale].should       == 0
    rs[1][:columns][1][:nullable].should    == true
    rs[1][:columns][1][:table].should       == "TB1"
    rs[1][:columns][1][:primary_key].should == false

    rs[1][:tables].should == ["TB1"]
  end

  specify "#execute" do
    rs = sth.execute("A")
    rs.should_not be_nil
    rs.should be_an RDBI::Result

    r = rs.fetch(:first)
    r[0].should == "A"
    r[1].should == 1

    r = rs.as(:Struct).fetch(:first)
    r[:COL1].should == "A"
    r[:COL2].should == 1
  end

  specify "#finish" do
    sth.finished?.should be_false
    sth.finish
    sth.finished?.should be_true
  end

  context "@output_type_map[:date]" do
    let(:rs) { dbh.execute "SELECT COL1 FROM TB2" }
    let(:r)  { rs.as(:Struct).fetch(:first) }

    specify "::JDBC::Date" do
      r[:COL1].should be_a Date
      r[:COL1].should == Date.parse("2010-01-01")
    end
  end

  context "@output_type_map[:datetime]" do
    let(:rs) { dbh.execute "SELECT COL2, COL3 FROM TB2" }
    let(:r)  { rs.as(:Struct).fetch(:first) }

    specify "::JDBC::TimeStamp" do
      r[:COL2].should be_a DateTime
      r[:COL3].should be_a DateTime
      r[:COL2].should == DateTime.parse("2010-01-01 12:00:00")
      r[:COL3].should == DateTime.parse("2010-01-01 12:00:00")
    end
  end

  describe "@output_type_map[:time]" do
    let(:rs) { dbh.execute "SELECT COL4 FROM TB2" }
    let(:r)  { rs.as(:Struct).fetch(:first)

    specify "::JDBC::Time" do
      r[:COL4].should be_a Time
      r[:COL4].should == Time.parse("12:00:00")
    end
  end
end
