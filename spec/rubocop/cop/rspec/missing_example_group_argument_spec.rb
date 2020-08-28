# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::MissingExampleGroupArgument do
  subject(:cop) { described_class.new }

  it 'accepts describe with an argument' do
    expect_no_offenses(<<-RUBY)
      describe FooClass do
      end

      RSpec.describe FooClass do
      end
    RUBY
  end

  it 'accepts methods with a name like an example block' do
    expect_no_offenses(<<-RUBY)
      Scenario.context do
        'static'
      end
    RUBY
  end

  it 'checks first argument of describe' do
    expect_offense(<<-RUBY)
      describe do
      ^^^^^^^^^^^ The first argument to `describe` should not be empty.
      end

      RSpec.describe do
      ^^^^^^^^^^^^^^^^^ The first argument to `describe` should not be empty.
      end
    RUBY
  end

  it 'checks first argument of nested describe' do
    expect_offense(<<-RUBY)
      describe FooClass do
        describe do
        ^^^^^^^^^^^ The first argument to `describe` should not be empty.
        end

        RSpec.describe do
        ^^^^^^^^^^^^^^^^^ The first argument to `describe` should not be empty.
        end
      end
    RUBY
  end

  it 'checks first argument of context' do
    expect_offense(<<-RUBY)
      context do
      ^^^^^^^^^^ The first argument to `context` should not be empty.
      end
    RUBY
  end

  it 'accepts context without name with included context on next line' do
    expect_no_offenses(<<-RUBY)
      context do
        include_context 'when something is different'
      end
    RUBY
  end

  it 'accepts context without name with included context and tests' do
    expect_no_offenses(<<-RUBY)
      context do
        include_context 'when something is different'

        specify { expect(1 + 2).to eq(3) }
      end
    RUBY
  end
end
