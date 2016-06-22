# ZID: Zen Identifier

ZID stands for "Zen Identifier".

A Zen Identifier is a secure random id, similar to a random UUID (Universally Unique Identifier), with improvements to be faster, easier, more secure, and more sharable.

Tracking:

  * Website: <a href="http://zidplan.com">http://zidplan.com</a>
  * Twitter: <a href="https://twitter.com/zidplan">https://twitter.com/zidplan</a>
  * GitHub: <a href="https://github.com/zidplan">https://github.com/zidplan</a>
  * Contact: Joel Parker Henderson, <joel@joelparkerhenderson.com>

ZID specification:

  * Generate all bits using a secure random generator.
  * Generate as many bits as you like.
  * Describe the ZID by appending the number of bits, for example ZID128 means 128 bits.
  * Any ZID string representation is always all hexadecimal, all lowecase. This means digits 0-9 and lowercase a-f.

See below for a comparison of ZID and UUID.

## Classes

If you're writing a ZID class, we suggest writing these methods:

  * `ZID.create`: generate a new ZID.
  * `ZID.validate(object)`: is an object a valid ZID?
  * `ZID.parse(object)`: parse an object to a new ZID.

## Language Implementations

Many programming languages have two kinds of random number generators: one kind is insecure, and one kind is secure. A Zen Identifier must always use the secure random number generator.

Ruby:

  * Use SecureRandom, not rand.

Swift:

  * Use SecRandomCopyBytes, not arc4random

## ZID vs. UUID comparison

ZID128 is similar to a UUID-4.

Similarities:

  * Both are 128 bit.
  * Both contain randomness.
  * Both can be represented as hexadecimal lowercase strings.

Differences:

  * A ZID specification mandates secure randomness. The UUID spect does not.
  * A ZID is entirely random. UUID-4 has one piece that's not random, that shows the variant number.
  * A ZID string representation is entirely hexadecimal lowercase. A UUID string representation can use dashes, lowercase, uppercase.lowercase.
  * A ZID is specific. UUID-4 is one variant of the overall UUID specification.

To format an ZID in the style of a UUID canonical representation:

    zid = "90f44e35a062479289ff75ab2abc0ed3"
    zid.sub(/(.{8})(.{4})(.{4})(.{16})/,"#$1-#$2-#$3-#$4")
    #=> "90f44e35-a062-4792-89ff75ab2abc0ed3"

Note: the result string is formatted to look like a vaild UUID, but the string is not guaranteed to be valid UUID. This is because the ZID is random while the UUID specification requires a specific bit that indicates the UUID is random.

To format a UUID in the style of an ZID:

    uuid = "14fFE137-2DB2-4A37-A2A4-A04DB1C756CA"
    uuid.gsub(/-/,"").downcase
    #=> ""14f7e1372db24a37a2a4a04db1c756ca"

Note: the result string is formatted to look like a valid ZID, the string is not a valid ZID. This is because the UUID specification requires a random UUID to set the third section's first digit to 4.


## Unix tooling

To generate an ZID on a typical Unix system, you can use the hexdump command:

    $ hexdump -n 16 -v -e '16/1 "%02x" "\n"' /dev/random
    b29dd48b7040f788fd926ebf1f4eddd0

To digest an ZID by using SHA256:

    $ echo -n "b29dd48b7040f788fd926ebf1f4eddd0" | shasum -a 256
    afdfb0400e479285040e541ee87d9227d5731a7232ecfa5a07074ee0ad171c64


## Database tooling

There are many ways to store a ZID in a typical database.

For instance a ZID128 can be stored using any compatible field:

  * A 128-bit field
  * A 32-character string
  * A 16-byte array
  * An unsigned integer 128
  * A UUID-length field

Some databases have specialized fields for 128 bit values, such as PostgreSQL and its UUID extensions. PostgreSQL states that a UUID field will accept a string that is lowercase and that omits dashes. PostgreSQL does not do any validity-checking on the UUID value. Thus it is viable to store an ZID in a UUID field.

Our team has a goal to create a PostgreSQL extension for the ZID data type.

## Credits

* [Joel Parker Henderson](https://github.com/joelparkerhenderson)
* [Michael Pope](https://github.com/amorphid)
* [Bill Lazar](https://github.com/billsaysthis)
