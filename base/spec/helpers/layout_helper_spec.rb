# -*- coding: utf-8 -*-
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

  describe "submit_button" do

    it "should create html for a nice button" do
      html_code = <<-EOF.gsub(/^( ){6}/, '')
      <fieldset class='buttons'>
        <ol>
          <li>
            <input class="button" name="commit" type="submit" value="Reset Password" />
          </li>
        </ol>
      </fieldset>
      EOF

      helper.submit_button('Reset Password').should eql(html_code)
    end

  end

  describe "text_field_i18n" do

    it "should create html for a nice text field (i18n aware)" do
      html_code = <<-EOF.gsub(/^( ){6}/, '')
      <label for="email">Email</label>
      <input class="text_field" id="email" name="email" type="text" />
      EOF

      helper.text_field_i18n(User, :email).should eql(html_code)
    end

    it "should create html for a nice text field (:es)" do
      html_code = <<-EOF.gsub(/^( ){6}/, '')
      <label for="email">Correo electrónico</label>
      <input class="text_field" id="email" name="email" type="text" />
      EOF

      with_locale(:es) do
        helper.text_field_i18n(User, :email).should eql(html_code)
      end
    end

  end

end
