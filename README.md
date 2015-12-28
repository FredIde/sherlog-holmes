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

You need to supply a regular expression that maps those fields in order to match your log entry. Here is an example:

```regexp
(<?level>\w+)\s(<?category>\s+)\s(<?message>.+)
```

Notice that you don't need to define every field, just the ones shown in your log.

Patterns for exception and stacktrace should be defined separately. The exception pattern is used only in the message field. Here is a complete example of a pattern configuration:

```yaml
jboss:
  entry: (?<time>[0-9,.:]+)\s+(?<level>\w+)\s+\[(?<category>\S+)\]\s\((?<origin>[^)]+)\)?\s?(?<message>.+)
  exception: (?<exception>\w+(\.\w+)+(Exception|Error))
  stacktrace: ^(\s+at)|(Caused by\:)|(\s+\.{3}\s\d+\smore)
```

The configuration should contain a unique id and at least a pattern for the log **entry**. Place you configuration file in a `*.yml` file inside your `$HOME/.sherlog/patterns` directory and you're ready to go!

### Custom Attributes

Sherlog allows you to define custom attributes by using named capture groups. Any capture group name that differs from the main fields will be stored as a custom attribute in the entry object.

### Configuration Inheritance

You can create a base configuration and then override some values to create another one. In this case, you need to specify the parent configuration with the `from` key:

```yaml
base.java:
  exception: (?<exception>\w+(\.\w+)+(Exception|Error))
  stacktrace: ^(\s+at)|(Caused by\:)|(\s+\.{3}\s\d+\smore)
jboss:
  from: base.java
  entry: (?<time>[0-9,.:]+)\s+(?<level>\w+)\s+\[(?<category>\S+)\]\s\((?<origin>[^)]+)\)?\s?(?<message>.+)
```

## Usage

Shelog Holmes provides the command line tool `sherlog`. You can use this to pass a log, the filters you need to apply and the process that needs to be executed (like showing the filtered entries or counting the exceptions):

### Config Options

`-p, --patterns FILE`

Additionally to having definitions in your `$HOME/.sherlog` directory, you can pass a definition file from anywhere in your machine and Sherlog will scan and register the definitions.

`--encode ENCODE`

This sets the encode to use while reading the log file.

`-t, --type TYPE`

This will manually set the patterns definitions. If you don't specify this option, Sherlog will try the mapped ones with the first input line.

### Filter Options

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

`-f NAME, --field NAME`

This will filter entries using custom attributes found in named capture groups. This parameter specifies the custom attribute name. Use it with `-v | --value` for defining the expression.

`-v EXPRESSION, --value EXPRESSION`

Specifies the expression to use with the last `-f | --field` parameter. The wildcard `*` is accepted here.

### Logical Options

`--and`

This will use the **AND** operation to connect the next filter. This is the default operation.

`--or`

This will use the **OR** operation to connect the next filter.

`--not`

This will negate the next filter.

```
sherlog --level WARN --or --not --level INFO --and --any-exception
```

This is equivalent to:

    (WARN || ! INFO) && EXCEPTION

*NOTICE: try not to do fuzzy logics with this operators*

### Operation Options

`--print`

This will instruct Sherlog to print every filtered entry. This is useful to reduce that crazy log file into a sane one.

```
$ sherlog --level ERROR --print crazy-log-file.log > sane-log-file.log
```

`--no-stacktrace`

This will instruct Sherlog to not print stacktraces for entries. This only has effect if used with `--print`.

`--count GROUPS...`

Set this and Sherlog will count the number of entries per level, category, origin or exception. The possible parameters are (separated by a `,`):

- `levels`: counts the number of entries per level
- `categories`: counts the number of entries per category
- `origins`: counts the number of entries per origin
- `exception`: counts the number of entries per exception
- `all`: counts all groups

```
$ sherlog --count levels,categories log-file.log
```

## Built-in Patterns

Currently, Sherlog has the following patterns:

- `base.java`: base pattern for Java outputs (contains patterns for exceptions and stacktraces only)
- `jboss`: matches Wildfly | EAP logs
- `jboss.fuse`: matches JBoss Fuse logs

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

