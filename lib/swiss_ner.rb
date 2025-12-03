# frozen_string_literal: true

require_relative 'swiss_ner/version'

require 'ruby-spacy'
require 'pycall/import'
# include PyCall::Import

module SwissNer
  class Recognizer
 
    attr_reader :nlp, :patterns

    def initialize(model: "de_core_news_sm")
      PyCall.exec("import sys; sys.path.append('./python')")
      @nlp = Spacy::Language.new(model)
      PyCall.import_module("custom_components")
      @nlp.add_pipe("swiss_phone", last: true)
    end
    
    def setup_patterns
      @nlp.add_pipe("ruby_component", name: "swiss_phone", last: true) do |doc|
        ents = doc.ents.to_a
        doc.text.to_enum(:scan, SWISS_PHONE_RE).each do 
          match = Regexp.last_match
          start_char = match.begin(0)
          end_char = match.end(0)

          span = doc.char_span(start_char, end_char, label: "SWISS_PHONE")
          ents << span if span
        end
        doc.ents = ents
        doc
      end
    end

    def extract_entities(text)
      doc = @nlp.read(text)
      doc.ents.map do |ent|
        {
          text: ent.text,
          label: ent.label_,
          start: ent.start_char,
          end: ent.end_char
        }
      end
    end

    def self.phone_test_texts
      [
        "+41 79 123 45 67",      # International with spaces
        "+41791234567",          # International compact
        "079 123 45 67",         # National with spaces
        "0791234567",            # National compact
        "+41 (0)79 123 45 67",   # With parentheses
        "044 123 45 67",         # Zurich landline
        "+41-79-123-45-67",      # With dashes
        "079-123-45-67",         # National with dashes
        "+49 7156 26147",        # German number 
      ]
    end

    def self.test
      rec = Recognizer.new
      Recognizer.phone_test_texts.each do |nr|
        text = "Rückruf nach Luzern unter: #{nr}"
        e = rec.extract_entities(text)
        puts
        puts text
        puts e
      end
      nil
    end
  end
end
