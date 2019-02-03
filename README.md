# ZID: Zen identifier

ZID stands for "Zen identifier", and is a secure unique identifier, good for high-speed, high-security, high-concurrency software.

Contents:

* [Introduction](#introduction)
* [Implementations](#implementations)
  * [C with libsodium](#c-with-libsodium)
  * [JavaScript with libsodium](#javascript-with-libsodium)
  * [Ruby with SecureRandom](#ruby-with-securerandom)
  * [POSIX shell with /dev/urandom](#posix-shell-with-dev-urandom)
  * [Swift with SecRandomCopyBytes](#swift-with-secrandomcopybytes)
* [ZID vs. others](#zid-vs-others)
  * [ZID vs. UUID](#zid-vs-uuid)
  * [ZID vs. ULID](#zid-vs-ulid)
  * [ZID vs. KSUID](#zid-vs-ksuid)
* [Unix tooling](#unix-tooling)
* [Database tooling](#database-tooling)
* [Credits](#credits)


Contacts:

  * Website: <a href="http://zidplan.com">http://zidplan.com</a>
  * Twitter: <a href="https://twitter.com/zidplan">https://twitter.com/zidplan</a>
  * GitHub: <a href="https://github.com/zidplan">https://github.com/zidplan</a>
  * Contact: Joel Parker Henderson, <joel@joelparkerhenderson.com>


## Introduction

ZID stands for "Zen identifier":

  * ZID is a unique identifier e.g. "692dff7b74575a61f2b375b1c7d824cf".

  * ZID is similar to UUID-4 (Universally Unique Identifier with random algorithm).

  * ZID is better than UUID-4 in our epxerience, especially for high-speed, high-security, high-concurrency software.

ZID specification:

  * Generate bits using a secure random generator.

  * Generate as many bits as you like, in multiples of 8.

  * Represent bits as hexadecimal, lowercase, [0-9a-f], 4 bits per character.
  
ZID advantages:

  * ZID is fully random: there is no embedded time stamp, or MAC address, or reserved indicator character.

  * ZID is fully secure: the specification requires high security sources of randomness, such as /dev/urandom.

  * ZID is fully simple: this page has quick easy reference implemenations for many programming languages.
  

## Implementations


### C with libsodium

[https://github.com/zidplan/zid-as-c](https://github.com/zidplan/zid-as-c)

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


### JavaScript with libsodium

[https://github.com/zidplan/zid-as-javascript](https://github.com/zidplan/zid-as-javascript)

```javascript
const _sodium = require('libsodium-wrappers');
(async() => {
  await _sodium.ready;
  const sodium = _sodium;
  var buf = sodium.randombytes_buf(16);
  var str = sodium.to_hex(buf);
  console.log(str);
})();
```


### Ruby with SecureRandom

[https://github.com/zidplan/zid-as-ruby](https://github.com/zidplan/zid-as-ruby)

```ruby
#!/usr/bin/env ruby
require 'securerandom'
puts SecureRandom.hex(16)
```

Note: use SecureRandom, not rand.


### POSIX shell with /dev/urandom

[https://github.com/zidplan/zid-as-shell](https://github.com/zidplan/zid-as-shell)

```sh
#!/bin/sh
set -euf
hexdump -n 16 -v -e '/1 "%02x"' -e "/16 \"\n\"" /dev/urandom
```

Note: use /dev/urandom, not /dev/random.


### Swift with SecRandomCopyBytes

[https://github.com/zidplan/zid-as-swift](https://github.com/zidplan/zid-as-swift)

```swift
let count = 128
var data = [UInt8](count: count/8, repeatedValue: 0)
SecRandomCopyBytes(kSecRandomDefault, data.count, &data)
UnsafeBufferPointer<UInt8>(
  start: UnsafePointer(data.bytes),
  count: data.length
).map {
  String(format: "%02x", $0)
}.joinWithSeparator("")
```

Note: use SecRandomCopyBytes, not arc4random


## ZID vs. others


### ZID vs. UUID

ZID-128 is similar to a UUID-4.

Similarities:

  * Both are 128 bit.

  * Both contain randomness.

  * Both can be represented as hexadecimal lowercase strings.

Differences:

  * ZID specification mandates secure randomness. The UUID spect does not.

  * ZID is entirely random. UUID-4 has one piece that's not random, that shows the variant number.

  * ZID string representation is entirely hexadecimal lowercase. A UUID string representation can use dashes, lowercase, uppercase.lowercase.

  * ZID is specific. UUID-4 is one variant of the overall UUID specification.


### ZID vs. ULID

See https://github.com/ulid/spec

ULID is Universally Unique Lexicographically Sortable Identifier.

Similarities:

  * Both are movitated by UUID v1/v2 being impractical in many environments because of the requirement for a unique stable MAC address.

  * Both are 128-bit-compatible with UUID.

Differences:

  * ZID uses 4 bits per hexadecimal character, which is the most-typical approach of all major Unix systems and programming languages. ULID uses Crockford's base32 which uses 5 bits per character, which results in shorter strings.

  * ZID explicitly specifies lowercase; the ZID team's opinion is that parsing is faster and clearer with case-specification. ULID is case-insensitive.


### ZID vs. KSUID

See https://github.com/segmentio/ksuid

KSUID is for K-Sortable Unique IDentifier. It's a way to generate globally unique IDs similar to RFC 4122 UUIDs, but contain a time component so they can be "roughly" sorted by time of creation. The remainder of the KSUID is randomly generated bytes. 

Similaries:

  * KSUID uses a 32-bit unsigned integer UTC timestamp and a 128-bit randomly generated payload; the payload is essentially a ZID, though a ZID requires high-security random numbers, and a KSUID does not.

Differences:

  * ZID is entirely random. There is no time stamp component.

  * ZID explicity does not try to manage time; the ZID team's opinion is that time coding is better when it uses a separate representation.



## Unix tooling

To generate an ZID on a typical Unix system, you can use the hexdump command:

    $ hexdump -n 16 -v -e '16/1 "%02x" "\n"' /dev/random
    b29dd48b7040f788fd926ebf1f4eddd0

To digest an ZID by using SHA256:

    $ echo -n "b29dd48b7040f788fd926ebf1f4eddd0" | shasum -a 256
    afdfb0400e479285040e541ee87d9227d5731a7232ecfa5a07074ee0ad171c64

To prepend a zid to each line of input of a tab-separated-value file:

    $ cat example.tsv | awk '{ "zid" | getline z; close("zid"); print z "\t" $0 }'


## Database tooling

There are many ways to store a ZID in a typical database.

For instance a ZID-128 can be stored using any compatible field:

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
