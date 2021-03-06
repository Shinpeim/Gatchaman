# -*- coding: utf-8 -*-
require "spec_helper"
require "gatchaman"
require "base64"
describe Gatchaman do
  describe "#data_uri_schemize" do
    let(:document_root) {File.dirname(File.dirname(__FILE__))}
    let(:current_dir) {File.dirname(__FILE__)}
    let(:gatchaman){Gatchaman.new(document_root: document_root, current_dir: current_dir, expand_js: true, expand_css: true)}
    let(:base64_encoded_resource){
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
    let(:test_css_content) { open("#{current_dir}/resources/test.css").read.chomp }
    let(:test_js_content)  { open("#{current_dir}/resources/test.js").read.chomp }

    it "絶対urlのsrcをdata schemeで置き換えてくれること" do
      Gatchaman::DataScheme.any_instance.should_receive(:open).with("http://example.com/img/test.png", "r:ASCII-8BIT").
        and_return(Base64.decode64(base64_encoded_resource))
      gatchaman.data_uri_schemize("<img src='http://example.com/img/test.png'>").
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resource}\">"
    end

    it "相対urlの相対パスsrcをdata schemeで置き換えてくれること" do
      gatchaman.data_uri_schemize('<img src="resources/test.png">').
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resource}\">"
    end

    it "相対urlの絶対パスsrcをdata schemeで置き換えてくれること" do
      gatchaman.data_uri_schemize('<img src="/spec/resources/test.png">').
        should == "<img src=\"data:image/png;base64,#{base64_encoded_resource}\">"
    end

    it "ルートにhtmlタグを含む場合、htmlページとして出力すること" do
      gatchaman.data_uri_schemize('<html><body><h1>nyan!</h1></body></html>').
        should match /^<html>/
    end

    it "ルートにhtmlタグを含まない場合、htmlの断片として出力すること" do
      gatchaman.data_uri_schemize('<body><h1>nyan!</h1></body>').
        should_not match /^<html>/
    end

    it "cssを展開してくれること" do
      gatchaman.data_uri_schemize('<link rel="stylesheet" type="text/css" media="screen" href="resources/test.css">').
        should == %[<style type="text/css" media="screen">\n#{test_css_content}\n</style>]
    end

    it "css内部のurl参照を展開してくれること" do
      gatchaman.data_uri_schemize('<link rel="stylesheet" type="text/css" media="screen" href="resources/test_2.css">').
        include?(base64_encoded_resource).should be_true
    end

    it "styleタグ内部のURLを展開してくれること" do
      gatchaman.data_uri_schemize('<style> * { background: url(/spec/resources/test.png); } </style>').
        include?(base64_encoded_resource).should be_true
    end

    it "jsを展開してくれること" do
      gatchaman.data_uri_schemize('<script src="resources/test.js" type="text/javascript" charset="utf-8"></script>').
        should == %[<script type="text/javascript"><!--\n\n#{test_js_content}\n\n--></script>]
    end

    it "srcが設定されていないimgタグを無視すること" do
      gatchaman.data_uri_schemize('<img>').should == %[<img>]
    end
  end
end
