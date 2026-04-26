# Notes on (Character) Encodings


default on rsssf is windows 1256


some pages use unicode encoding bom (byte order mark) aka "magic bytes"



## Encodings

ASCII 7-Bit  (UTF-8 Compatible)

- check all pages if ASCII 7-Bit
  - report all non ascci-7 bit chars


Non-Unicode  (8-Bit/1-Byte) Charsets / pages:

- iso ??
- latin 1  a.k.a. window 1256 ???
- latin 5


Unicode (Multi-Byte)
- UTF-8    -  note - BOM optional  (is a two-byte non-breaking space e.g. )
- UTF-16LE   - check if BOM required?


- report all undef, invalid replace with unicode conversion