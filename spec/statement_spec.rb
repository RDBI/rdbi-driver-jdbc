require File.expand_path("../spec_helper", __FILE__)
require 'rdbi-driver-jdbc'
require 'time'

describe "RDBI::Driver::JDBC::Statement" do
  let(:dbh) { init_database }
  let(:sth) { dbh.new_statement "SELECT * FROM TB1 WHERE COL1 = ?" }
  subject   { sth }

  after :each do
    sth.finish if sth and not sth.finished?
    dbh.disconnect if dbh and dbh.connected?
  end

  it { should_not be_nil }
  it { should be_a RDBI::Driver::JDBC::Statement }
  it { should be_a RDBI::Statement }

  describe "#new_execution" do
    let(:rs) { sth.new_execution "A" }
    subject  { rs }

    it { should_not be_nil }
    it { should be_an Array }

    specify "it should return the correct types" do
      rs[0].should be_an RDBI::Driver::JDBC::Cursor
      rs[1].should be_an RDBI::Schema
      rs[2].should be_an Hash

      rs[1][:tables].should == ["tb1"]
    end

    context "rs[1][:columns][0]" do
      subject { rs[1][:columns][0] }

      its(:name)        { should == :COL1    }
      its(:type)        { should == "CHAR"   }
      its(:ruby_type)   { should == :default }
      its(:precision)   { should == 1        }
      its(:scale)       { should == 0        }
      its(:nullable)    { should == true     }
      its(:table)       { should == "tb1"    }
      its(:primary_key) { should == false    }
    end

    context "rs[1][:columns[1]" do
      subject { rs[1][:columns][1] }

      its(:name)        { should == :COL2     }
      its(:type)        { should == "INTEGER" }
      its(:ruby_type)   { should == :integer  }
      its(:precision)   { should == 11        }
      its(:scale)       { should == 0         }
      its(:nullable)    { should == true      }
      its(:table)       { should == "tb1"     }
      its(:primary_key) { should == false     }
    end

    context "aggregate columns" do
      let(:sth) { dbh.new_statement "SELECT COUNT(*) FROM TB1" }

      it "shouldn't raise an exception" do
        expect{ sth.new_execution }.to_not raise_error
      end
    end
  end

  describe "#execute" do
    let(:rs) { sth.execute("A") }
    subject  { rs }

    it { should_not be_nil }
    it { should be_an RDBI::Result }

    it "should return correct results" do
      r = rs.fetch(:first)
      r[0].should == "A"
      r[1].should == 1

      r = rs.as(:Struct).fetch(:first)
      r[:COL1].should == "A"
      r[:COL2].should == 1
    end
  end

  specify "#finish" do
    sth.finished?.should be_false

    sth.finish
    sth.finished?.should be_true
  end
end
