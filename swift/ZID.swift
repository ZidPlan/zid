/// ZID: Zen Identifier
///
/// This is a secure random identifier, similar to a UUID.
/// The ZID can be represented in many ways, such as a bit array,
/// or an unsigned int, or a hexadecimal lowercase string, etc.
///
/// Examples:
///
///     let zid = ZID.create(128)
///     -> new NSData object containing 128 bits of secure random data
///
///     let string = ZID.toString(zid)
///     -> "82813874591063ecaed8a606d25794d6"
///
/// ## Implementation
///
/// In the Swift language, we choose to implement a ZID class
/// by using a subclass of NSData, which is fast and portable.
/// You're welcome to implement a ZID class using another approach.
///
/// ## Why do we use NSData, instead of any other class or struct?
///
/// We use NSData because it's an easy implementation for arbitrary bits.
/// It is widely supported, widely understood, and is generally stable among
/// various Swift versions and also stable among Objective-C versions.
///
/// NSData is a good choice for distributed objects applications,
/// which is one of our most important use cases for ZID items.
///
/// Apple documentation states:
///
///   * NSData and its mutable subclass NSMutableData provide data objects,
///     object-oriented wrappers for byte buffers. Data objects let simple
///     allocated buffers (that is, data with no embedded pointers) take on
///     the behavior of Foundation objects.
///
///   * NSData creates static data objects, and NSMutableData creates
///     dynamic data objects. NSData and NSMutableData are typically used
///     for data storage and are also useful in Distributed Objects
///     applications, where data contained in data objects can be copied
///     or moved between applications.
///
///   * NSData is “toll-free bridged” with its Core Foundation counterpart,
///     CFDataRef, which means it's fast to switch to a CFDataRef object.
///
/// ## Why is it called a "Zen Identifier"?
///
/// Because we like the idea of the data being:
///
///   * Formless, i.e. the data can be any of many data types
///   * Simultaneously meaningful and meaningless
///
/// ## Ideas for alternative implementations
///
///   * [BitArray Swift class](https://github.com/mauriciosantos/Buckets-Swift/blob/master/Source/BitArray.swift)
///   * [UInt256 Swift class](https://github.com/CryptoCoinSwift/UInt256/blob/master/Classes/UInt256.swift)
///
/// ## Thanks
///
///   * [SixArm ZID project](https://github.com/sixarm/sixarm_ruby_zid)
///   * [Safely Generating Cryptographically Secure Random Numbers With Swift - by James Carrol](http://jamescarroll.xyz/2015/09/09/safely-generating-cryptographically-secure-random-numbers-with-swift/)
///   * [Best way to serialize an NSData into a hexadeximal string](http://stackoverflow.com/questions/1305225/best-way-to-serialize-an-nsdata-into-a-hexadeximal-string/25378464#25378464)
///
/// :author: Joel Parker Henderson ( https://joelparkerhenderson.com )
/// :license: LGPL ( https://www.gnu.org/copyleft/lgpl.html )

import Foundation
import Security

public class ZID : NSData {

  /// Create a new ZID object that has the given number of bits.
  ///
  /// Example to create a 128-bit ZID:
  ///
  ///    let zid = ZID.create(128)
  ///    -> a new NSData object with 128 bits of secure random data
  ///
  /// Note: in the current implementation, the number of bits
  /// must be divisible by 8; this is for ease of implementation.
  ///
  public static func create(count: Int) -> NSData {
    // Note: in the current implementation, the function creates
    // a temporary byte array, fills the byte array with random data,
    // then copies the byte array into a new NSData object.
    //
    // TODO research any thread safety issues, such as any risks
    // of leaks across threads, or any risk of another thread changing
    // the memory location near-simultaneously, or malloc/free issues.
    //
    // TODO Is it possible to optimize this function, for example
    // by skipping the initialization of the byte array to zero items,
    // and/or by skipping the byte array and instead creating the NSData
    // object first then filling it with random data?

    // Create a new byte array as a temporary storage area.
    // The byte array lives only for the duration of this function.
    var bytes = [UInt8](count: count/8, repeatedValue: 0)

    // Fill the array with secure random bytes.
    // This uses Swift's built-in secure random generator.
    SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)

    // Create a new NSData object, initialized using the secure bytes.
    // This copies the byte array contents to the new NSData object.
    return NSData(bytes: &bytes, length: bytes.count)
  }

  /// Return the string representation of the ZID,
  /// which is a hexadecimal lowercase string.
  ///
  /// In Swift, we implement this as a typical Swift String.
  /// You're free to use any other kind of String if you like.
  ///
  /// Example:
  ///
  ///     let s = ZID.toString(zid)
  ///     -> ""a694f6805d0e49d384479e46e13b10b8"
  ///
  public static func toString(data: NSData) -> String {
    // This implementation maps each byte to a two-character hex string,
    // then joins the results into one longer string.
    //
    // This implementation iterates on the bytes by using the Swift built-in
    // UnsafeBufferPointer. This is a pointer to an object of type Memory.
    // This type provides no automated memory management, and therefore
    // the code must take care to allocate and free memory appropriately.
    //
    // This function does not allocate memory for the object,
    // and does not free memory for the object, thus is safe.
    //
    // TODO research any thread safety issues, such as any risks
    // of leaks across threads, or any risk of another thread changing
    // the memory location near-simultaneously, or malloc/free issues.
    // TODO Add error handing if the object is not initialized.
    //
    // TODO Research security implicates of UnsafeBufferPointer.
    // For example, are there any potential risks of buffer overflows,
    // or simultaneous modification by other functions or threads, etc.?
    //
    return
      UnsafeBufferPointer<UInt8>(
        start: UnsafePointer(data.bytes),
        count: data.length
        ).map {
          // Format one byte as a hexadecimal string that is two characters,
          // and always digits 0-9 or lowercase letters a, b, c, d, e, f.
          // For example, a byte with all bits off will format as "00",
          // and a byte with all bits on will format as "ff".
          // The format string "%02x" means two-character lowercase hex.
          String(format: "%02x", $0)
        }.joinWithSeparator("")
  }

}
