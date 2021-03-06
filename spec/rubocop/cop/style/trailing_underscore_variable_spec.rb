# encoding: utf-8

require 'spec_helper'

describe RuboCop::Cop::Style::TrailingUnderscoreVariable do
  subject(:cop) { described_class.new }

  it 'registers an offense when the last variable of parallel assignment is ' \
     'an underscore' do
    inspect_source(cop, 'a, b, _ = foo()')

    expect(cop.messages)
      .to eq(['Do not use trailing `_`s in parallel assignment.'])
  end

  it 'registers an offense when multiple underscores are used '\
     'as the last variables of parallel assignment ' do
    inspect_source(cop, 'a, _, _ = foo()')

    expect(cop.messages)
      .to eq(['Do not use trailing `_`s in parallel assignment.'])
  end

  it 'registers an offense when underscore is the second to last variable ' \
     'and blank is the last variable' do
    inspect_source(cop, 'a, _, = foo()')

    expect(cop.messages)
      .to eq(['Do not use trailing `_`s in parallel assignment.'])
  end

  it 'registers an offense when underscore is the only variable ' \
     'in parallel assignment' do
    inspect_source(cop, '_, = foo()')

    expect(cop.messages)
      .to eq(['Do not use trailing `_`s in parallel assignment.'])
  end

  it 'registers an offense for an underscore as the last param ' \
     'when there is also an underscore as the first param' do
    inspect_source(cop, '_, b, _ = foo()')

    expect(cop.messages)
      .to eq(['Do not use trailing `_`s in parallel assignment.'])
  end

  it 'does not register an offense when there are no underscores' do
    inspect_source(cop, 'a, b, c = foo()')

    expect(cop.messages).to be_empty
  end

  it 'does not register an offense for underscores at the beginning' do
    inspect_source(cop, '_, a, b = foo()')

    expect(cop.messages).to be_empty
  end

  it 'does not register an offense for variables starting with an underscore' do
    inspect_source(cop, 'a, b, _c = foo()')

    expect(cop.messages).to be_empty
  end

  describe 'autocorrect' do
    it 'removes trailing underscores automatically' do
      new_source = autocorrect_source(cop, 'a, b, _ = foo()')

      expect(new_source).to eq('a, b, = foo()')
    end

    it 'removes trailing underscores and commas' do
      new_source = autocorrect_source(cop, 'a, b, _, = foo()')

      expect(new_source).to eq('a, b, = foo()')
    end

    it 'removes multiple trailing underscores' do
      new_source = autocorrect_source(cop, 'a, _, _ = foo()')

      expect(new_source).to eq('a, = foo()')
    end

    it 'removes multiple trailing underscores and commas' do
      new_source = autocorrect_source(cop, 'a, _, _, = foo()')

      expect(new_source).to eq('a, = foo()')
    end

    it 'removes trailing comma when it is the only variable' do
      new_source = autocorrect_source(cop, '_, = foo()')

      expect(new_source).to eq('foo()')
    end

    it 'removes multiple trailing underscores and commas' do
      new_source = autocorrect_source(cop, '_, _, _, = foo()')

      expect(new_source).to eq('foo()')
    end
  end
end
