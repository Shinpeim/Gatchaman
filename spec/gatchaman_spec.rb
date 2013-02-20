# -*- coding: utf-8 -*-
require "spec_helper"
require "gatchaman"
require "base64"
describe Gatchaman do
  describe "#data_uri_schemize" do
    let(:document_root) {File.dirname(File.dirname(__FILE__))}
    let(:current_dir) {File.dirname(__FILE__)}
    let(:gatchaman){Gatchaman.new(document_root: document_root, current_dir: current_dir, expand_js: true, expand_css: true)}
    let(:base64_encoded_resouce){
      "iVBORw0KGgoAAAANSUhEUgAAAAQAAAAGCAIAAABrW6giAAAACXBIWXMAA
       BYlAAAWJQFJUiTwAAABy2lUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPH
       g6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0
       iWE1QIENvcmUgNS4xLjIiPgogICA8cmRmOlJERiB4bWxuczpyZGY9Imh0
       dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiP
       gogICAgICA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIgogICAgIC
       AgICAgICB4bWxuczpleGlmPSJodHRwOi8vbnMuYWRvYmUuY29tL2V4aWY
       vMS4wLyI+CiAgICAgICAgIDxleGlmOkNvbG9yU3BhY2U+NjU1MzU8L2V4
       aWY6Q29sb3JTcGFjZT4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5za
       W9uPjQ8L2V4aWY6UGl4ZWxYRGltZW5zaW9uPgogICAgICAgICA8ZXhpZj
       pQaXhlbFlEaW1lbnNpb24+NjwvZXhpZjpQaXhlbFlEaW1lbnNpb24+CiA
       gICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4
       bXBtZXRhPgrjpclbAAAAFUlEQVQIHWOUlJRkgAEmGANEk8MBABhmAFcTc
       YlpAAAAAElFTkSuQmCC".gsub(/[\s\n]/,'')
    }
    let(:test_css_content) { open("#{current_dir}/resouces/test.css").read.chomp }
    let(:test_js_content)  { open("#{current_dir}/resouces/test.js").read.chomp }

    it "絶対urlのsrcをdata schemeで置き換えてくれること" do
      gatchaman.should_receive(:open).with("http://example.com/img/test.png", "r:ASCII-8BIT").
        and_return(Base64.decode64(base64_encoded_resouce))
      gatchaman.data_uri_schemize("<img src='http://example.com/img/test.png'>").
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resouce}\">"
    end

    it "相対urlの相対パスsrcをdata schemeで置き換えてくれること" do
      gatchaman.data_uri_schemize('<img src="resouces/test.png">').
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resouce}\">"
    end

    it "相対urlの絶対パスsrcをdata schemeで置き換えてくれること" do
      gatchaman.data_uri_schemize('<img src="/spec/resouces/test.png">').
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resouce}\">"
    end

    it "cssを展開してくれること" do
      gatchaman.data_uri_schemize('<link rel="stylesheet" type="text/css" media="screen" href="resouces/test.css">').
        should == %[<style type="text/css" media="screen">\n#{test_css_content}\n</style>]
    end

    it "css内部のurl参照を展開してくれること" do
      gatchaman.data_uri_schemize('<link rel="stylesheet" type="text/css" media="screen" href="resouces/test_2.css">').
        include?(base64_encoded_resouce).should be_true
    end

    it "jsを展開してくれること" do
      gatchaman.data_uri_schemize('<script src="resouces/test.js" type="text/javascript" charset="utf-8"></script>').
        should == %[<script type="text/javascript">\n#{test_js_content}\n</script>]
    end
  end
end
