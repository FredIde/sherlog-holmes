# Changelog

## v0.5.2

- Changed jboss pattern to jboss.wildfly (#1)


## v0.5.1

- Accept JBoss log entries that uses a '|' between attributes

## v0.5.0

- Use singular attributes in group option

## v0.4.1

- Use `optparse` instead of `optionparser`

## v0.4.0

- Added support for multiple log files
- Added support for custom attributes using capture groups
- Added JBoss Fuse pattern
- Added support for inheritance of patterns

## v0.3.3

- Apply filters before the entire entry was parsed

## v0.3.2

- Recognize 'Fault' in JBoss exception pattern

## v0.3.1

- Fix JBoss date pattern

## v0.3.0

- Operation to count entries
- Entries can now have multiple exceptions (but the first one will be returned by `#exception`)
- Option to hide stacktrace while printing entries
- Option to set the encode
- Option to negate a filter

## v0.2.0

- Patterns configurable through files
- Code Refactor
- Specs

## v0.1.0

- Initial version