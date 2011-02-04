#!/usr/bin/ruby1.8
# A Sinatra app for displaying one's resume in multiple formats

require 'rubygems'
require 'sinatra'
require 'less'
require 'rdiscount'
require 'maruku'

# Modified this so that only HTML, PDF and Text 
# are the 3 formats available.
# TODO: latex

# DC: Added this so that sinatra would run
# and not just exit the script
enable :run

get '/' do
    title = resume_data.split("\n").first
    #oops 1.8.7 only?
    #resume_data.lines.first.strip
    resume = RDiscount.new(resume_data, :smart).to_html
    # DC: Need to set the views for erubis otherwise
    # I would get a big old error message
    set :views, File.dirname(__FILE__) + '/views'
    erubis :index, :locals => { :title => title, :resume => resume, :formats => true }
end

get '/style.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :style
end

get '/latex' do
  #content_type 'application/x-latex'
  content_type "text/plain"
  doc = Maruku.new(resume_data)
  doc.to_latex_document
end

get '/text' do
  content_type 'text/plain'
  resume_data
end

get '/pdf' do
    # Just generate the pdf file manually as
    # pdflatex doesn't work on heroku
    content_type 'application/pdf'
    File.read("data/resume.pdf")
end

get '/word' do
    content_type 'application/msword'
    File.read("data/resume.doc")
end

def resume_data
    File.read("data/resume.md")
end

# vim: sts=4 sw=4 ts=4 et ft=ruby
