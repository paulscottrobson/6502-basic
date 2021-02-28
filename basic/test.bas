;
;	Built using seed 57134
;
assert ("d" < "db") = -1
assert ("dd"+"bcd") = "ddbcd"
assert ("cadd" = "aba") = 0
assert ("b"+"c") = "bc"
assert ("cdbc"+"") = "cdbc"
assert ("a"+"") = "a"
assert ("d"+"") = "d"
assert ("" < "c") = -1
assert ("b" < "bc") = -1
assert ("" <= "aadd") = -1
assert (""+"c") = "c"
assert ("b"+"bbc") = "bbbc"
assert ("daca" >= "ccb") = -1
assert ("db" <> "db") = 0
assert ("aabd" > "da") = 0
assert ("cbdc"+"cac") = "cbdccac"
assert (""+"bbd") = "bbd"
assert ("adbb"+"") = "adbb"
assert ("aa" <= "b") = -1
assert ("bda"+"adad") = "bdaadad"
assert ("aaaa"+"bdc") = "aaaabdc"
assert ("" < "") = 0
assert ("b" > "cb") = 0
assert ("b" > "b") = 0
assert ("a" <> "c") = -1
assert ("badc" >= "dcab") = 0
assert ("ccc"+"") = "ccc"
assert ("bca"+"accd") = "bcaaccd"
assert ("cb"+"dc") = "cbdc"
assert ("badb" <> "") = -1
assert ("abbb" < "ddbd") = -1
assert ("" >= "c") = 0
assert ("ddd"+"dcdb") = "ddddcdb"
assert ("d"+"cc") = "dcc"
assert (""+"") = ""
assert ("ac" >= "b") = 0
assert ("ba"+"") = "ba"
assert ("c" <= "bcdd") = 0
assert ("" <> "dc") = -1
assert ("" <> "") = 0
assert ("cbb"+"") = "cbb"
assert ("cb"+"d") = "cbd"
assert ("b" > "dbd") = 0
assert ("ab"+"bbb") = "abbbb"
assert ("cca"+"dc") = "ccadc"
assert ("" <> "cac") = -1
assert (""+"a") = "a"
assert ("cd"+"") = "cd"
assert ("bcab"+"bc") = "bcabbc"
assert ("a" = "d") = 0
assert ("cdb"+"cbbd") = "cdbcbbd"
assert ("dcac" <> "cba") = -1
assert ("cb" >= "bcdc") = -1
assert ("a" < "b") = -1
assert (""+"") = ""
assert ("bcca"+"bbcc") = "bccabbcc"
assert ("dd" > "cdb") = -1
assert ("add" > "ad") = -1
assert ("a" < "abb") = -1
assert ("c"+"cac") = "ccac"
assert ("" <= "cbd") = -1
assert ("bbb" <= "a") = 0
assert ("aba"+"acaa") = "abaacaa"
assert ("ad"+"ddc") = "adddc"
assert ("cda" <= "abaa") = 0
assert ("bba"+"aca") = "bbaaca"
assert ("a" <> "cbb") = -1
assert ("acb"+"bdd") = "acbbdd"
assert ("bac"+"a") = "baca"
assert ("bcbd"+"bbd") = "bcbdbbd"
assert ("ca" <> "") = -1
assert ("cbbb"+"aca") = "cbbbaca"
assert ("aadd"+"abdd") = "aaddabdd"
assert ("aab" <> "d") = -1
assert ("d"+"cd") = "dcd"
assert ("" < "acd") = -1
assert ("dacb" = "ccbb") = 0
assert ("a"+"c") = "ac"
assert ("dbaa" > "dbc") = 0
assert ("bd"+"") = "bd"
assert ("bddd" < "ca") = -1
assert (""+"d") = "d"
assert ("cbd" = "abcc") = 0
assert ("" < "a") = -1
assert ("dd" > "dddb") = 0
assert ("cadc"+"ddaa") = "cadcddaa"
assert (""+"dbcb") = "dbcb"
assert ("dc"+"dcab") = "dcdcab"
assert ("ac"+"b") = "acb"
assert ("add" <> "bcd") = -1
assert ("adca" < "c") = -1
assert ("c" = "aaca") = 0
assert ("cdbb" < "bcbd") = 0
assert ("abac" >= "") = -1
assert ("b" > "ccca") = 0
assert ("bad"+"dcc") = "baddcc"
assert ("" < "daca") = -1
assert ("" < "bdab") = -1
assert ("dac"+"") = "dac"
assert (""+"dcd") = "dcd"
assert ("bcc"+"ac") = "bccac"
assert ("c"+"b") = "cb"
assert ("" = "c") = 0
assert ("d"+"bb") = "dbb"
assert ("" > "") = 0
assert ("cbd"+"d") = "cbdd"
assert ("bb"+"acd") = "bbacd"
assert ("b" >= "ca") = 0
assert ("dbc"+"d") = "dbcd"
assert ("bab"+"dbcb") = "babdbcb"
assert ("daba"+"dcd") = "dabadcd"
assert ("" > "cbb") = 0
assert ("dcaa" <= "dcb") = -1
assert (""+"b") = "b"
assert ("bdc" = "bb") = 0
assert ("ab" < "dca") = -1
assert ("c"+"ccda") = "cccda"
assert ("cb" = "bcba") = 0
assert ("cccc"+"a") = "cccca"
assert ("dc"+"bddc") = "dcbddc"
assert ("ac"+"dcb") = "acdcb"
assert ("dcaa"+"bad") = "dcaabad"
assert ("ba"+"") = "ba"
assert (""+"dcb") = "dcb"
assert ("abbd"+"cb") = "abbdcb"
assert ("a" > "") = -1
assert ("d" <> "") = -1
assert ("dadb" <= "") = 0
assert ("" <> "bcd") = -1
assert ("ddbd"+"daa") = "ddbddaa"
assert ("d"+"bdc") = "dbdc"
assert ("c" < "b") = 0
assert ("b" <> "d") = -1
assert ("dcd"+"cddd") = "dcdcddd"
assert ("d" <= "a") = 0
assert ("d" <> "ccca") = -1
assert ("d" < "bcb") = 0
assert (""+"ab") = "ab"
assert ("bcdb"+"") = "bcdb"
assert (""+"cabd") = "cabd"
assert ("d" <= "dcab") = -1
assert ("bacd" > "") = -1
assert ("bcd"+"c") = "bcdc"
assert ("a" < "adda") = -1
assert ("d" = "badd") = 0
assert ("c" <> "da") = -1
assert ("bad" > "abbb") = -1
assert ("d" < "cd") = 0
assert ("" = "bbd") = 0
assert ("cbcc"+"daca") = "cbccdaca"
assert ("" < "a") = -1
assert ("" > "bb") = 0
assert ("cdd" >= "abda") = -1
assert ("c"+"ddca") = "cddca"
assert ("bcba" < "b") = 0
assert ("dba"+"") = "dba"
assert ("" > "aac") = 0
assert ("acba"+"a") = "acbaa"
assert ("aba"+"") = "aba"
assert ("aaad" < "dc") = -1
assert ("dc" < "bdcd") = 0
assert ("bcba" > "dd") = 0
assert ("d"+"cbcc") = "dcbcc"
assert ("b"+"ab") = "bab"
assert ("c" > "d") = 0
assert (""+"dd") = "dd"
assert ("da"+"caba") = "dacaba"
assert ("bd"+"b") = "bdb"
assert ("da" = "dadd") = 0
assert ("babc" >= "dbad") = 0
assert ("ba"+"bc") = "babc"
assert ("ac" >= "dcbb") = 0
assert (""+"bbc") = "bbc"
assert ("bc" = "") = 0
assert ("dcca" >= "b") = -1
assert ("bab" <= "cc") = -1
assert ("cbbb" <> "") = -1
assert ("a" <= "cbd") = -1
assert ("adbd"+"ad") = "adbdad"
assert ("b"+"cd") = "bcd"
assert (""+"dccd") = "dccd"
assert ("ccc"+"ad") = "cccad"
assert ("c"+"baca") = "cbaca"
assert ("adab" > "cdc") = 0
assert ("aac"+"a") = "aaca"
assert ("cc"+"d") = "ccd"
assert ("bb"+"d") = "bbd"
assert ("c"+"bbc") = "cbbc"
assert ("aab" < "ccdb") = -1
assert ("dddc"+"") = "dddc"
assert ("aab" >= "") = -1
assert ("ab" > "b") = 0
assert ("bb"+"") = "bb"
assert ("" >= "d") = 0
assert ("c" >= "acca") = -1
assert (""+"d") = "d"
assert (""+"c") = "c"
assert ("daa"+"dd") = "daadd"
assert ("c" >= "a") = -1
assert ("a" >= "ccc") = 0
assert ("c" < "a") = 0
assert ("b" >= "cd") = 0
assert ("b" <= "a") = 0
assert ("add"+"aaa") = "addaaa"
assert ("aba" <> "cb") = -1
assert (""+"db") = "db"
assert ("ab" <> "aadc") = -1
assert (""+"ba") = "ba"
assert ("d" <> "cca") = -1
assert ("bca" > "b") = -1
assert ("" < "d") = -1
assert ("c" < "cad") = -1
assert ("abd"+"ccc") = "abdccc"
assert ("dabc"+"") = "dabc"
assert ("acad" = "dc") = 0
assert ("adad"+"aabb") = "adadaabb"
assert ("dcaa"+"dca") = "dcaadca"
assert ("a"+"") = "a"
assert ("bbcb"+"ccbb") = "bbcbccbb"
assert ("cdcd"+"dbad") = "cdcddbad"
assert ("db" >= "bca") = -1
assert ("ba" > "a") = -1
assert ("bbab"+"bd") = "bbabbd"
assert ("abbb"+"") = "abbb"
assert ("ada"+"bacd") = "adabacd"
assert (""+"cdcb") = "cdcb"
assert ("ddab" <> "dbb") = -1
assert ("a"+"dd") = "add"
assert ("b" > "ccbb") = 0
assert ("bcba" <> "aa") = -1
assert ("c" = "a") = 0
assert ("d"+"ddd") = "dddd"
assert ("aacc"+"ca") = "aaccca"
assert (""+"b") = "b"
assert ("a"+"c") = "ac"
assert ("bacd"+"dcac") = "bacddcac"
assert ("abb"+"bbbb") = "abbbbbb"
assert ("dc"+"a") = "dca"
assert ("dc" < "bbcb") = 0
assert ("acba" > "") = -1
assert ("adb" >= "cd") = 0
assert ("" <= "") = -1
assert ("" > "aab") = 0
assert ("dacd"+"cc") = "dacdcc"
assert ("c"+"c") = "cc"
assert ("db"+"cbaa") = "dbcbaa"
assert ("dba" <> "") = -1
assert ("dc"+"da") = "dcda"
assert ("d"+"cdbd") = "dcdbd"
assert ("dda"+"") = "dda"
assert ("c"+"db") = "cdb"
assert ("c" >= "cbb") = 0
assert ("c"+"ad") = "cad"
assert ("dd" = "aad") = 0
assert ("d" = "dadd") = 0
assert (""+"caa") = "caa"
assert ("" <= "bb") = -1
assert ("dcdc" >= "dcb") = -1
assert ("cacd" = "b") = 0
assert ("bad"+"ddc") = "badddc"
assert (""+"aab") = "aab"
assert ("bd"+"cbb") = "bdcbb"
assert ("dadb" > "ddba") = 0
assert ("a" >= "bdab") = 0
assert ("acd"+"d") = "acdd"
assert (""+"") = ""
assert (""+"") = ""
assert ("bc"+"a") = "bca"
assert ("d"+"bbda") = "dbbda"
assert (""+"cabb") = "cabb"
assert ("bbcc" <= "ccbc") = -1
assert ("dccc"+"") = "dccc"
assert ("c" < "dbbb") = -1
assert ("bcac"+"bb") = "bcacbb"
assert (""+"") = ""
assert ("bcbd" = "dcdb") = 0
assert ("d"+"dc") = "ddc"
assert ("cb" > "") = -1
assert ("adc"+"") = "adc"
assert ("dcbd"+"") = "dcbd"
assert ("dd"+"db") = "dddb"
assert ("cb" >= "c") = -1
assert (""+"") = ""
assert (""+"dc") = "dc"
assert ("ad" = "c") = 0
assert ("aac"+"b") = "aacb"
assert ("dbd"+"") = "dbd"
assert (""+"b") = "b"
assert ("bbb"+"") = "bbb"
assert ("dd" <= "c") = 0
assert (""+"aa") = "aa"
assert ("cb"+"bd") = "cbbd"
assert (""+"ac") = "ac"
assert (""+"") = ""
assert ("" >= "c") = 0
assert ("abab" <> "ac") = -1
assert ("bcd"+"b") = "bcdb"
assert ("bbdc" <= "") = 0
assert ("da" <= "") = 0
assert ("acc" <= "ca") = -1
assert ("cb" <> "bbb") = -1
assert ("cbba"+"c") = "cbbac"
assert ("c" = "b") = 0
assert ("ab" <= "cba") = -1
assert ("bc" < "cdba") = -1
assert ("" > "ccdd") = 0
assert ("ca" <= "bad") = 0
assert ("dbc" > "") = -1
assert ("bba" <= "cdd") = -1
assert (""+"a") = "a"
assert ("cbc"+"bd") = "cbcbd"
assert ("ada" <> "") = -1
assert ("d"+"") = "d"
assert ("da" >= "") = -1
assert ("aab"+"ba") = "aabba"
assert ("cccc"+"b") = "ccccb"
assert ("a" <> "a") = 0
assert ("da" = "") = 0
assert ("" = "dca") = 0
assert (""+"a") = "a"
assert ("bd"+"bac") = "bdbac"
assert ("dc" >= "dca") = 0
assert ("baab" < "cddd") = -1
assert ("ca"+"bcaa") = "cabcaa"
assert (""+"c") = "c"
assert ("aacc" > "bb") = 0
assert ("baa" = "abc") = 0
assert ("d"+"") = "d"
assert (""+"dca") = "dca"
assert ("" >= "d") = 0
assert ("cdc"+"cbaa") = "cdccbaa"
assert ("b" = "a") = 0
assert ("b" >= "ca") = 0
assert ("cb"+"c") = "cbc"
assert ("dacb" > "") = -1
assert ("dca" > "") = -1
assert ("b" >= "dbc") = 0
assert ("aaa"+"bada") = "aaabada"
assert ("ddb"+"dd") = "ddbdd"
assert ("caba" <> "cd") = -1
assert ("adbc" <> "dca") = -1
assert ("dcb"+"db") = "dcbdb"
assert ("cbca" >= "") = -1
assert ("bbd"+"bada") = "bbdbada"
assert ("ba" <> "cdda") = -1
assert (""+"") = ""
assert ("cad" = "d") = 0
assert ("bc" > "ba") = -1
assert ("cbc" <> "cab") = -1
assert ("d" <= "b") = 0
assert ("acc"+"") = "acc"
assert ("abcb"+"adab") = "abcbadab"
assert ("bbb"+"") = "bbb"
assert ("bbad" = "bcb") = 0
assert ("c"+"cbc") = "ccbc"
assert ("a"+"c") = "ac"
assert ("bbac"+"b") = "bbacb"
assert ("cd"+"dad") = "cddad"
assert ("bdab" <> "") = -1
assert ("bc"+"c") = "bcc"
assert ("dab"+"acc") = "dabacc"
assert ("db"+"bb") = "dbbb"
assert ("abc"+"ad") = "abcad"
assert (""+"bcc") = "bcc"
assert ("dc" <= "dccc") = -1
assert (""+"a") = "a"
assert (""+"caaa") = "caaa"
assert ("ccc" = "") = 0
assert ("cbac" < "a") = 0
assert ("ddbc" <= "dba") = 0
assert ("b"+"cd") = "bcd"
assert ("bac"+"addc") = "bacaddc"
assert ("" > "cdcb") = 0
assert ("" < "") = 0
assert ("a"+"bdd") = "abdd"
assert ("dcad" >= "cd") = -1
assert ("cacd"+"dcbd") = "cacddcbd"
assert ("bddc" = "caca") = 0
assert (""+"cbad") = "cbad"
assert (""+"acb") = "acb"
assert ("c"+"a") = "ca"
assert ("ddd"+"aab") = "dddaab"
assert ("cba"+"cb") = "cbacb"
assert (""+"dd") = "dd"
assert ("cdac"+"cb") = "cdaccb"
assert ("a" < "aacc") = -1
assert ("ab"+"ab") = "abab"
assert ("db"+"bd") = "dbbd"
assert ("dd" = "") = 0
assert ("cc" > "bda") = -1
assert ("c"+"baa") = "cbaa"
assert ("d"+"bddc") = "dbddc"
assert ("d"+"a") = "da"
assert ("adb" < "bbb") = -1
assert (""+"dcab") = "dcab"
assert ("" >= "dc") = 0
assert ("c" <= "acba") = 0
assert ("aabc"+"acdb") = "aabcacdb"
assert ("d" < "da") = -1
assert ("b"+"") = "b"
assert ("bba" > "da") = 0
assert ("a"+"abba") = "aabba"
assert ("" >= "bb") = 0
assert ("cd" < "") = 0
assert ("bcc"+"ca") = "bccca"
assert ("ab"+"cabb") = "abcabb"
assert ("ddb" <= "cdd") = 0
assert ("cbc"+"dcdb") = "cbcdcdb"
assert ("dac"+"a") = "daca"
assert ("dda"+"dda") = "ddadda"
assert ("dab"+"cc") = "dabcc"
assert ("b"+"") = "b"
assert ("a" <> "d") = -1
assert ("aca" > "ac") = -1
assert ("dc"+"cadc") = "dccadc"
assert ("" <> "") = 0
assert (""+"abac") = "abac"
assert ("a"+"c") = "ac"
assert ("aca"+"") = "aca"
assert ("" = "bc") = 0
assert ("da" > "") = -1
assert ("b"+"") = "b"
assert ("dddd" > "b") = -1
assert ("ccbb"+"") = "ccbb"
assert ("cc" <> "bbab") = -1
assert ("ac"+"daa") = "acdaa"
assert ("bac" < "adc") = 0
assert ("" = "bbad") = 0
assert ("bbba"+"bdcb") = "bbbabdcb"
assert ("dabc"+"bada") = "dabcbada"
assert ("bcc"+"d") = "bccd"
assert ("d" <= "bd") = 0
assert ("" <> "c") = -1
assert ("cbcc" >= "cbb") = -1
assert ("baa" >= "b") = -1
assert ("" < "dca") = -1
assert ("ab" >= "baac") = 0
assert ("" <> "") = 0
assert ("accd" > "ccdd") = 0
assert ("adad"+"ac") = "adadac"
assert ("bdbd" > "aad") = -1
assert ("dac" >= "ddac") = 0
assert ("d"+"b") = "db"
assert ("baab"+"dadc") = "baabdadc"
assert ("" = "cddd") = 0
assert ("bab" < "cdc") = -1
assert ("adcd"+"aab") = "adcdaab"
assert ("b"+"") = "b"
assert ("c"+"cacc") = "ccacc"
assert ("a" <> "ccad") = -1
assert ("c" > "bcb") = -1
assert ("bdc" = "cbc") = 0
assert (""+"c") = "c"
assert ("" <> "dbcc") = -1
assert ("c" <> "") = -1
assert ("b" = "bcba") = 0
assert ("dad"+"dddb") = "daddddb"
assert ("b" <> "") = -1
assert ("bdbd" < "") = 0
assert ("" < "acd") = -1
assert ("c" = "") = 0
assert ("acb"+"ccdb") = "acbccdb"
assert ("dd"+"bcbc") = "ddbcbc"
assert ("" < "d") = -1
assert ("cacc"+"") = "cacc"
assert ("" = "ab") = 0
assert ("abac"+"b") = "abacb"
assert (""+"dbba") = "dbba"
assert ("dcc"+"bab") = "dccbab"
assert ("b"+"bab") = "bbab"
assert ("caa"+"d") = "caad"
assert ("dac"+"daab") = "dacdaab"
assert ("a" <> "") = -1
assert ("aadc"+"c") = "aadcc"
assert (""+"dcd") = "dcd"
assert (""+"aaba") = "aaba"
assert ("" < "ac") = -1
assert ("" >= "d") = 0
assert ("c"+"adcd") = "cadcd"
assert ("" > "dcaa") = 0
assert ("bdc"+"") = "bdc"
assert ("ab" = "adc") = 0
assert ("ab"+"ad") = "abad"
assert ("cda" >= "aa") = -1
assert ("dc"+"") = "dc"
assert ("ad"+"") = "ad"
assert ("" <> "") = 0
assert (""+"bb") = "bb"
assert ("aa"+"bdac") = "aabdac"
assert ("cb" <= "") = 0
assert (""+"bbbd") = "bbbd"
assert ("dccd" = "ca") = 0
assert ("b"+"acc") = "bacc"
assert ("baad"+"bd") = "baadbd"
assert ("c"+"dd") = "cdd"
assert ("dcaa"+"bd") = "dcaabd"
assert ("" > "dda") = 0
assert ("c"+"ac") = "cac"
assert ("c" >= "bc") = -1
assert ("" <= "cca") = -1
end