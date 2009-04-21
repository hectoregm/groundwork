# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

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

end
