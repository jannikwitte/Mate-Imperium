<!--- DO NOT EDIT THIS FILE - IT'S AUTOMATICALLY GENERATED VIA DEVTOOLS --->

## 1.8.3 2025-06-09


### Fixed

- Raise error on passing a non-module object to Instance (ref #480) (@flash-gordon)


[Compare v1.8.2...v1.8.3](https://github.com/dry-rb/dry-types/compare/v1.8.2...v1.8.3)

## 1.8.2 2025-01-31


### Fixed

- Syntax errors on 3.3.0 (@flash-gordon, see #478)


[Compare v1.8.1...v1.8.2](https://github.com/dry-rb/dry-types/compare/v1.8.1...v1.8.2)

## 1.8.1 2025-01-21


### Fixed

- Warnings about unused block arguments (@flash-gordon, #477)


[Compare v1.8.0...v1.8.1](https://github.com/dry-rb/dry-types/compare/v1.8.0...v1.8.1)

## 1.8.0 2025-01-06


### Added

- Added `Enum#each_value` to iterate over enum values (@CharlieWWW94 in #471)

### Fixed

- Fixed `Default#try` to return correct result (@elcuervo + @flash-gordon in #475)

### Changed

- Set min Ruby version to 3.1 (@flash-gordon)
- Better representation of Enum types (@flash-gordon, see #460)

[Compare v1.7.2...v1.8.0](https://github.com/dry-rb/dry-types/compare/v1.7.2...v1.8.0)

## 1.7.2 2024-01-05


### Fixed

- Fixed BigDecimal warning due to not being required in gemspec (@bkuhlmann in #464)


[Compare v1.7.1...v1.7.2](https://github.com/dry-rb/dry-types/compare/v1.7.1...v1.7.2)

## 1.7.1 2023-02-17


### Fixed

- Warning from jruby about overwritten keyword (@flash-gordon + @klobuczek in #454)


[Compare v1.7.0...v1.7.1](https://github.com/dry-rb/dry-types/compare/v1.7.0...v1.7.1)

## 1.7.0 2022-11-04


### Changed

- This version is compatible with recently released dry-rb dependencies (@flash-gordon)
- Updated to dry-core 1.0 (@flash-gordon + @solnic)
- Dependency on dry-container was dropped (@flash-gordon)

[Compare v1.6.1...v1.7.0](https://github.com/dry-rb/dry-types/compare/v1.6.1...v1.7.0)

## 1.6.1 2022-10-15


### Changed

- Fix issues with internal const_missing and Inflector/Module constants (@flash-gordon + @solnic)

[Compare v1.6.0...v1.6.1](https://github.com/dry-rb/dry-types/compare/v1.6.0...v1.6.1)

## 1.6.0 2022-10-15


### Changed

- Optimize `PredicateRegistry` for Ruby 2.7+ (see #420 for more details) (@casperisfine)
- Use zeitwerk for auto-loading (@flash-gordon)

[Compare v1.5.1...v1.6.0](https://github.com/dry-rb/dry-types/compare/v1.5.1...v1.6.0)

## 1.5.1 2021-02-16


### Fixed

- Add missing requires for internal usage of `Dry::Equalizer` (@timriley in #418)


[Compare v1.5.0...v1.5.1](https://github.com/dry-rb/dry-types/compare/v1.5.0...v1.5.1)

## 1.5.0 2021-01-21


### Added

- Wrapping constructor types :tada: (@flash-gordon)

  Constructor blocks can have a second argument.
  The second argument is the underlying type itself:
  ```ruby
  age_from_year = Dry::Types['coercible.integer'].constructor do |input, type|
    Date.today.year - type.(input)
  end
  age_from_year.('2000') # => 21
  ```
  With wrapping constructors you have control over "type application". You can even
  run it more than once:
  ```ruby
  inc = Dry::Types['integer'].constructor(&:succ)
  inc2x = inc.constructor { _2.(_2.(_2.(_1))) }
  inc2x.(10) # => 13
  ```
- Fallbacks :tada: (@flash-gordon)

  ```ruby
  age = Dry::Types['coercible.ineger'].fallback(18)
  age.('10') # => 10
  age.('20') # => 20
  age.('abc') # => 18
  ```

  Fallbacks are different from default values: the later will be evaluated
  only when *no input* provided.

  Under the hood, `.fallback` creates a wrapping constructor.
- `params.string` as an alias for `strict.string`. This addition should be non-breaking (@flash-gordon)
- API for defining custom type builders similar to `.default`, `.constructor`, or `.optional` (@flash-gordon)

  ```ruby
  # Making an alias for `.fallback`
  Dry::Types.define_builder(:or) { |type, v| type.fallback(v) }

  # Using new builder
  type = Dry::Types['integer'].or(-273)
  type.(:invalid) # => -273
  ```

### Changed

- Inferring predicates from class names is deprecated. It's very unlikely your code depends on it,
  however, if it does, you'll get an exception with instructions. (@flash-gordon)

  If you don't rely on inferring, just disable it with:

  ```ruby
  Dry::Types::PredicateInferrer::Compiler.infer_predicate_by_class_name false
  ```

  Otherwise, enable it explicitly:

  ```ruby
  Dry::Types::PredicateInferrer::Compiler.infer_predicate_by_class_name true
  ```

[Compare v1.4.0...v1.5.0](https://github.com/dry-rb/dry-types/compare/v1.4.0...v1.5.0)

## 1.4.0 2020-03-09


### Fixed

- `json.nil` no longer coerces empty strings to `nil`. It was a long-standing
bug that for some reason remained unnoticed for years. Technically,
this may be a breaking change for JSON schemas described with dry-schema (@flash-gordon)


[Compare v1.3.1...v1.4.0](https://github.com/dry-rb/dry-types/compare/v1.3.1...v1.4.0)

## 1.3.1 2020-02-17


### Changed

- Predicate inferrer now returns `hash?` for hash schemas. Note, it doesn't spit more complex preds because we have different plans for dry-schema (@flash-gordon)

[Compare v1.3.0...v1.3.1](https://github.com/dry-rb/dry-types/compare/v1.3.0...v1.3.1)

## 1.3.0 2020-02-10


### Added

- `Schema#merge` for merging two hash schemas (@waiting-for-dev)
- Aliases for `.constructor` to non-constructor types. Now you can call `.prepend`/`.append` without silly checks for the type being a constructor (flash-gordon)
  ```ruby
  (Dry::Types['integer'].prepend(-> { _1 + 1 })).(1) # => 2
  (Dry::Types['coercible.integer']  >> -> { _1 * 2 }).('99') # => 198
  ```
- `Hash::Schema#clear` returns a schema with the same options but without keys
- Optional namespace now includes strict types by default (@flash-gordon)

### Fixed

- `Schema::Key#optional` returns an instance of `Schema::Key` as it should have done
- Composition with function handling exceptions. This could occasionally lead to unexpected exceptions (@flash-gordon)


[Compare v1.2.2...v1.3.0](https://github.com/dry-rb/dry-types/compare/v1.2.2...v1.3.0)

## 1.2.2 2019-12-14


### Fixed

- `Types.Contructor` doesn't re-wrap class instances implementing type interface, this fixes some quirks in dry-struct (@flash-gordon)

### Changed

- Types now use immutable equalizers. This should improve performance in certain cases e.g. in ROM (flash-gordon)
- Attempting to use non-symbol keys in hash schemas raises an error. We always supported only symbols as keys but there was no check, now it'll throw an argument error. If you want to convert strings to symbols, use `Hash#with_key_transform` (flash-gordon)
- Params and JSON types accept Time/Date/Datetime instances and boolean values. This can be useful in tests but we discourage you from relying on this behavior in production code. For example, building structs with `Params` types is considered a smell. There are dedicated tools for coercion, namely dry-schema and dry-validation. Be responsible user of dry-types! ❤ (flash-gordon)

[Compare v1.2.1...v1.2.2](https://github.com/dry-rb/dry-types/compare/v1.2.1...v1.2.2)

## 1.2.1 2019-11-07


### Fixed

- Fix keyword warnings reported by Ruby 2.7 (flash-gordon)
- Error type in failing case in `Array::Member` (esparta)


[Compare v1.2.0...v1.2.1](https://github.com/dry-rb/dry-types/compare/v1.2.0...v1.2.1)

## 1.2.0 2019-10-06


### Added

- `Optional::Params` types that coerce empty strings to `nil` (flash-gordon)
  ```ruby
  Dry::Types['optional.params.integer'].('') # => nil
  Dry::Types['optional.params.integer'].('140') # => 140
  Dry::Types['optional.params.integer'].('asd') # => exception!
  ```
  Keep in mind, `Dry::Types['optional.params.integer']` and `Dry::Types['params.integer'].optional` are not the same, the latter doesn't handle empty strings.
- Predicate inferrer was ported from dry-schema (authored by solnic)
  ```ruby
  require 'dry/types/predicate_inferrer'
  Dry::Types::PredicateInferrer.new[Types::String]
  # => [:str?]
  Dry::Types::PredicateInferrer.new[Types::String | Types::Integer]
  # => [[[:str?], [:int?]]]
  ```
  Note that the API of the predicate inferrer can change in the stable version, it's dictated by the needs of dry-schema so it should be considered as semi-stable. If you depend on it, write specs covering the desired behavior. Another option is copy-and-paste the whole thing to your project.
- Primitive inferrer was ported from dry-schema (authored by solnic)
  ```ruby
  require 'dry/types/primitive_inferrer'
  Dry::Types::PrimitiveInferrer.new[Types::String]
  # => [String]
  Dry::Types::PrimitiveInferrer.new[Types::String | Types::Integer]
  # => [String, Integer]
  Dry::Types::PrimitiveInferrer.new[Types::String.optional]
  # => [NilClass, String]
  ```
  The primitive inferrer should be stable by now, you can rely on it.
- The `monads` extension adds `Dry::Types::Result#to_monad`. This makes it compatible with do notation from dry-monads. Load it with `Dry::Types.load_extensions(:monads)` (skryukov)

  ```ruby
  Types = Dry.Types
  Dry::Types.load_extensions(:monads)

  class AddTen
    include Dry::Monads[:result, :do]

    def call(input)
      integer = yield Types::Coercible::Integer.try(input)

      Success(integer + 10)
    end
  end
  ```

### Fixed

- Bug with using a `Bool`-named struct as a schema key (flash-gordon)
- A bunch of issues related to using `meta` on complex types (flash-gordon)
- `Types.Constructor(...)` returns a `Types::Array` as it should (flash-gordon)

### Changed

- `Dry::Types.[]` used to work with classes, now it's deprecated (flash-gordon)

[Compare v1.1.1...v1.2.0](https://github.com/dry-rb/dry-types/compare/v1.1.1...v1.2.0)

## 1.1.1 2019-07-26


### Fixed

- A bug where meta was lost for lax array types (flash-gordon)


[Compare v1.1.0...v1.1.1](https://github.com/dry-rb/dry-types/compare/v1.1.0...v1.1.1)

## 1.1.0 2019-07-02


### Added

- New builder method `Interface` constructs a type which accepts objects that respond to the given methods (waiting-for-dev)
  ```ruby
  Types = Dry.Types()
  Types::Callable = Types.Interface(:call)
  Types::Callable.valid?(Object.new) # => false
  Types::Callable.valid?(proc {})    # => true
  ```
- New types: `coercible.symbol`, `params.symbol`, and `json.symbol`, all use `.to_sym` for coercion (waiting-for-dev)

### Fixed

- Converting schema keys to maybe types (flash-gordon)
- Using `Schema#key` and `Array#member` on constuctors (flash-gordon)
- Using `meta(omittable: true)` within `transform_types` works again but produces a warning, please migrate to `.omittable` or `.required(false)` (flash-gordon)
- Bug with a constructror defined on top of enum (flash-gordon)


[Compare v1.0.1...v1.1.0](https://github.com/dry-rb/dry-types/compare/v1.0.1...v1.1.0)

## 1.0.1 2019-06-04


### Added

- In a case of failure the constructor block can now pass a different value (flash-gordon)
  ```ruby
  not_empty_string = Types::String.constructor do |value, &failure|
    value.strip.empty? ? failure.(nil) : value.strip
  end
  not_empty_string.('   ') { |v| v } # => nil
  not_empty_string.lax.('     ')     # => nil
  not_empty_string.lax.(' foo  ')    # => "foo"
  ```
- `Schema#strict` now accepts an boolean argument. If `fales` is passed this will turn a strict schema into a non-strict one (flash-gordon)


[Compare v1.0.0...v1.0.1](https://github.com/dry-rb/dry-types/compare/v1.0.0...v1.0.1)

## 1.0.0 2019-04-23


### Added

- API for custom constructor types was enhanced. If you pass your own callable to `.constructor` it can have a block in its signature. If a block is passed, you must call it on failed coercion, otherwise raise a type coercion error (flash-gordon)
  Example:
  ```ruby
  proc do |input, &block|
    if input.is_a? String
      Integer(input, 10)
    else
      Integer(input)
    end
  rescue ArgumentError, TypeError => error
    if block
      block.call
    else
      raise Dry::Types::CoercionError.new(
        error.message,
        backtrace: error.backtrace
      )
    end
  end
  ```
  This makes the exception handling your job so that dry-types won't have to catch and re-wrap all possible errors (this is not safe, generally speaking).
- Types now can be converted to procs thus you can pass them as blocks (flash-gordon)
  ```ruby
  %w(1 2 3).map(&Types::Coercible::Integer)
  # => [1, 2, 3]
  ```

### Changed

- [BREAKING] Behavior of built-in constructor types was changed to be more strict. They will always raise an error on failed coercion (flash-gordon)
  Compare:

  ```ruby
  # 0.15.0
  Types::Params::Integer.('foo')
  # => "foo"

  # 1.0.0
  Types::Params::Integer.('foo')
  # => Dry::Types::CoercionError: invalid value for Integer(): "foo"
  ```

  To handle coercion errors `Type#call` now yields a block:

  ```ruby
  Types::Params::Integer.('foo') { :invalid } # => :invalid
  ```

  This makes work with coercions more straightforward and way faster.
- [BREAKING] Safe types were renamed to Lax, this name better serves their purpose. The previous name is available but prints a warning (flash-gordon)
- [BREAKING] Metadata is now pushed down to the decorated type. It is not likely you will notice a difference but this a breaking change that enables some use cases in rom related to the usage of default types in relations (flash-gordon)
- Nominal types are now completely unconstrained. This fixes some inconsistencies when using them with constraints. `Nominal#try` will always return a successful result, for the previous behavior use `Nominal#try_coerce` or switch to strict types with passing a block to `#call` (flash-gordon)
- ## Performance improvements
- During the work on this release, a lot of performance improvements were made. dry-types 1.0 combined with dry-logic 1.0 are multiple times faster than dry-types 0.15 and dry-logic 0.5 for common cases including constraints checking and coercion (flash-gordon)

[Compare v0.15.0...v1.0.0](https://github.com/dry-rb/dry-types/compare/v0.15.0...v1.0.0)

## 0.15.0 2019-03-22


### Added

- Improved string representation of types (flash-gordon)
  ```ruby
  Dry::Types['nominal.integer']
  # => #<Dry::Types[Nominal<Integer>]>
  Dry::Types['params.integer']
  # => #<Dry::Types[Constructor<Nominal<Integer> fn=Dry::Types::Coercions::Params.to_int>]>
  Dry::Types['hash'].schema(age?: 'integer')
  # => #<Dry::Types[Constrained<Schema<keys={age?: Constrained<Nominal<Integer> rule=[type?(Integer)]>}> rule=[type?(Hash)]>]>
  Dry::Types['array<integer>']
  # => #<Dry::Types[Constrained<Array<Constrained<Nominal<Integer> rule=[type?(Integer)]>> rule=[type?(Array)]>]>
  ```
- Options for the list of types you want to import with `Dry.Types` (flash-gordon)
  Cherry-pick only certain types:
  ```ruby
  module Types
    include Dry.Types(:strict, :nominal, :coercible)
  end
  Types.constants
  # => [:Strict, :Nominal, :Coercible]
  ```
  Change default top-level types:
  ```ruby
  module Types
    include Dry.Types(default: :coercible)
  end
  # => #<Dry::Types[Constructor<Nominal<Integer> fn=Kernel.Integer>]>
  ```
  Rename type namespaces:
  ```ruby
  module Types
    include Dry.Types(strict: :Strong, coercible: :Kernel)
  end
  ```
- Optional keys for schemas can be provided with ?-ending symbols (flash-gordon)
  ```ruby
  Dry::Types['hash'].schema(name: 'string', age?: 'integer')
  ```
- Another way of making keys optional is setting `required: false` to meta. In fact, it is the preferable
  way if you have to store this information in `meta`, otherwise use the Key's API (see below) (flash-gordon)
  ```ruby
  Dry::Types['hash'].schema(
    name: Dry::Types['string'],
    age: Dry::Types['integer'].meta(required: false)
  )
  ```
- Key types have API for making keys omittable and back (flash-gordon)

  ```ruby
  # defining a base schema with optional keys
  lax_hash = Dry::Types['hash'].with_type_transform { |key| key.required(false) }
  # same as
  lax_hash = Dry::Types['hash'].with_type_transform(&:omittable)

  # keys in user_schema are not required
  user_schema = lax_hash.schema(name: 'string', age: 'integer')
  ```
- `Type#optional?` now recognizes more cases where `nil` is an allowed value (flash-gordon)
- `Constructor#{prepend,append}` with `<<` and `>>` as aliases. `Constructor#append` works the same way `Constructor#constrcutor` does. `Constuctor#prepend` chains functions in the reverse order, see examples (flash-gordon)

  ```ruby
  to_int = Types::Coercible::Integer
  inc = to_int.append { |x| x + 2 }
  inc.("1") # => "1" -> 1 -> 3

  inc = to_int.prepend { |x| x + "2" }
  inc.("1") # => "1" -> "12" -> 12
  ```
- Partial schema application for cases when you want to validate only a subset of keys (flash-gordon)
  This is useful when you want to update a key or two in an already-validated hash. A perfect example is `Dry::Struct#new` where this feature is now used.
  ```ruby
  schema = Dry::Types['hash'].schema(name: 'string', age: 'integer')
  value = schema.(name: 'John', age: 20)
  update = schema.apply({ age: 21 }, skip_missing: true)
  value.merge(update)
  ```

### Fixed

- `Hash::Map` now behaves as a constrained type if its values are constrained (flash-gordon)
- `coercible.integer` now doesn't blow up on invalid strings (exterm)

### Changed

- [BREAKING] Internal representation of hash schemas was changed to be a simple list of key types (flash-gordon)
  `Dry::Types::Hash#with_type_transform` now yields a key type instead of type + name:
  ```ruby
  Dry::Types['strict.hash'].with_type_transform { |key| key.name == :age ? key.required(false) : key }
  ```
- [BREAKING] Definition types were renamed to nominal (flash-gordon)
- [BREAKING] Top-level types returned by `Dry::Types.[]` are now strict (flash-gordon)
  ```ruby
  # before
  Dry::Types['integer']
  # => #<Dry::Types[Nominal<Integer>]>
  # now
  Dry::Types['integer']
  # => <Dry::Types[Constrained<Nominal<Integer> rule=[type?(Integer)]>]>
  # you can still access nominal types using namespace
  Dry::Types['nominal.integer']
  # => #<Dry::Types[Nominal<Integer>]>
  ```
- [BREAKING] Default values are not evaluated if the decorated type returns `nil`. They are triggered on `Undefined` instead (GustavoCaso + flash-gordon)
- [BREAKING] Support for old hash schemas was fully removed. This makes dry-types not compatible with dry-validation < 1.0 (flash-gordon)
- `Dry::Types.module` is deprecated in favor of `Dry.Types` (flash-gordon)
  Keep in mind `Dry.Types` uses strict types for top-level names, that is after
  ```ruby
  module Types
    include Dry.Types
  end
  ```
  `Types::Integer` is a strict type. If you want it to be nominal, use `include Dry.Types(default: :nominal)`. See other options below.
- `params.integer` now always converts strings to decimal numbers, this means `09` will be coerced to `9` (threw an error before) (skryukov)
- Ruby 2.3 is EOL and not officially supported. It may work but we don't test it.

[Compare v0.14.1...v0.15.0](https://github.com/dry-rb/dry-types/compare/v0.14.1...v0.15.0)

## 0.14.1 2019-03-25


### Fixed

- `coercible.integer` now doesn't blow up on invalid strings (exterm)


[Compare v0.14.0...v0.14.1](https://github.com/dry-rb/dry-types/compare/v0.14.0...v0.14.1)

## 0.14.0 2019-01-29


### Fixed

- `valid?` works correctly with constructors now (cgeorgii)

### Changed

- [BREAKING] Support for Ruby 2.2 was dropped. It reached EOL on March 31, 2018.
- `dry-logic` was updated to `~> 0.5` (solnic)

[Compare v0.13.4...v0.14.0](https://github.com/dry-rb/dry-types/compare/v0.13.4...v0.14.0)

## 0.13.4 2018-12-21


### Fixed

- Fixed warnings about keyword arguments from Ruby 2.6. See https://bugs.ruby-lang.org/issues/14183 for all the details (flash-gordon)


[Compare v0.13.3...v0.13.4](https://github.com/dry-rb/dry-types/compare/v0.13.3...v0.13.4)

## 0.13.3 2018-11-25


### Fixed

- `Dry::Types::Hash#try` returns `Failure` instead of throwing an exception on missing keys (GustavoCaso)


[Compare v0.13.2...v0.13.3](https://github.com/dry-rb/dry-types/compare/v0.13.2...v0.13.3)

## 0.13.2 2018-05-30


### Fixed

- `Defaults#valid?` now works fine when passing `Dry::Core::Constans::Undefined` as value (GustavoCaso)
- `valid?` for constructor types wrapping `Sum`s (GustavoCaso)


[Compare v0.13.1...v0.13.2](https://github.com/dry-rb/dry-types/compare/v0.13.1...v0.13.2)

## 0.13.1 2018-05-28


### Added

- `params.int` was added to make the upgrade process in dry-validation smoother (available after you `require 'dry/types/compat/int'`) (flash-gordon)

### Fixed

- Defaults now works fine with meta (GustavoCaso)
- Defaults are now re-decorated properly (flash-gordon)


[Compare v0.13.0...v0.13.1](https://github.com/dry-rb/dry-types/compare/v0.13.0...v0.13.1)

## 0.13.0 2018-05-03


### Added

- Hash schemas were rewritten. The old API is still around but is going to be deprecated and removed before 1.0. The new API is simpler and more flexible. Instead of having a bunch of predefined schemas you can build your own by combining the following methods:

  1. `Schema#with_key_transform`—transforms keys of input hashes, for things like symbolizing etc.
  2. `Schema#strict`—makes a schema intolerant to unknown keys.
  3. `Hash#with_type_transform`—transforms member types with an arbitrary block. For instance,

  ```ruby
  optional_keys = Types::Hash.with_type_transform { |t, _key| t.optional }
  schema = optional_keys.schema(name: 'strict.string', age: 'strict.int')
  schema.(name: "Jane", age: nil) # => {name: "Jane", age: nil}
  ```

  Note that by default all keys are required, if a key is expected to be absent, add to the corresponding type's meta `omittable: true`:

  ```ruby
  intolerant = Types::Hash.schema(name: Types::Strict::String)
  intolerant[{}] # => Dry::Types::MissingKeyError
  tolerant = Types::Hash.schema(name: Types::Strict::String.meta(omittable: true))
  tolerant[{}] # => {}
  tolerant_with_default = Types::Hash.schema(name: Types::Strict::String.meta(omittable: true).default("John"))
  tolerant[{}] # => {name: "John"}
  ```

  The new API is composable in a natural way:

  ```ruby
  TOLERANT = Types::Hash.with_type_transform { |t| t.meta(omittable: true) }.freeze
  user = TOLERANT.schema(name: 'strict.string', age: 'strict.int')
  user.(name: "Jane") # => {name: "Jane"}

  TOLERANT_SYMBOLIZED = TOLERANT.with_key_transform(&:to_sym)
  user_sym = TOLERANT_SYMBOLIZED.schema(name: 'strict.string', age: 'strict.int')
  user_sym.("name" => "Jane") # => {name: "Jane"}
  ```

  (flash-gordon)
- `Types.Strict` is an alias for `Types.Instance` (flash-gordon)
  ```ruby
  strict_range = Types.Strict(Range)
  strict_range == Types.Instance(Range) # => true
  ```
- `Enum#include?` is an alias to `Enum#valid?` (d-Pixie + flash-gordon)
- `Range` was added (GustavoCaso)
- `Array` types filter out `Undefined` values, if you have an array type with a constructor type as its member, the constructor now can return `Dry::Types::Undefined` to indicate empty value:
  ```ruby
  filter_empty_strings = Types::Strict::Array.of(
    Types::Strict::String.constructor { |input|
      input.to_s.yield_self { |s| s.empty? ? Dry::Types::Undefined : s }
    }
  )
  filter_empty_strings.(["John", nil, "", "Jane"]) # => ["John", "Jane"]
  ```
- `Types::Map` was added for homogeneous hashes, when only types of keys and values are known in advance, not specific key names (fledman + flash-gordon)
  ```ruby
    int_to_string = Types::Hash.map('strict.integer', 'strict.string')
    int_to_string[0 => 'foo'] # => { 0 => "foo" }
    int_to_string[0 => 1] # Dry::Types::MapError: input value 1 for key 0 is invalid: type?(String, 1)
  ```
- Enum supports mappings (bolshakov + flash-gordon)
  ```ruby
  dict = Types::Strict::String.enum('draft' => 0, 'published' => 10, 'archived' => 20)
  dict['published'] # => 'published'
  dict[10] # => 'published'
  ```

### Fixed

- Fixed applying constraints to optional type, i.e. `.optional.constrained` works correctly (flash-gordon)
- Fixed enum working with optionals (flash-gordon)
- ## Internal
- Dropped the `dry-configurable` dependency (GustavoCaso)
- The gem now uses `dry-inflector` for inflections instead of `inflecto` (GustavoCaso)

### Changed

- [BREAKING] Renamed `Types::Form` to `Types::Params`. You can opt-in the former name with `require 'dry/types/compat/form_types'`. It will be dropped in the next release (ndrluis)
- [BREAKING] The `Int` types was renamed to `Integer`, this was the only type named differently from the standard Ruby classes so it has been made consistent. The former name is available with `require 'dry/types/compat/int'` (GustavoCaso + flash-gordon)
- [BREAKING] Default types are not evaluated on `nil`. Default values are evaluated _only_ if no value were given.
  ```ruby
    type = Types::Strict::String.default("hello")
    type[nil] # => constraint error
    type[] # => "hello"
  ```
  This change allowed to greatly simplify hash schemas, make them a lot more flexible yet predictable (see below).
- [BREAKING] `Dry::Types.register_class` was removed, `Dry::Types.register` was made private API, do not register your types in the global `dry-types` container, use a module instead, e.g. `Types` (flash-gordon)
- [BREAKING] Enum types don't accept value index anymore. Instead, explicit mapping is supported, see below (flash-gordon)

[Compare v0.12.2...v0.13.0](https://github.com/dry-rb/dry-types/compare/v0.12.2...v0.13.0)

## 0.12.2 2017-11-04


### Fixed

- The type compiler was fixed for simple rules such as used for strict type checks (flash-gordon)
- Fixed an error on `Dry::Types['json.decimal'].try(nil)` (nesaulov)
- Fixed an error on calling `try` on an array type built of constrained types (flash-gordon)
- Implemented `===` for enum types (GustavoCaso)


[Compare v0.12.1...v0.12.2](https://github.com/dry-rb/dry-types/compare/v0.12.1...v0.12.2)

## 0.12.1 2017-10-11


### Fixed

- `Constructor#try` rescues `ArgumentError` (raised in cases like `Integer('foo')`) (flash-gordon)
- `#constructor` works correctly for default and enum types (solnic)
- Optional sum types work correctly in `safe` mode (GustavoCaso)
- The equalizer of constrained types respects meta (flash-gordon)


[Compare v0.12.0...v0.12.1](https://github.com/dry-rb/dry-types/compare/v0.12.0...v0.12.1)

## 0.12.0 2017-09-15


### Added

- A bunch of shortcut methods for constructing types to the autogenerated module, e.g. `Types.Constructor(String, &:to_s)` (flash-gordon)
- ## Deprecated
- `Types::Array#member` was deprecated in favor of `Types::Array#of` (flash-gordon)


[Compare v0.11.1...v0.12.0](https://github.com/dry-rb/dry-types/compare/v0.11.1...v0.12.0)

## 0.11.1 2017-08-14


### Fixed

- Fixed `Constructor#name` with `Sum`-types (flash-gordon)

### Changed

- Constructors are now equalized using `fn` and `meta` too (flash-gordon)

[Compare v0.11.0...v0.11.1](https://github.com/dry-rb/dry-types/compare/v0.11.0...v0.11.1)

## 0.11.0 2017-06-30


### Added

- `#to_ast` available for all type objects (GustavoCaso)
- `Types::Array#of` as an alias for `#member` (maliqq)
- Detailed failure objects are passed to results which improves constraint violation messages (GustavoCaso)


[Compare v0.10.3...v0.11.0](https://github.com/dry-rb/dry-types/compare/v0.10.3...v0.11.0)

## 0.10.3 2017-05-06


### Added

- Callable defaults accept the underlying type (v-kolesnikov)


[Compare v0.10.2...v0.10.3](https://github.com/dry-rb/dry-types/compare/v0.10.2...v0.10.3)

## 0.10.2 2017-04-28


### Fixed

- Fixed `Type#optional?` for sum types (flash-gordon)


[Compare v0.10.1...v0.10.2](https://github.com/dry-rb/dry-types/compare/v0.10.1...v0.10.2)

## 0.10.1 2017-04-28


### Added

- `Type#optional?` returns true if type is Sum and left is nil (GustavoCaso)
- `Type#pristine` returns a type without `meta` (flash-gordon)

### Fixed

- `meta` is used in type equality again (solnic)
- `Any` works correctly with meta again (flash-gordon)


[Compare v0.10.0...v0.10.1](https://github.com/dry-rb/dry-types/compare/v0.10.0...v0.10.1)

## 0.10.0 2017-04-26


### Added

- Types can be used in `case` statements now (GustavoCaso)

### Fixed

- Return original value when Date.parse raises a RangeError (jviney)

### Changed

- Meta data are now stored separately from options (flash-gordon)
- `Types::Object` was renamed to `Types::Any` (flash-gordon)

[Compare v0.9.4...v0.10.0](https://github.com/dry-rb/dry-types/compare/v0.9.4...v0.10.0)

## 0.9.4 2017-01-24


### Added

- Added `Types::Object` which passes an object of any type (flash-gordon)


[Compare v0.9.3...v0.9.4](https://github.com/dry-rb/dry-types/compare/v0.9.3...v0.9.4)

## 0.9.3 2016-12-03


### Fixed

- Updated to dry-core >= 0.2.1 (ruby warnings are gone) (flash-gordon)


[Compare v0.9.2...v0.9.3](https://github.com/dry-rb/dry-types/compare/v0.9.2...v0.9.3)

## 0.9.2 2016-11-13


### Added

- Support for `"Y"` and `"N"` as `true` and `false` values, respectively (scare21410)

### Changed

- Optimized object allocation in hash schemas, resulting in up to 25% speed boost (davydovanton)

[Compare v0.9.1...v0.9.2](https://github.com/dry-rb/dry-types/compare/v0.9.1...v0.9.2)

## 0.9.1 2016-11-04


### Fixed

- `Hash#strict_with_defaults` properly evaluates callable defaults (bolshakov)

### Changed

- `Hash#weak` accepts Hash-descendants again (solnic)

[Compare v0.9.0...v0.9.1](https://github.com/dry-rb/dry-types/compare/v0.9.0...v0.9.1)

## 0.9.0 2016-09-21


### Added

- `Hash#strict_with_defaults` which validates presence of all required keys and respects default types for missing _values_ (backus)
- `Type#constrained?` method (flash-gordon)

### Fixed

- Summing two constrained types works correctly (flash-gordon)
- `Types::Array::Member#valid?` in cases where member type is a constraint (solnic)
- `Hash::Schema#try` handles exceptions properly and returns a failure object (solnic)

### Changed

- [BREAKING] Renamed `Hash##{schema=>permissive}` (backus)
- [BREAKING] `dry-monads` dependency was made optional, Maybe types are available after `Dry::Types.load_extensions(:maybe)` (flash-gordon)
- [BREAKING] `Dry::Types::Struct` and `Dry::Types::Value` have been extracted to [`dry-struct`](https://github.com/dry-rb/dry-struct) (backus)
- `Types::Form::Bool` supports upcased true/false values (kirs)
- `Types::Form::{Date,DateTime,Time}` fail gracefully for invalid input (padde)
- ice_nine dependency has been dropped as it was required by Struct only (flash-gordon)

[Compare v0.8.1...v0.9.0](https://github.com/dry-rb/dry-types/compare/v0.8.1...v0.9.0)

## 0.8.1 2016-07-13


### Fixed

- Compiler no longer chokes on type nodes without args (solnic)
- Removed `bin/console` from gem package (solnic)


[Compare v0.8.0...v0.8.1](https://github.com/dry-rb/dry-types/compare/v0.8.0...v0.8.1)

## 0.8.0 2016-07-01


### Added

- `Struct` now implements `Type` interface so ie `SomeStruct | String` works now (flash-gordon)
- `:weak` Hash constructor which can partially coerce a hash even when it includes invalid values (solnic)
- Types include `Dry::Equalizer` now (flash-gordon)

### Fixed

- `Struct#to_hash` descends into arrays too (nepalez)
- `Default#with` works now (flash-gordon)

### Changed

- `:symbolized` hash schema is now based on `:weak` schema (solnic)
- `Struct::Value` instances are now **deeply frozen** via ice_nine (backus)

[Compare v0.7.2...v0.8.0](https://github.com/dry-rb/dry-types/compare/v0.7.2...v0.8.0)

## 0.7.2 2016-05-11


### Fixed

- `Bool#default` gladly accepts `false` as its value (solnic)
- Creating an empty schema with input processor no longer fails (lasseebert)

### Changed

- Allow multiple calls to meta (solnic)
- Allow capitalised versions of true and false values for boolean coercions (nil0bject)
- Replace kleisli with dry-monads (flash-gordon)
- Use coercions from Kernel (flash-gordon)
- Decimal coercions now work with Float (flash-gordon)
- Coerce empty strings in form posts to blank arrays and hashes (timriley)
- update to use dry-logic v0.2.3 (fran-worley)

[Compare v0.7.1...v0.7.2](https://github.com/dry-rb/dry-types/compare/v0.7.1...v0.7.2)

## 0.7.1 2016-04-06


### Added

- `JSON::*` types with JSON-specific coercions (coop)

### Fixed

- Schema is properly inherited in Struct (backus)
- `constructor_type` is properly inherited in Struct (fbernier)


[Compare v0.7.0...v0.7.1](https://github.com/dry-rb/dry-types/compare/v0.7.0...v0.7.1)

## 0.7.0 2016-03-30

Major focus of this release is to make complex type composition possible and improving constraint errors to be more meaningful.

### Added

- `Type#try` interface that tries to process the input and return a result object which can be either a success or failure (solnic)
- `#meta` interface for setting arbitrary meta data on types (solnic)
- `ConstraintError` has a message which includes information about the predicate which failed ie `nil violates constraints (type?(String) failed)` (solnic)
- `Struct` uses `Dry::Equalizer` too, just like `Value` (AMHOL)
- `Sum::Constrained` which has a disjunction rule built from its types (solnic)
- Compiler supports `[:constructor, [primitive, fn_proc]]` nodes (solnic)
- Compiler supports building schema-less `form.hash` types (solnic)

### Fixed

- `Sum` now supports complex types like `Array` or `Hash` with member types and/or constraints (solnic)
- `Default#constrained` will properly wrap a new constrained type (solnic)

### Changed

- [BREAKING] Renamed `Type#{optional=>maybe}` (AMHOL)
- [BREAKING] `Type#optional(other)` builds a sum: `Strict::Nil | other` (AMHOL)
- [BREAKING] Type objects are now frozen (solnic)
- [BREAKING] `Value` instances are frozen (AMHOL)
- `Array` is no longer a constructor and has a `Array::Member` subclass (solnic)
- `Hash` is no longer a constructor and is split into `Hash::Safe`, `Hash::Strict` and `Hash::Symbolized` (solnic)
- `Constrained` has now a `Constrained::Coercible` subclass which will try to apply its type prior applying its rule (solnic)
- `#maybe` uses `Strict::Nil` now (solnic)
- `Type#default` will raise if `nil` was passed for `Maybe` type (solnic)
- `Hash` with a schema will set maybe values for missing keys or nils (flash-gordon)

[Compare v0.6.0...v0.7.0](https://github.com/dry-rb/dry-types/compare/v0.6.0...v0.7.0)

## 0.6.0 2016-03-16

Renamed from `dry-data` to `dry-types` and:

### Added

- `Dry::Types.module` which returns a namespace for inclusion which has all
  built-in types defined as constants (solnic)
- `Hash#schema` supports default values now (solnic)
- `Hash#symbolized` passes through keys that are already symbols (solnic)
- `Struct.new` uses an empty hash by default as input (solnic)
- `Struct.constructor_type` macro can be used to change attributes constructor (solnic)
- `default` accepts a block now for dynamic values (solnic)
- `Types.register_class` accepts a second arg which is the name of the class'
  constructor method, defaults to `:new` (solnic)

### Fixed

- `Struct` will simply pass-through the input if it is already a struct (solnic)
- `default` will raise if a value violates constraints (solnic)
- Evaluating a default value tries to use type's constructor which makes it work
  with types that may coerce an input into nil (solnic)
- `enum` works just fine with integer-values (solnic)
- `enum` + `default` works just fine (solnic)
- `Optional` no longer responds to `primitive` as it makes no sense since there's
  no single primitive for an optional value (solnic)
- `Optional` passes-through a value which is already a maybe (solnic)

### Changed

- `Dry::Types::Definition` is now the base type definition object (solnic)
- `Dry::Types::Constructor` is now a type definition with a constructor function (solnic)

[Compare v0.5.1...v0.6.0](https://github.com/dry-rb/dry-types/compare/v0.5.1...v0.6.0)

## 0.5.1 2016-01-11


### Added

- `Dry::Data::Type#safe` for types which can skip constructor when primitive does
  not match input's class (solnic)
- `form.array` and `form.hash` safe types (solnic)


[Compare v0.5.0...v0.5.1](https://github.com/dry-rb/dry-types/compare/v0.5.0...v0.5.1)

## 0.5.0 2016-01-11


### Added

- `Type#default` interface for defining a type with a default value (solnic)

### Fixed

- `attribute` raises proper error when type definition is missing (solnic)

### Changed

- [BREAKING] `Dry::Data::Type.new` accepts constructor and _options_ now (solnic)
- Renamed `Dry::Data::Type::{Enum,Constrained}` => `Dry::Data::{Enum,Constrained}` (solnic)
- `dry-logic` is now a dependency for constrained types (solnic)
- Constrained types are now always available (solnic)
- `strict.*` category uses constrained types with `:type?` predicate (solnic)
- `SumType#call` no longer needs to rescue from `TypeError` (solnic)

[Compare v0.4.2...v0.5.0](https://github.com/dry-rb/dry-types/compare/v0.4.2...v0.5.0)

## 0.4.2 2015-12-27


### Added

- Support for arrays in type compiler (solnic)

### Changed

- Array member uses type objects now rather than just their constructors (solnic)

[Compare v0.4.0...v0.4.2](https://github.com/dry-rb/dry-types/compare/v0.4.0...v0.4.2)

## 0.4.0 2015-12-11


### Added

- Support for sum-types with constraint type (solnic)
- `Dry::Data::Type#optional` for defining optional types (solnic)

### Changed

- `Dry::Data['optional']` was **removed** in favor of `Dry::Data::Type#optional` (solnic)

[Compare v0.3.2...v0.4.0](https://github.com/dry-rb/dry-types/compare/v0.3.2...v0.4.0)

## 0.3.2 2015-12-10


### Added

- `Dry::Data::Value` which works like a struct but is a value object with equalizer (solnic)

### Fixed

- Added missing require for `dry-equalizer` (solnic)


[Compare v0.3.1...v0.3.2](https://github.com/dry-rb/dry-types/compare/v0.3.1...v0.3.2)

## 0.3.1 2015-12-09


### Changed

- Removed require of constrained type and make it optional (solnic)

[Compare v0.3.0...v0.3.1](https://github.com/dry-rb/dry-types/compare/v0.3.0...v0.3.1)

## 0.3.0 2015-12-09


### Added

- `Type#constrained` interface for defining constrained types (solnic)
- `Dry::Data` can be configured with a type namespace (solnic)
- `Dry::Data.finalize` can be used to define types as constants under configured namespace (solnic)
- `Dry::Data::Type#enum` for defining an enum from a specific type (solnic)
- New types: `symbol` and `class` along with their `strict` versions (solnic)


[Compare v0.2.1...v0.3.0](https://github.com/dry-rb/dry-types/compare/v0.2.1...v0.3.0)

## 0.2.1 2015-11-30


### Added

- Type compiler supports nested hashes now (solnic)

### Fixed

- `form.bool` sum is using correct right-side `form.false` type (solnic)

### Changed

- Improved structure of the ast (solnic)

[Compare v0.2.0...v0.2.1](https://github.com/dry-rb/dry-types/compare/v0.2.0...v0.2.1)

## 0.2.0 2015-11-29


### Added

- `form.nil` which coerces empty strings to `nil` (solnic)
- `bool` sum-type (true | false) (solnic)
- Type compiler supports sum-types now (solnic)

### Changed

- Constructing optional types uses the new `Dry::Data["optional"]` built-in type (solnic)

[Compare v0.1.0...v0.2.0](https://github.com/dry-rb/dry-types/compare/v0.1.0...v0.2.0)

## 0.1.0 2015-11-27


### Added

- `form.*` coercible types (solnic)
- `Type::Hash#strict` for defining hashes with a strict schema (solnic)
- `Type::Hash#symbolized` for defining hashes that will symbolize keys (solnic)
- `Dry::Data.register_class` short-cut interface for registering a class and
  setting its `.new` method as the constructor (solnic)
- `Dry::Data::Compiler` for building a type from a simple ast (solnic)


[Compare v0.0.1...v0.1.0](https://github.com/dry-rb/dry-types/compare/v0.0.1...v0.1.0)

## 0.0.1 2015-10-05

First public release
