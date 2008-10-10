#!/usr/bin/env ruby
require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform         = Gem::Platform::RUBY
  s.name             = "rzen"
  s.version          = "1.1.0"
  s.author           = "MadX"
  s.email            = "root+rzen@yapok.org"
  s.summary          = "A package to build Zenity dialogs in a ruby-ish way."
  s.files            = FileList['lib/*.rb'].to_a
  s.require_path     = "lib"
  s.autorequire      = "rzen"
  s.has_rdoc         = true
  s.extra_rdoc_files = ["README"]
end
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end
task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end
