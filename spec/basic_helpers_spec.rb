require File.join(File.dirname(__FILE__), 'spec_helper')

class Person
  attr_accessor :name, :email, :country

  def initialize(*args)
    @name, @email, @country = *args
  end

  alias_method :to_s, :name
end

describe BasicHelpers do
  include ActionView::Helpers::TagHelper
  include BasicHelpers

  before(:each) do
    @template = ActionView::Base.new

    @people = [
      Person.new('Albert', 'albert@domain.com', 'Germany'),
      Person.new('Jorge Luis', 'jorge_luis@domain.com', 'Argentina'),
    ]

    @rows = @people.map {|p| [p.name, p.email, p.country] }
  end

  it "prints a simple table for a given Enumerable" do
    table(nil).should be_nil
    table([]).should be_nil

    table(@rows).should have_tag('table > tr > td', 'Albert')
    table(@rows).should have_tag('table > tr > td', 'albert@domain.com')
    table(@rows).should have_tag('table > tr > td', 'Germany')

    table(@rows).should have_tag('table > tr > td', 'Jorge Luis')
    table(@rows).should have_tag('table > tr > td', 'jorge_luis@domain.com')
    table(@rows).should have_tag('table > tr > td', 'Argentina')
  end

  it "prints table headers" do
    table([%w{Name E-mail}] + @rows, :headers => true).should have_tag('table > thead > tr > th', 'Name')
    table([%w{Name E-mail}] + @rows, :headers => true).should have_tag('table > thead > tr > th', 'E-mail')

    table(@rows, :headers => %w{Name E-mail}).should have_tag('table > thead > tr > th', 'Name')
    table(@rows, :headers => %w{Name E-mail}).should have_tag('table > thead > tr > th', 'E-mail')
  end

  it "allows options to be passed to the table" do
    table(@rows, :class => 'simple').should have_tag('table[@class="simple"]')
  end

  it "prints a table for a collection of objects" do
    table_for(@people).should == table_for(:people)

    should_receive(:table).with(@people.map {|p| [p.to_s] }, {})
    table_for(:people)
  end

  it "takes a list of attributes for table columns" do
    should_receive(:table).with(@people.map {|p| [p.name, p.email] }, {})
    table_for(:people, %w{name email})
  end

  it "takes a list of attributes for table columns including Procs" do
    should_receive(:table).with(@people.map {|p| [p.name.upcase, p.email] }, {})
    table_for(:people, [lambda {|p| p.name.upcase }, :email])
  end

  it "prints table headers" do
    should_receive(:table).with(@people.map {|p| [p.name, p.email] }, :headers => %w{Name Email})
    table_for(:people, [:name, :email], :headers => true)
  end
end
