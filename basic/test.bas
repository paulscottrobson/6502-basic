;
;	Built using seed 59208
;
assert ("d" < "") = 0
assert ("bab"+"baaa") = "babbaaa"
assert ("" <= "") = -1
assert ("bb" < "") = 0
assert ("daa" <= "dd") = -1
assert ("c" = "") = 0
assert (""+"cddc") = "cddc"
assert ("ccb" <= "b") = 0
assert ("a" <> "bad") = -1
assert ("bcd"+"acb") = "bcdacb"
assert ("" > "bdcd") = 0
assert ("aad"+"dcb") = "aaddcb"
assert ("cca" > "") = -1
assert ("dacd" = "dad") = 0
assert ("cbd"+"b") = "cbdb"
assert ("aa"+"caba") = "aacaba"
assert ("bbbc" > "") = -1
assert ("c" < "b") = 0
assert ("aca" > "") = -1
assert ("dda"+"b") = "ddab"
assert ("dc"+"caca") = "dccaca"
assert ("da" <> "bdda") = -1
assert ("dbd" < "cabc") = 0
assert ("" <= "acdc") = -1
assert ("ccb"+"bbaa") = "ccbbbaa"
assert (""+"ab") = "ab"
assert ("acdd" <> "abd") = -1
assert ("dddd"+"cdda") = "ddddcdda"
assert ("aa"+"bbdb") = "aabbdb"
assert ("d" <= "d") = -1
assert ("a"+"") = "a"
assert ("bda"+"bdc") = "bdabdc"
assert ("a" <> "db") = -1
assert ("ca" >= "b") = -1
assert ("ab" <> "aabd") = -1
assert ("bd" <> "d") = -1
assert ("ab"+"ca") = "abca"
assert ("cd"+"cd") = "cdcd"
assert ("d" < "b") = 0
assert ("bc"+"") = "bc"
assert ("bddb"+"d") = "bddbd"
assert (""+"") = ""
assert ("dacc" >= "ccac") = -1
assert ("b" >= "bdbb") = 0
assert ("c"+"a") = "ca"
assert ("cccb" >= "dcaa") = 0
assert ("c"+"ca") = "cca"
assert ("cdd" <> "da") = -1
assert ("dcc"+"aba") = "dccaba"
assert ("ccca" >= "a") = -1
assert ("" < "cdac") = -1
assert ("cb" <= "d") = -1
assert ("cab" <> "aa") = -1
assert ("bbb" < "bb") = 0
assert ("" < "b") = -1
assert ("dbc" > "c") = -1
assert ("dbdb" <= "dc") = -1
assert ("da" <> "") = -1
assert ("dadb" < "d") = 0
assert (""+"") = ""
assert ("a"+"") = "a"
assert ("b" <= "aa") = 0
assert ("c" > "acdc") = -1
assert ("ccb" = "") = 0
assert ("bc" > "ac") = -1
assert ("bcb" >= "") = -1
assert ("" > "") = 0
assert ("d" > "abab") = -1
assert ("bcad" >= "") = -1
assert ("adac" <> "a") = -1
assert ("bc"+"cd") = "bccd"
assert ("ccb" > "bd") = -1
assert ("bdda"+"") = "bdda"
assert ("bad" <= "bc") = -1
assert ("bc"+"dac") = "bcdac"
assert ("baa"+"") = "baa"
assert (""+"") = ""
assert ("a"+"cb") = "acb"
assert (""+"d") = "d"
assert ("d" > "acd") = -1
assert ("a"+"bdbc") = "abdbc"
assert (""+"bb") = "bb"
assert (""+"ddd") = "ddd"
assert ("caa"+"") = "caa"
assert ("a" >= "dcd") = 0
assert ("acb"+"ca") = "acbca"
assert ("bc" <> "a") = -1
assert ("dcda"+"c") = "dcdac"
assert ("ac" = "") = 0
assert ("cccb"+"ac") = "cccbac"
assert (""+"dd") = "dd"
assert ("dad" = "cbdc") = 0
assert ("bada"+"") = "bada"
assert ("b" >= "aa") = -1
assert ("cc" >= "d") = 0
assert ("babc" = "") = 0
assert ("c" > "ccdb") = 0
assert ("dcb" <> "b") = -1
assert ("dc"+"cb") = "dccb"
assert ("da"+"ac") = "daac"
assert ("bc"+"ca") = "bcca"
assert ("dd" <> "a") = -1
assert ("c" > "db") = 0
assert (""+"a") = "a"
assert ("a" = "") = 0
assert ("c"+"cdda") = "ccdda"
assert ("cdd" <> "") = -1
assert ("dd" <> "") = -1
assert ("c" <> "c") = 0
assert ("cbac" <> "") = -1
assert (""+"") = ""
assert ("bcdd"+"d") = "bcddd"
assert ("ac" <> "abcb") = -1
assert (""+"") = ""
assert ("bccb"+"dcba") = "bccbdcba"
assert ("adbc" >= "") = -1
assert ("dbda"+"cbbd") = "dbdacbbd"
assert ("dca" <= "bdb") = 0
assert ("" < "") = 0
assert ("b"+"") = "b"
assert ("dcac"+"cdb") = "dcaccdb"
assert ("ccdc" >= "ddbc") = 0
assert ("cdda" >= "bbba") = -1
assert ("d"+"cabc") = "dcabc"
assert ("bb" <= "a") = 0
assert ("bdba" > "bdb") = -1
assert ("ac"+"b") = "acb"
assert ("cbda"+"") = "cbda"
assert ("bc" > "db") = 0
assert ("bac" <= "dcd") = -1
assert ("acdc" >= "dbcd") = 0
assert ("bcd"+"cc") = "bcdcc"
assert ("dcaa" <> "adab") = -1
assert ("baaa"+"ccdc") = "baaaccdc"
assert ("dbaa"+"bbab") = "dbaabbab"
assert ("bc" = "b") = 0
assert ("dab" <= "aad") = 0
assert ("c" < "cb") = -1
assert ("bc"+"") = "bc"
assert ("dbad" >= "d") = -1
assert ("bbab"+"bbb") = "bbabbbb"
assert ("d" <> "dca") = -1
assert (""+"") = ""
assert ("bc" <= "d") = -1
assert ("cc"+"d") = "ccd"
assert ("b"+"") = "b"
assert ("abcb"+"db") = "abcbdb"
assert ("acdd" < "bac") = -1
assert ("abb"+"") = "abb"
assert (""+"ada") = "ada"
assert ("cbcc"+"cdbb") = "cbcccdbb"
assert ("a"+"dabc") = "adabc"
assert ("bd" > "dd") = 0
assert ("cb"+"") = "cb"
assert ("dbcd"+"bb") = "dbcdbb"
assert ("bcdc"+"") = "bcdc"
assert ("cab"+"") = "cab"
assert ("dbb"+"da") = "dbbda"
assert ("aab" <= "") = 0
assert ("ddd"+"ba") = "dddba"
assert ("b" = "a") = 0
assert ("da"+"ddd") = "daddd"
assert ("d"+"dada") = "ddada"
assert ("ddbb"+"d") = "ddbbd"
assert ("dcac" <= "ccd") = 0
assert ("ba" = "") = 0
assert ("ddc" < "cc") = 0
assert ("bdcb"+"b") = "bdcbb"
assert ("bdcd" > "d") = 0
assert ("a" = "ba") = 0
assert ("bd"+"cbd") = "bdcbd"
assert ("b" <> "bcc") = -1
assert ("d"+"cb") = "dcb"
assert ("b"+"") = "b"
assert (""+"") = ""
assert ("cadc" > "") = -1
assert ("d"+"cdba") = "dcdba"
assert ("ac"+"") = "ac"
assert ("bb"+"ab") = "bbab"
assert ("cd" > "bdc") = -1
assert ("a"+"acac") = "aacac"
assert ("a"+"bda") = "abda"
assert ("cad"+"dddb") = "caddddb"
assert ("acd" <= "") = 0
assert ("cdcb"+"baa") = "cdcbbaa"
assert ("acb"+"cdc") = "acbcdc"
assert ("bcad" >= "d") = 0
assert ("db" <= "bc") = 0
assert ("dcdb"+"") = "dcdb"
assert (""+"dd") = "dd"
assert ("aaaa"+"bbb") = "aaaabbb"
assert ("cbb"+"c") = "cbbc"
assert ("dac"+"") = "dac"
assert ("cad" = "bccd") = 0
assert ("c" <= "adda") = 0
assert (""+"dccb") = "dccb"
assert ("aa"+"d") = "aad"
assert ("" <> "a") = -1
assert ("dc" > "cdad") = -1
assert ("ba"+"dcdb") = "badcdb"
assert ("ca"+"ac") = "caac"
assert ("d" < "b") = 0
assert ("bbda"+"") = "bbda"
assert ("" <> "d") = -1
assert ("cdca" < "") = 0
assert ("dacb" >= "") = -1
assert ("daab" <> "a") = -1
assert ("acd"+"dda") = "acddda"
assert ("" < "bdc") = -1
assert ("c"+"") = "c"
assert ("bd" <> "") = -1
assert ("" <> "bd") = -1
assert ("acda"+"bbb") = "acdabbb"
assert ("ca" > "d") = 0
assert ("ba"+"b") = "bab"
assert ("dcda"+"b") = "dcdab"
assert ("c" >= "cc") = 0
assert ("cad" = "ddc") = 0
assert ("c"+"ad") = "cad"
assert ("dba" >= "d") = -1
assert ("a"+"ad") = "aad"
assert ("da" <= "db") = -1
assert ("" < "dca") = -1
assert ("b"+"dcd") = "bdcd"
assert ("aba" >= "c") = 0
assert ("ab"+"bda") = "abbda"
assert ("b"+"cd") = "bcd"
assert ("d" < "dd") = -1
assert ("dabb" <= "a") = 0
assert ("dda"+"bcac") = "ddabcac"
assert ("aabc"+"cb") = "aabccb"
assert ("ccb"+"bd") = "ccbbd"
assert (""+"bbda") = "bbda"
assert ("" <= "cbcb") = -1
assert ("cdd" = "d") = 0
assert ("caba"+"daca") = "cabadaca"
assert ("cadb" <= "cccd") = -1
assert ("cbb" <= "cccc") = -1
assert ("b"+"cacc") = "bcacc"
assert ("dcd"+"aadb") = "dcdaadb"
assert ("d" = "abbc") = 0
assert ("" >= "c") = 0
assert ("caa" < "bd") = 0
assert ("" >= "") = -1
assert ("c" <> "bdac") = -1
assert ("cac"+"cc") = "caccc"
assert ("ccda"+"d") = "ccdad"
assert (""+"badb") = "badb"
assert ("ba"+"bd") = "babd"
assert ("cac"+"") = "cac"
assert ("bc"+"dadc") = "bcdadc"
assert (""+"") = ""
assert (""+"") = ""
assert (""+"d") = "d"
assert ("bbcc"+"ddd") = "bbccddd"
assert ("bbcd" >= "a") = -1
assert ("dbbd"+"") = "dbbd"
assert ("c"+"") = "c"
assert ("b"+"a") = "ba"
assert ("dbbb" <> "bb") = -1
assert ("" > "") = 0
assert ("daa" < "bcac") = 0
assert ("ccb" <= "b") = 0
assert ("ad" <> "dbdb") = -1
assert ("a" <= "") = 0
assert ("bddd"+"daaa") = "bddddaaa"
assert ("cacd" >= "cc") = 0
assert ("a"+"daa") = "adaa"
assert ("adbb"+"cbc") = "adbbcbc"
assert ("dac"+"a") = "daca"
assert ("bbb"+"dca") = "bbbdca"
assert (""+"bd") = "bd"
assert ("cca"+"c") = "ccac"
assert ("dc"+"cdb") = "dccdb"
assert ("a"+"ca") = "aca"
assert (""+"bad") = "bad"
assert ("cb"+"") = "cb"
assert ("dbbb" < "") = 0
assert (""+"b") = "b"
assert ("dadb"+"dadb") = "dadbdadb"
assert ("cbdc" <> "ad") = -1
assert ("cacc" <> "ab") = -1
assert ("b" < "") = 0
assert ("b"+"d") = "bd"
assert ("d" >= "bad") = -1
assert ("babb"+"cbcc") = "babbcbcc"
assert ("dbbb"+"d") = "dbbbd"
assert ("ca" > "ab") = -1
assert ("b" = "abb") = 0
assert ("aca"+"") = "aca"
assert ("a"+"ad") = "aad"
assert ("abc" >= "bc") = 0
assert ("bbd" = "") = 0
assert ("dddb"+"abac") = "dddbabac"
assert ("bdaa" <= "") = 0
assert ("" <> "a") = -1
assert (""+"b") = "b"
assert ("bd" <> "ad") = -1
assert ("cbac"+"ca") = "cbacca"
assert ("dc" < "bbad") = 0
assert ("b"+"a") = "ba"
assert ("cca" < "") = 0
assert ("ccac"+"dc") = "ccacdc"
assert ("b" > "dda") = 0
assert (""+"bca") = "bca"
assert ("" >= "") = -1
assert ("b" >= "adbb") = -1
assert ("" >= "adbc") = 0
assert ("aa"+"cd") = "aacd"
assert ("dcd" >= "cb") = -1
assert ("cdbc"+"db") = "cdbcdb"
assert ("a"+"cddc") = "acddc"
assert ("" = "ccda") = 0
assert (""+"ad") = "ad"
assert ("cb" = "ddb") = 0
assert ("d"+"ad") = "dad"
assert ("b"+"dac") = "bdac"
assert ("dbac" > "d") = -1
assert ("dc" > "ac") = -1
assert (""+"ccac") = "ccac"
assert ("" < "dab") = -1
assert ("bb" > "cca") = 0
assert ("cccc" > "b") = -1
assert ("db"+"") = "db"
assert ("aaa" > "dab") = 0
assert ("cc" < "d") = -1
assert ("aab" > "") = -1
assert (""+"dba") = "dba"
assert ("d" <= "ab") = 0
assert ("bdbc" < "aa") = 0
assert ("d" > "") = -1
assert ("b"+"dcd") = "bdcd"
assert ("dcb" = "babb") = 0
assert ("" <> "cb") = -1
assert ("dc" = "") = 0
assert ("a"+"") = "a"
assert ("" <= "dcb") = -1
assert ("ccd" <= "bcc") = 0
assert ("daa"+"ba") = "daaba"
assert ("cd"+"d") = "cdd"
assert ("cd" <= "") = 0
assert ("cb"+"dcba") = "cbdcba"
assert ("c" <> "ba") = -1
assert ("daa" > "baa") = -1
assert ("ad"+"aba") = "adaba"
assert ("bca" > "") = -1
assert ("cabd"+"dadb") = "cabddadb"
assert ("bc" <= "cdcb") = -1
assert ("" <> "") = 0
assert ("bbd"+"") = "bbd"
assert ("d" = "db") = 0
assert ("dabb" < "cb") = 0
assert (""+"ab") = "ab"
assert ("dd"+"bdc") = "ddbdc"
assert ("a" <> "ddda") = -1
assert (""+"") = ""
assert ("ac" <> "") = -1
assert ("b"+"cab") = "bcab"
assert ("db" > "cca") = -1
assert ("accb" = "cd") = 0
assert ("aa" > "ad") = 0
assert ("bccd"+"d") = "bccdd"
assert ("cd" <> "bd") = -1
assert ("daaa" = "dba") = 0
assert ("" > "a") = 0
assert (""+"aca") = "aca"
assert ("aa" < "") = 0
assert ("d"+"") = "d"
assert ("b"+"ccba") = "bccba"
assert ("c" = "bcca") = 0
assert ("cba"+"") = "cba"
assert ("bcb" = "a") = 0
assert (""+"dcdc") = "dcdc"
assert ("" <> "da") = -1
assert ("bb"+"d") = "bbd"
assert ("" < "") = 0
assert ("d" >= "daad") = 0
assert ("c" >= "c") = -1
assert ("c" >= "cacd") = 0
assert ("" > "") = 0
assert ("cd" = "dc") = 0
assert (""+"") = ""
assert ("ad" < "c") = -1
assert ("bc" = "a") = 0
assert ("" < "cabc") = -1
assert ("aa" >= "c") = 0
assert ("" <= "baac") = -1
assert ("ca"+"c") = "cac"
assert (""+"cac") = "cac"
assert ("bada"+"bc") = "badabc"
assert ("d" > "bcd") = -1
assert (""+"dca") = "dca"
assert ("daca"+"a") = "dacaa"
assert ("dd"+"c") = "ddc"
assert ("dab" = "d") = 0
assert ("ddad" < "bcab") = 0
assert ("a" > "") = -1
assert ("bc" >= "ccb") = 0
assert ("bacd"+"dbb") = "bacddbb"
assert ("d"+"bcb") = "dbcb"
assert ("cc" <> "") = -1
assert ("ab"+"ca") = "abca"
assert ("" >= "c") = 0
assert ("dc"+"ccc") = "dcccc"
assert ("" <= "cdd") = -1
assert (""+"bb") = "bb"
assert ("" < "ccb") = -1
assert ("dbd"+"c") = "dbdc"
assert ("abd" >= "aac") = -1
assert (""+"d") = "d"
assert ("ddc" <> "") = -1
assert ("b"+"bcd") = "bbcd"
assert ("bdda" > "abb") = -1
assert ("cbba" > "cddd") = 0
assert ("ba" < "db") = -1
assert ("bcca"+"adda") = "bccaadda"
assert ("aadc" <= "") = 0
assert ("aab" > "") = -1
assert ("dd"+"ccc") = "ddccc"
assert ("b" > "") = -1
assert (""+"c") = "c"
assert ("cb"+"bd") = "cbbd"
assert ("cb" <= "") = 0
assert (""+"ac") = "ac"
assert (""+"a") = "a"
assert ("dca" <> "cdd") = -1
assert (""+"") = ""
assert ("cabb" <> "c") = -1
assert ("abca" = "a") = 0
assert ("da" = "baab") = 0
assert ("c" = "cb") = 0
assert ("dad" < "a") = 0
assert (""+"adda") = "adda"
assert ("ccab" = "") = 0
assert ("a"+"b") = "ab"
assert ("bba"+"da") = "bbada"
assert ("ca" <> "d") = -1
assert ("c" <= "cdc") = -1
assert ("" = "") = -1
assert ("ba" = "a") = 0
assert ("aba"+"") = "aba"
assert ("cb"+"ad") = "cbad"
assert ("" < "") = 0
assert ("cbd" >= "bc") = -1
assert ("a"+"bad") = "abad"
assert ("dbcb" < "adad") = 0
assert (""+"dac") = "dac"
assert ("ad"+"aad") = "adaad"
assert ("bba"+"aacd") = "bbaaacd"
assert ("b" <> "ccca") = -1
assert ("a" <> "aa") = -1
assert ("" <> "") = 0
assert ("dc" <> "ac") = -1
assert ("bcad" <= "ab") = 0
assert ("a" >= "a") = -1
assert ("a" <> "abdb") = -1
assert ("" <> "bc") = -1
assert ("" <> "bdd") = -1
assert ("bdb" <= "ddbb") = -1
assert ("a" = "dd") = 0
assert (""+"cda") = "cda"
assert ("bb" >= "bca") = 0
assert ("c" <= "bcbc") = 0
assert ("bda"+"") = "bda"
assert ("dddb"+"bca") = "dddbbca"
assert ("d" = "ada") = 0
assert ("da"+"ccbd") = "daccbd"
assert ("a" <> "bc") = -1
assert ("b" > "") = -1
assert ("d" <= "") = 0
assert ("b" = "bdba") = 0
assert ("c" <> "adb") = -1
assert (""+"b") = "b"
assert ("ca"+"") = "ca"
assert (""+"cac") = "cac"
assert ("" <= "") = -1
assert ("" >= "dcbd") = 0
assert (""+"cc") = "cc"
assert ("a" <> "a") = 0
assert (""+"") = ""
assert ("dc"+"cacd") = "dccacd"
assert ("dbcc"+"bc") = "dbccbc"
assert ("ab" > "ac") = 0
assert ("db" >= "ba") = -1
assert ("caa" <> "d") = -1
assert ("dbaa"+"bdcd") = "dbaabdcd"
assert ("a"+"caba") = "acaba"
assert ("dc" = "ccaa") = 0
assert (""+"c") = "c"
assert (""+"cac") = "cac"
assert ("d"+"") = "d"
assert ("adc"+"babd") = "adcbabd"
assert ("dc"+"c") = "dcc"
assert ("aad"+"b") = "aadb"
assert ("ccb" > "") = -1
assert ("ddb"+"add") = "ddbadd"
assert ("" = "") = -1
assert ("" <= "ba") = -1
assert (""+"d") = "d"
assert ("" >= "dd") = 0
xemu
