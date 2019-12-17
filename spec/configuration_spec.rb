# Copyright 2015 ThoughtWorks, Inc.

# This file is part of Gauge-Ruby.

# Gauge-Ruby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Gauge-Ruby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Gauge-Ruby.  If not, see <http://www.gnu.org/licenses/>.

module Foo
  def hello_foo
    'hello_foo'
  end
end

module Bar
  def hello_bar
    'hello_bar'
  end
end

module Baz
end


describe Gauge::Configuration do
  before(:each) {
    Gauge.configure do |c|
      c.include Foo, Bar
    end
    Gauge::Configuration.include_configured_modules
  }

  context '.configure' do
    it 'should include all modules' do
      expect(Gauge::Configuration.instance.includes).to include Foo, Bar
      expect(hello_foo).to eq 'hello_foo'
      expect(hello_bar).to eq 'hello_bar'
    end


    context 'invoked multiple times' do
      it 'aggregates all includes' do
        Gauge.configure { |c| c.include Baz}
        expect(Gauge::Configuration.instance.includes).to include Foo, Bar, Baz
      end
    end

    describe 'config.screenshot' do
      before(:each) {
        Gauge.configure { |c|  c.screengrabber = -> { puts "foo" }}
      }
      it 'should set custom_screengrabber attribute as true' do
        expect(Gauge::Configuration.instance.custom_screengrabber?).to be true
      end
      it 'should set custom screengrabber' do
        expect(Gauge::Configuration.instance.screengrabber.source).to include 'puts "foo"'
      end
    end

    describe 'config.custom_screenshot_writer' do
      before(:each) {
        Gauge.configure { |c|  c.custom_screenshot_writer = -> { puts "foo" }}
      }
      it 'should set custom_screengrabber attribute as true' do
        expect(Gauge::Configuration.instance.custom_screengrabber?).to be true
      end
      it 'should set custom screengrabber' do
        expect(Gauge::Configuration.instance.screengrabber.source).to include 'puts "foo"'
      end
    end
  end

  context ".screenshot" do
    it "invokes gauge_screenshot by default" do
      expect(Gauge::Configuration.new.screengrabber.source).to include "`gauge_screenshot"
    end
  end
end
