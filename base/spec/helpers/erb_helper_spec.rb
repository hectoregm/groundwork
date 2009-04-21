# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ErbHelper do
  describe "locale_attrs" do

    it "should set the right XHTML header with default locale" do
      attr_str = "lang='en' xml:lang='en' xmlns='http://www.w3.org/1999/xhtml'"
      helper.locale_attrs.should eql(attr_str)
    end

    it "should set the right XHML header with :es locale" do
      attr_str = "lang='es' xml:lang='es' xmlns='http://www.w3.org/1999/xhtml'"

      with_locale(:es) do
        helper.locale_attrs.should eql(attr_str)
      end
    end

  end

  describe "submit_button" do

    it "should create html for a nice button" do
      html_code = "<fieldset class=\"buttons\"><ol><li><input class=\"button\" name=\"commit\" type=\"submit\" value=\"Reset Password\" /></li></ol></fieldset>"
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
