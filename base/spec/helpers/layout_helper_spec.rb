require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
include Haml::Helpers

describe LayoutHelper do

  describe "title" do

    it "should set the content for title" do
      helper.should_receive(:content_for).with(:title)
      helper.title('Welcome')
    end

    it "should show title by default" do
      helper.title('Welcome').should be_true
    end

    it "should not show title if not requested" do
      helper.title('Welcome', false).should_not be_true
    end

  end

  describe "locale_attrs" do

    def with_locale(locale)
      previous_locale = I18n.locale
      I18n.locale = locale.to_sym
      yield
      I18n.locale = previous_locale
    end

    it "should set the right XHTML header with default locale" do
      attr_hash = {:lang=>"en", :xmlns=>"http://www.w3.org/1999/xhtml", "xml:lang"=>"en"}
      helper.locale_attrs.should eql attr_hash
    end

    it "should set the right XHML header with :es locale" do
      attr_hash = {:lang=>"es", :xmlns=>"http://www.w3.org/1999/xhtml", "xml:lang"=>"es"}
      with_locale(:es) do
        helper.locale_attrs.should eql attr_hash
      end
    end

  end

end
