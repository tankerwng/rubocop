# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    describe SingleLineMethods do
      let(:slm) { SingleLineMethods.new }

      it 'registers an offence for a single-line method' do
        inspect_source(slm, '',
                       ['def some_method; body end',
                        'def link_to(name, url); {:name => name}; end',
                        'def @table.columns; super; end'])
        expect(slm.offences.map(&:message)).to eq(
          [SingleLineMethods::ERROR_MESSAGE] * 3)
      end

      it 'registers an offence for an empty method if so configured' do
        SingleLineMethods.config = { 'AllowIfMethodIsEmpty' => false }
        inspect_source(slm, '', ['def no_op; end',
                                 'def self.resource_class=(klass); end',
                                 'def @table.columns; end'])
        expect(slm.offences.size).to eq(3)
      end

      it 'accepts a single-line empty method if so configured' do
        SingleLineMethods.config = { 'AllowIfMethodIsEmpty' => true }
        inspect_source(slm, '', ['def no_op; end',
                                 'def self.resource_class=(klass); end',
                                 'def @table.columns; end'])
        expect(slm.offences).to be_empty
      end

      it 'accepts a single-line empty method by default' do
        SingleLineMethods.config = {}
        inspect_source(slm, '', ['def no_op; end'])
        expect(slm.offences).to be_empty
      end

      it 'accepts a multi-line method' do
        inspect_source(slm, '', ['def some_method',
                                 '  body',
                                 'end'])
        expect(slm.offences).to be_empty
      end
    end
  end
end
