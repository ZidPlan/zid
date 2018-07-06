# Zid: Zen identifier

Zid stands for "Zen identifier":

  * A Zen identifier is a secure random number, represented as text, such as "692dff7b74575a61f2b375b1c7d824cf".

  * A Zen identifier is similar to a random UUID (Universally Unique Identifier).

  * A Zen identifier can be better than a UUID because a Zen indentifier is often faster, easier, more secure, and more sharable.

Tracking:

  * Website: <a href="http://zidplan.com">http://zidplan.com</a>
  * Twitter: <a href="https://twitter.com/zidplan">https://twitter.com/zidplan</a>
  * GitHub: <a href="https://github.com/zidplan">https://github.com/zidplan</a>
  * Contact: Joel Parker Henderson, <joel@joelparkerhenderson.com>

Zid specification:

  * Generate all bits using a secure random generator.
  * Generate as many bits as you like.
  * Describe the Zid by appending the number of bits, for example Zid-128 means 128 bits.
  * A Zid string representation is all hexadecimal, all lowercase, using digits 0-9 and lowercase a-f.

See below for a comparison of Zid and UUID.

## Classes

If you're writing a Zid class, we suggest writing these methods:

  * `Zid.create`: generate a new Zid.
  * `Zid.validate(object)`: is an object a valid Zid?
  * `Zid.parse(object)`: parse an object to a new Zid.

## Language Implementations

Many programming languages have two kinds of random number generators: one kind is insecure, and one kind is secure. A Zen identifier must always use the secure random number generator.

C with libsodium:

```c
#include <sodium.h>
int main(void)
{
  if (sodium_init() < 0) { exit(1); }
  unsigned int buf_len = 16;
  unsigned char buf[buf_len];
  unsigned int hex_len = buf_len * 2 + 1;
  char hex[hex_len];
  randombytes_buf(buf, buf_len);
  sodium_bin2hex(hex, hex_len, buf, buf_len);
  puts(hex);
}
```

Ruby:

  * Use SecureRandom, not rand.

```ruby
#!/usr/bin/env ruby
require 'securerandom'
puts SecureRandom.hex(16)
```

Shell:

  * Use /dev/urandom, not /dev/random

```sh
#!/bin/sh
set -euf
hexdump -n 16 -v -e '/1 "%02x"' -e "/16 \"\n\"" /dev/urandom
```

Swift:

  * Use SecRandomCopyBytes, not arc4random


## Zid vs. UUID comparison

Zid-128 is similar to a UUID-4.

Similarities:

  * Both are 128 bit.
  * Both contain randomness.
  * Both can be represented as hexadecimal lowercase strings.

Differences:

  * A Zid specification mandates secure randomness. The UUID spect does not.
  * A Zid is entirely random. UUID-4 has one piece that's not random, that shows the variant number.
  * A Zid string representation is entirely hexadecimal lowercase. A UUID string representation can use dashes, lowercase, uppercase.lowercase.
  * A Zid is specific. UUID-4 is one variant of the overall UUID specification.

To format an Zid in the style of a UUID canonical representation:

    zid = "90f44e35a062479289ff75ab2abc0ed3"
    zid.sub(/(.{8})(.{4})(.{4})(.{16})/,"#$1-#$2-#$3-#$4")
    #=> "90f44e35-a062-4792-89ff75ab2abc0ed3"

Note: the result string is formatted to look like a vaild UUID, but the string is not guaranteed to be valid UUID. This is because the Zid is random while the UUID specification requires a specific bit that indicates the UUID is random.

To format a UUID in the style of an Zid:

    uuid = "14fFE137-2DB2-4A37-A2A4-A04DB1C756CA"
    uuid.gsub(/-/,"").downcase
    #=> ""14f7e1372db24a37a2a4a04db1c756ca"

Note: the result string is formatted to look like a valid Zid, the string is not a valid Zid. This is because the UUID specification requires a random UUID to set the third section's first digit to 4.


## Unix tooling

To generate an Zid on a typical Unix system, you can use the hexdump command:

    $ hexdump -n 16 -v -e '16/1 "%02x" "\n"' /dev/random
    b29dd48b7040f788fd926ebf1f4eddd0

To digest an Zid by using SHA256:

    $ echo -n "b29dd48b7040f788fd926ebf1f4eddd0" | shasum -a 256
    afdfb0400e479285040e541ee87d9227d5731a7232ecfa5a07074ee0ad171c64

To prepend a zid to each line of input of a tab-separated-value file:

    $ cat example.tsv | awk '{ "zid" | getline z; close("zid"); print z "\t" $0 }'


## Database tooling

There are many ways to store a Zid in a typical database.

For instance a Zid-128 can be stored using any compatible field:

  * A 128-bit field
  * A 32-character string
  * A 16-byte array
  * An unsigned integer 128
  * A UUID-length field

Some databases have specialized fields for 128 bit values, such as PostgreSQL and its UUID extensions. PostgreSQL states that a UUID field will accept a string that is lowercase and that omits dashes. PostgreSQL does not do any validity-checking on the UUID value. Thus it is viable to store an Zid in a UUID field.

Our team has a goal to create a PostgreSQL extension for the Zid data type.

## Credits

* [Joel Parker Henderson](https://github.com/joelparkerhenderson)
* [Michael Pope](https://github.com/amorphid)
* [Bill Lazar](https://github.com/billsaysthis)
