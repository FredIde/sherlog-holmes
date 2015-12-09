# Sherlog Holmes

*Less data containing useful information is way better than lots of data containing a mess.*

Don't you hate thousands of lines in a log blowing up with your troubleshooting? Lots of useless data that you have to filter just to turn that 300 MB of madness into a 30 KB of useful information. If you need something that can rip off useless entries so you can have a clue about what is going on with that application, you should give Sherlog Holmes a try.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sherlog_holmes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sherlog-holmes

## Concepts

Sherlog works by grabbing every line of a log and parsing it into a simple structure containing:

- Time
- Level
- Category
- Origin
- Message
- Exception
- Stacktrace

You need to supply a regular expression that maps that fields to match your log entry. Here is an example:

```regexp
(<?level>\w+)\s(<?category>\s+)\s(<?message>.+)
```

Notice that you don't need to define every field, just the ones you need to filter.

Patterns for exception and stacktrace should be defined separately. The exception pattern is used only in the message field. Here is a complete example of a pattern configuration:

```yaml
jboss:
  entry: (?<time>[0-9,.:]+)\s+(?<level>\w+)\s+\[(?<category>\S+)\]\s\((?<origin>[^)]+)\)?\s?(?<message>.+)
  exception: (?<exception>\w+(\.\w+)+(Exception|Error))
  stacktrace: ^(\s+at)|(Caused by\:)|(\s+\.{3}\s\d+\smore)
```

The configuration should contain a unique id and at least a pattern for the log **entry**. Place you configuration file in a `*.yml` file inside your `$HOME/.sherlog/patterns` directory and you're ready to go!

## Usage

Shelog Holmes provides the command line tool `sherlog`. You can use this to pass a log, the filters you need to apply and the process that needs to be executed (like showing the filtered entries or counting the exceptions):

`-p, --patterns FILE`

Additionally to having definitions in your `$HOME/.sherlog` directory, you can pass a definition file from anywhere in your machine and Sherlog will scan and register the definitions.

`-c, --category EXPRESSION`

This will filter entries using the category field. You can use the wildcard `*` here.

`-l, --level EXPRESSION`

This will filter entries using the level field. You can use the wildcard `*` here.

`-o, --origin EXPRESSION`

This will filter entries using the origin field. You can use the wildcard `*` here.

`-m, --message EXPRESSION`

This will filter entries using the message field. You can use the wildcard `*` here.

`-e, --exception EXPRESSION`

This will filter entries using the exception field. You can use the wildcard `*` here.

*NOTICE: the expressions are case sensitive, wildcards can be used at start, end or both*

`--any-exception`

This will filter entries with exceptions, regardless the kind.

`--and`

This will use the **AND** operation to connect the next filter. This is the default operation.

`--or`

This will use the **OR** operation to connect the next filter.

    sherlog --level WARN --or --level ERROR --and --any-exception

This is equivalent to:

    (WARN || ERROR) && EXCEPTION

*NOTICE: you cannot do some fuzzy logics with these operations because there are no options to define the precedence*

`-t, --type TYPE`

This will manually set the patterns definitions. If you don't specify this option, Sherlog will try the mapped ones with the first input line.

`--print`

This will instruct Sherlog to print every filtered entries. This is useful to reduce that crazy log file into a sane one.

    $ sherlog --level ERROR --print crazy-log-file.log > sane-log-file.log

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

