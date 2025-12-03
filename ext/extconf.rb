# frozen_string_literal: true

# ext/extconf.rb
require 'fileutils'

# Check for Python
abort 'Python 3 is required but not found in PATH' unless system('python3 --version > /dev/null 2>&1')

python_version = `python3 -c "import sys; print('.'.join(map(str, sys.version_info[:3])))"`.strip

abort "Python 3.10 is required (found Python #{python_version})" unless python_version.start_with?("3.10")

# Check for pip
abort 'pip3 is required but not found in PATH' unless system('pip3 --version > /dev/null 2>&1')

# Install Python dependencies
requirements_file = File.join(__dir__, '..', 'python', 'requirements.txt')
if File.exist?(requirements_file)
  puts 'Installing Python dependencies...'
  abort 'Failed to install Python dependencies' unless system("pip3 install -r #{requirements_file}")
end

# Download spaCy language model
german_model = "de_core_news_sm"
puts "Downloading German spaCy model (this may take a moment)..."
unless system("python3 -m spacy download #{german_model}")
  abort "Failed to download spaCy model #{german_model}. You can manually install it later with: python3 -m spacy download #{german_model}"
end

# Create dummy Makefile (required by RubyGems)
File.open('Makefile', 'w') do |f|
  f.puts "install:\n\t@echo 'Python dependencies installed'"
  f.puts "clean:\n\t@echo 'Nothing to clean'"
end
